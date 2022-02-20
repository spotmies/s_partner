import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:share/share.dart';
import 'package:spotmies_partner/controllers/edit_profile_controller.dart';
import 'package:spotmies_partner/home/drawer%20and%20appBar/editDetailsBS.dart';
import 'package:spotmies_partner/home/drawer%20and%20appBar/help&supportBS.dart';
import 'package:spotmies_partner/providers/partnerDetailsProvider.dart';
import 'package:spotmies_partner/reusable_widgets/elevatedButtonWidget.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';
import 'package:spotmies_partner/utilities/app_config.dart';
import 'package:spotmies_partner/utilities/snackbar.dart';

import '../home/drawer and appBar/catalog_list.dart';

Color colora = ([...Colors.primaries]..shuffle()).first;
Color colorb = ([...Colors.primaries]..shuffle()).first;

class MessageCard extends StatefulWidget {
  final int? statusCode;
  final dynamic alertMessage;
  final String? type;
  final VoidCallback? onClick;
  final dynamic pd;
  const MessageCard(
      {Key? key,
      this.statusCode,
      this.alertMessage,
      this.type,
      this.onClick,
      this.pd})
      : super(key: key);

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 15, right: 15, top: 10),
        padding: EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(children: [
          Container(
            width: width(context) * 0.87,
            child: ListTile(
              // minVerticalPadding: 0,

              horizontalTitleGap: height(context) * 0.01,
              title: TextWid(
                text: widget.type != 'offline'
                    ? 'Hey, you got message!'
                    : 'Your account status',
                size: width(context) * 0.04,
                weight: FontWeight.w600,
                lineSpace: 2.0,
              ),
              subtitle: TextWid(
                text: widget.type != 'offline'
                    ? widget.alertMessage.toString()
                    : verifyText(widget.statusCode),
                flow: TextOverflow.visible,
                size: width(context) * 0.04,
                // align: TextAlign.center,
              ),
              leading: CircleAvatar(
                radius: width(context) * 0.08,
                backgroundColor: widget.type == 'offline' ? colora : colorb,
                child: Icon(
                  widget.type != 'offline' ? Icons.chat_bubble : Icons.info,
                  color: Colors.white,
                ),
              ),
              trailing: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  onPressed: () {
                    // this.widget.onClick!();
                    helpAndSupport(context, widget.pd);
                  },
                  icon: Icon(Icons.help)),
            ),
          ),
          Container(
            width: width(context) * 0.015,
            margin: EdgeInsets.only(
                top: width(context) * 0.03, bottom: width(context) * 0.03),
            decoration: BoxDecoration(
                color: widget.type == 'offline' ? colora : colorb,
                borderRadius: BorderRadius.circular(5)),
          ),
        ]));
  }
}

verifyText(value) {
  switch (value) {
    case 0:
      return 'Your business profile successfully sumbitted to spotmies, shortly your profile sent to verification team, till then please keep checking your app';
    case 1:
      return 'your account is under verification. It might take upto 24 to 48 hours, till then please keep checking your app every 6 hours.';
    case 2:
      return 'Your application rejected due to inappropriate profile picture.\nGo to side menu > edit profile > change profile picture';
    case 3:
      return 'Your application rejected due to invalid mail id.\nGo to side menu > edit profile > change Email id';
    case 4:
      return 'Your application rejected due to inappropriate aadhar front image.\nGo to side menu > edit profile > change aadhar front image';
    case 5:
      return 'Your application rejected due to inappropriate aadhar back image.\nGo to side menu > edit profile > change aadhar back image';
    case 6:
      return 'Your application rejected due to invalid alternate mobile number.\nGo to side menu > edit profile > change alternate mobile number';
    case 7:
      return 'Oops';
    case 8:
      return 'Oops';
    case 9:
      return 'Oops';
    case 10:
      return 'Your document verication process completed successfully';
    default:
  }
}

class SharingCard extends StatefulWidget {
  final PartnerDetailsProvider? provider;
  const SharingCard({Key? key, this.provider}) : super(key: key);
  @override
  _SharingCardState createState() => _SharingCardState();
}

class _SharingCardState extends State<SharingCard> {
  bool loading = false;
  List<dynamic>? getText() {
    Map<dynamic, dynamic>? partnerFull = widget.provider?.partnerDetailsFull;
    Map<dynamic, dynamic>? partner = widget.provider?.profileDetails;
    if (partnerFull?['catelogs'].length < 1) {
      return [
        "Create your Online Store",
        "description for cate online store",
        "spotmies.com/store",
        Icons.store_outlined,
        "Create now",
        0
      ];
    }
    if (partner?["storeId"] == null || partner?["storeId"] == "") {
      return [
        "Create your Store name",
        "Name your store Share your own web store's link on Social media to attract more customers to your service",
        "spotmies.com/your store id",
        Icons.edit,
        "Create now",
        1
      ];
    }
    return [
      "Share More to Earn More",
      "Share your own web store's link on Social media to attract more customers to your service",
      "spotmies.com/store/${partner?["storeId"]}",
      Icons.share,
      "Share",
      2,
      "https://www.spotmies.com/store/${partner?["storeId"]}"
    ];
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    TextEditingController storeIdControl = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          // return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: TextWid(
              text: "Create Store Name",
            ),
            content: StoreIdFormField(
                onChange: (String val) {
                  storeIdControl.text = val;
                },
                text: widget.provider?.partnerDetailsFull!['storeId'] ?? "",
                hint: widget.provider?.partnerDetailsFull!['businessName']),
            actions: [
              ElevatedButtonWidget(
                  onClick: () async {
                    Map<String, String> body = {"storeId": storeIdControl.text};
                    setState(() {
                      loading = true;
                    });
                    dynamic result =
                        await updatePartnerDetails(widget.provider!, body);
                    setState(() {
                      loading = false;
                    });
                    if (result.statusCode == 200) {
                      snackbar(context,
                          "Your storeId created now you can share with your customers");
                      Navigator.pop(context);
                    }
                  },
                  allRadius: true,
                  borderRadius: 5,
                  textSize: width(context) * 0.04,
                  height: 40,
                  minWidth: 120,
                  buttonName: "Save",
                  textColor: Colors.white,
                  leadingIcon: loading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Icon(
                          Icons.check_circle_outline,
                        )),
            ],
          );
          // });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15, top: 10),
      padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextWid(
            text: getText()![0],
            weight: FontWeight.bold,
            size: width(context) * 0.04,
          ),
          TextWid(text: getText()![1], maxlines: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWid(
                text: getText()![2],
                weight: FontWeight.w600,
                color: Colors.indigo,
              ),
              ElevatedButtonWidget(
                height: 40,
                buttonName: getText()![4],
                allRadius: true,
                borderRadius: 15,
                textSize: width(context) * 0.04,
                textColor: Colors.white,
                leadingIcon: Icon(
                  getText()![3],
                  color: Colors.white,
                ),
                onClick: () {
                  switch (getText()![5]) {
                    case 0:
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => Catalog()));
                      break;

                    case 1:
                      _displayTextInputDialog(context);
                      break;
                    case 2:
                      Share.share(getText()![6],
                          subject: "Check my online store");

                      break;
                    default:
                  }
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
