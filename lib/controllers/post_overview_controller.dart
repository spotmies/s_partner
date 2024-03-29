import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:geocoder/geocoder.dart';
// import 'package:geocoder/model.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';
import 'package:spotmies_partner/apiCalls/apiCalling.dart';
import 'package:spotmies_partner/apiCalls/apiUrl.dart';
import 'package:spotmies_partner/chat/personal_chat.dart';
import 'package:spotmies_partner/providers/chat_provider.dart';
import 'package:spotmies_partner/providers/partnerDetailsProvider.dart';
import 'package:spotmies_partner/utilities/snackbar.dart';
import 'package:spotmies_partner/reusable_widgets/geo_coder.dart';

class PostOverViewController extends ControllerMVC {
  var scaffoldkey = GlobalKey<ScaffoldState>();
  var updateFormKey = GlobalKey<FormState>();
  TextEditingController problem = TextEditingController();
  ChatProvider chatProvider;
  PartnerDetailsProvider partnerProvider;
  String title;
  int dropDownValue = 0;
  DateTime pickedDate;
  TextEditingController moneyController = TextEditingController();
  TimeOfDay pickedTime;

  @override
  void initState() {
    chatProvider = Provider.of<ChatProvider>(context, listen: false);
    partnerProvider =
        Provider.of<PartnerDetailsProvider>(context, listen: false);
    super.initState();
    // getAddressofLocation();
  }

  isOrderCompleted({responseId: 175642365745}) async {
    Map<String, String> body = {"orderState": "9"};
    dynamic response = await Server()
        .editMethod(API.updateResponse + responseId.toString(), body);
    if (response.statusCode == 200 || response.statusCode == 204) {
      snackbar(context, "Your order completed waiting for user confirmation");
    } else {
      snackbar(context, "Something went wrong");
    }
  }

  isServiceCompleted({String ordId, String money}) async {
    Map<String, String> body = {
      "isOrderCompletedByPartner": "true",
      "moneyTakenByPartner": money
    };

    partnerProvider.setOrderViewLoader(true);
    dynamic response = await Server().editMethod(API.acceptOrder + ordId, body);
    partnerProvider.setOrderViewLoader(false);
    if (response.statusCode == 200) {
      return snackbar(context, "Order completed successfully");
    }
    snackbar(context, "Something went wrong");
  }

  Widget editAttributes(String field, String ordId, job, money, schedule,
      Coordinates coordinates) {
    return InkWell(
      onTap: () {
        if (field == 'problem') {
          editDialogue(
            'problem',
            ordId,
          );
        }
        if (field == 'amount') {
          editDialogue(
            'amount',
            ordId,
          );
        }
        if (field == 'Schedule') {
          print(field);
        }
      },
      child: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey[100],
          child: Icon(
            Icons.edit,
            color: Colors.blue[900],
          )),
    );
  }

  List options = [
    {
      "name": "Close",
      "icon": Icons.cancel,
    },
    {
      "name": "Info",
      "icon": Icons.info,
    },
    // {
    //   "name": "Re-schedule",
    //   "icon": Icons.refresh,
    // },
    {"name": "Help", "icon": Icons.help},
  ];

  Future chatWithpatner(responseData) async {
    // if (responseProvider.getLoader) return;

    String ordId = responseData['ordId'].toString();
    String pId = responseData['pId'].toString();
    List chatList = chatProvider.getChatList2();
    int index = chatList.indexWhere((element) =>
        element['ordId'].toString() == ordId &&
        element['pId'].toString() == pId);
    log("index $index");
    if (index < 0) {
      // responseProvider.setLoader(true);
      //this means there is no previous chat with this partner about this post
      //create new chat here
      log("creating new chat room");
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      var newChatObj = {
        "msgId": timestamp,
        "msgs":
            "{\"msg\":\"New Chat Created for this service\",\"type\":\"text\",\"sender\":\"bot\",\"time\":$timestamp}",
        "ordId": ordId,
        "pId": pId,
        "uId": responseData['uId'],
        "uDetails": responseData['uDetails']['_id'],
        "pDetails": responseData['pDetails']['_id'],
        "orderDetails": responseData['_id']
      };
      log("chat details $newChatObj");
      partnerProvider.setOrderViewLoader(true);
      var response = await Server().postMethod(API.createNewChat, newChatObj);
      partnerProvider.setOrderViewLoader(false);
      // responseProvider.setLoader(false);
      if (response.statusCode == 200) {
        log("success ${jsonDecode(response.body)}");
        var newChat = jsonDecode(response.body);
        chatProvider.addNewChat(newChat);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PersonalChat(newChat['msgId'].toString())));
      } else {
        log("req failed $response please try again later");
      }
    } else {
      //already there is a conversation about this post with this partner
      var msgId = chatList[index]['msgId'];
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PersonalChat(msgId.toString())));
    }
  }

  pickedDateandTime() async {
    DateTime date = await showDatePicker(
        context: context,
        initialDate: pickedDate,
        firstDate: DateTime(DateTime.now().year - 0, DateTime.now().month - 0,
            DateTime.now().day - 0),
        lastDate: DateTime(DateTime.now().year + 1));
    if (date != null) {
      setState(() async {
        TimeOfDay t = await showTimePicker(
          context: context,
          initialTime: pickedTime,
        );
        if (t != null) {
          setState(() {
            pickedTime = t;
          });
        }
        pickedDate = date;
      });
    }
  }

  orderStateText(String orderState) {
    switch (orderState) {
      case 'req':
        return 'Waiting for conformation';
        break;
      case 'noPartner':
        return 'No technicians found';
        break;
      case 'updated':
        return 'updated';
        break;
      case 'onGoing':
        return 'On Going';
        break;
      case 'completed':
        return 'Completed';
        break;
      case 'cancel':
        return 'Cancelled';
        break;
      default:
        return 'Booking done';
    }
  }

  orderStateIcon(String orderState) {
    switch (orderState) {
      case 'req':
        return Icons.pending_actions;
        break;
      case 'noPartner':
        return Icons.stop_circle;
        break;
      case 'updated':
        return Icons.update;
        break;
      case 'onGoing':
        return Icons.run_circle_rounded;
        break;
      case 'completed':
        return Icons.done_all;
        break;
      case 'cancel':
        return Icons.cancel;
        break;
      default:
        return Icons.search;
    }
  }

  editDialogue(
    edit,
    String ordId,
  ) {
    final hight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final width = MediaQuery.of(context).size.width;
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(edit == 'problem' ? 'update issue' : 'update amount'),
            content: Container(
              width: width * 0.9,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        left: width * 0.03,
                        right: width * 0.03,
                        top: width * 0.03),
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(15)),
                    height: hight * 0.10,
                    width: width * 0.7,
                    child: TextFormField(
                      controller: problem,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please discribe your problem';
                        }
                        return null;
                      },
                      keyboardType: edit == 'problem'
                          ? TextInputType.name
                          : TextInputType.number,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide:
                                BorderSide(width: 1, color: Colors.grey[100])),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide:
                                BorderSide(width: 1, color: Colors.grey[100])),
                        hintStyle: TextStyle(fontSize: 17),
                        hintText: edit == 'problem' ? 'Problem' : 'Amount',
                        suffixIcon: Icon(
                          Icons.error_outline_rounded,
                          color: Colors.blue[900],
                        ),
                        contentPadding: EdgeInsets.only(
                            left: hight * 0.03, top: hight * 0.04),
                      ),
                      onChanged: (value) {
                        this.title = value;
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton.icon(
                  onPressed: () {
                    Server().editMethod(API.acceptOrder + '$ordId', {
                      edit == 'problem' ? 'problem' : 'money': title.toString(),
                    });
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.done_all,
                    color: Colors.blue[900],
                  ),
                  label: Text(
                    'Change',
                    style: TextStyle(color: Colors.blue[900]),
                  ))
            ],
          );
        });
  }

  // getAddressofLocation(Set<double> coordinates) async {
  //   var addresses =
  //       await Geocoder.local.findAddressesFromCoordinates(coordinates);

  //   print(addresses.first.subLocality);

  // setState(() {
  //   add1 = addresses.first.featureName;
  //   add2 = addresses.first.addressLine;
  //   add3 = addresses.first.subLocality;
  // });
  //}

  // pickDate(BuildContext context) async {
  //   DateTime date = await showDatePicker(
  //       confirmText: 'SET DATE',
  //       context: context,
  //       initialDate: pickedDate,
  //       firstDate: DateTime(DateTime.now().year - 0, DateTime.now().month - 0,
  //           DateTime.now().day - 0),
  //       lastDate: DateTime(DateTime.now().year + 1));
  //   if (date != null) {
  //     setState(() {
  //       pickedDate = date;
  //       print(pickedDate.millisecondsSinceEpoch);
  //     });
  //   }
  // }

  // picktime(BuildContext context) async {
  //   TimeOfDay t = await showTimePicker(
  //     context: context,
  //     initialTime: pickedTime,
  //   );
  //   if (t != null) {
  //     setState(() {
  //       pickedTime = t;
  //     });
  //   }
  // }

  List state = ['Waiting for confirmation', 'Ongoing', 'Completed'];
  List icons = [
    Icons.pending_actions,
    Icons.run_circle_rounded,
    Icons.done_all
  ];

  int currentStep = 0;
}
