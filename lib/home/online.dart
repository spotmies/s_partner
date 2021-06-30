import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:spotmies_partner/apiCalls/apiCalling.dart';
import 'package:spotmies_partner/apiCalls/apiUrl.dart';
import 'package:spotmies_partner/providers/inComingOrdersProviders.dart';
import 'package:spotmies_partner/providers/partnerDetailsProvider.dart';

void main() {
  runApp(Online());
}

class Online extends StatefulWidget {
  @override
  _OnlineState createState() => _OnlineState();
}

class _OnlineState extends State<Online> {
  var path;
  var userid;
  var orderid;
  var incoming;
  var partner;

  String pmoney;
  DateTime pickedDate;
  TimeOfDay pickedTime;
  List jobs = [
    'AC Service',
    'Computer',
    'TV Repair',
    'Development',
    'Tutor',
    'Beauty',
    'Photography',
    'Drivers',
    'Events'
  ];
  @override
  void initState() {
    incoming = Provider.of<IncomingOrdersProvider>(context, listen: false);
    partner = Provider.of<PartnerDetailsProvider>(context, listen: false);
    partner.localData();
    incoming.incomingOrders();
    incoming.localStore();
    incoming.localGet();
    super.initState();
    pickedDate = DateTime.now();
    pickedTime = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    final _hight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.grey[50],
        body: Consumer<PartnerDetailsProvider>(builder: (context, data, child) {
          if (data.local == null)
            return Center(child: CircularProgressIndicator());
          var p = data.local;

          // print(p);
          return Consumer<IncomingOrdersProvider>(
              builder: (context, data, child) {
            if (data.orders == null)
              return Center(child: CircularProgressIndicator());
            var o = data.orders;
            return Container(
                padding: EdgeInsets.all(10),
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: o.length,
                    padding: EdgeInsets.all(15),
                    itemBuilder: (BuildContext ctxt, int index) {
                      var u = o[index]['uDetails'];
                      List<String> images = List.from(o[index]['media']);
                      // print(o['media'][0].length);
                      return Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 15, right: 10),
                            height: _hight * 0.045,
                            decoration: BoxDecoration(
                                color: Colors.blue[900],
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15)),
                                boxShadow: kElevationToShadow[0]),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  jobs.elementAt(o[index]['job']),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                                IconButton(
                                    icon: Icon(
                                      Icons.more_horiz,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      moredialogue(
                                          o[index]['uId'],
                                          o[index]['_id'],
                                          o[index]['ordId'],
                                          o[index]['pId'],
                                          u['_id'],
                                          p['_id']);
                                    })
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            height: _hight * 0.45,
                            width: _width * 0.88,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15)),
                                boxShadow: kElevationToShadow[0]),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: _hight * 0.015,
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {},
                                        child: Container(
                                          height: _hight * 0.15,
                                          width: _width * 0.2,
                                          // child: CircleAvatar(
                                          //   backgroundImage: images == null
                                          //       ? NetworkImage(images.first)
                                          //       : Icon(Icons.ac_unit),
                                          //)
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            o[index]['problem'].toString(),
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: _hight * 0.018,
                                ),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  height: _hight * 0.07,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        flex: 2,
                                        // width: _width * 0.4,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Money:',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                SizedBox(
                                                  width: _width * 0.05,
                                                ),
                                                Text(
                                                    o[index]['money']
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize:
                                                            _width * 0.02)),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text('Location:',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500)),
                                                SizedBox(
                                                  width: _width * 0.02,
                                                ),
                                                Text(
                                                    o[index]['loc'][0]
                                                            .toString() +
                                                        "," +
                                                        o[index]['loc'][1]
                                                            .toString(),
                                                    style: TextStyle(
                                                        fontSize:
                                                            _width * 0.02)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: _width * 0.3,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text('Date',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500)),
                                                Text(
                                                    o[index]['schedule']
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize:
                                                            _width * 0.02)),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text('Time',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500)),
                                                Text(
                                                  o[index]['schedule']
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: _width * 0.02),
                                                ),
                                              ],
                                            )
                                            // .millisecondsSinceEpoch
                                            // .toString()),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                o[index]['ordState'] == 'req'
                                    ? Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: _width * 0.4,
                                                child: ElevatedButton(
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(
                                                                    Colors.blue[
                                                                        900])),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                            color: Colors
                                                                .blue[900],
                                                            child: Icon(
                                                                Icons
                                                                    .check_circle,
                                                                color: Color(
                                                                    0xff00c853))),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            'Accept',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    //color: Colors.blue[900],
                                                    onPressed: () async {
                                                      var ordid =
                                                          o[index]['ordId'];
                                                      var api = API.acceptOrder
                                                              .toString() +
                                                          "$ordid";
                                                      print(api);
                                                      Server().editMethod(api, {
                                                        'pId':
                                                            API.pid.toString(),
                                                        'ordState': 'onGoing'
                                                      }).catchError((e) {
                                                        print(e);
                                                      });
                                                    }),
                                              ),
                                              Container(
                                                width: _width * 0.4,
                                                child: ElevatedButton(
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(
                                                                    Colors.blue[
                                                                        900])),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            'Reject  ',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Container(
                                                            child: Icon(
                                                                Icons.cancel,
                                                                color: Color(
                                                                    0xfff50000))),
                                                      ],
                                                    ),
                                                    // color: Colors.blue[900],
                                                    onPressed: () {}),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    : Text('Order Accepted')
                              ],
                            ),
                          ),
                        ],
                      );
                    }));
          });
        }));
  }

  _pickedDate() async {
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

  moredialogue(uid, ordDetails, ordid, pid, uDetails, pDetails) {
    return showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
              title: Text('Update your possible prices and time'),
              // message: Text('data'),
              actions: [
                CupertinoActionSheetAction(
                    isDefaultAction: true,
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Customize'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        _pickedDate();
                                      },
                                      child: Container(
                                        //padding: EdgeInsets.all(10),
                                        height: 60,
                                        width: 380,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                                'Date:  ${pickedDate.day}/${pickedDate.month}/${pickedDate.year}',
                                                style: TextStyle(fontSize: 15)),
                                            Text(
                                                'Time:  ${pickedTime.hour}:${pickedTime.minute}',
                                                style: TextStyle(fontSize: 15))
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      //padding: EdgeInsets.all(10),
                                      height: 60,
                                      width: 380,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: TextField(
                                        cursorColor: Colors.amber,
                                        keyboardType: TextInputType.phone,
                                        //maxLines: 2,
                                        //maxLength: 20,
                                        decoration: InputDecoration(
                                          hintStyle: TextStyle(fontSize: 17),
                                          hintText: 'Money',
                                          suffixIcon: Icon(
                                            Icons.change_history,
                                            color: Colors.blue[800],
                                          ),
                                          //border: InputBorder.none,
                                          contentPadding: EdgeInsets.all(20),
                                        ),
                                        onChanged: (value) {
                                          pmoney = value;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                Center(
                                  child: ElevatedButton(
                                      // color: Colors.blue[800],
                                      child: Text('Done'),
                                      onPressed: () async {
                                        var body = {
                                          "money": pmoney.toString(),
                                          "schedule": pickedDate
                                              .millisecondsSinceEpoch
                                              .toString(),
                                          "uId": uid.toString(),
                                          "pId": API.pid.toString(),
                                          "ordId": ordid.toString(),
                                          "orderDetails": ordDetails.toString(),
                                          "responseId": DateTime.now()
                                              .millisecondsSinceEpoch
                                              .toString(),
                                          "join": DateTime.now()
                                              .millisecondsSinceEpoch
                                              .toString(),
                                          "loc.0": 17.236.toString(),
                                          "loc.1": 83.697.toString(),
                                          "uDetails": uDetails.toString(),
                                          "pDetails": pDetails.toString()
                                        };
                                        //print(uDetails);
                                        print(body);

                                        Server()
                                            .postMethod(API.updateOrder, body);
                                      }),
                                ),
                              ],
                            );
                          });
                    },
                    child: Text('Update Bid',
                        style: TextStyle(color: Colors.black))),
              ],
              cancelButton: CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black),
                  )),
            ));
  }

  // FirebaseFirestore
  //     .instance
  //     .collection(
  //         'partner')
  //     .doc(FirebaseAuth
  //         .instance
  //         .currentUser
  //         .uid)
  //     .collection(
  //         'orders')
  //     .doc(document[
  //         'orderid'])
  //     .update({
  //   'request':
  //       false,
  // });
  // var pid = [
  //   FirebaseAuth
  //       .instance
  //       .currentUser
  //       .uid,
  // ];
  // FirebaseFirestore
  //     .instance
  //     .collection(
  //         'allads')
  //     .doc(document[
  //         'orderid'])
  //     .update({
  //   'request':
  //       false,
  //   'reject': FieldValue
  //       .arrayUnion(
  //           pid)
  // });

  // image(){
  //   return showDialog(
  //                                           context: context,
  //                                           builder: (BuildContext context) {
  //                                             return AlertDialog(
  //                                               backgroundColor:
  //                                                   Colors.transparent,
  //                                               insetPadding: EdgeInsets.zero,
  //                                               contentPadding: EdgeInsets.zero,
  //                                               clipBehavior:
  //                                                   Clip.antiAliasWithSaveLayer,
  //                                               actions: [
  //                                                 Container(
  //                                                     height: _hight * 0.35,
  //                                                     width: _width * 1,
  //                                                     child: CarouselSlider
  //                                                         .builder(
  //                                                       itemCount:
  //                                                           images.length,
  //                                                       itemBuilder: (ctx,
  //                                                           index, realIdx) {
  //                                                         return Container(
  //                                                             child: Image.network(images[
  //                                                                     index]
  //                                                                 .substring(
  //                                                                     0,
  //                                                                     images[index]
  //                                                                             .length -
  //                                                                         1)));
  //                                                       },
  //                                                       options:
  //                                                           CarouselOptions(
  //                                                         autoPlayInterval:
  //                                                             Duration(
  //                                                                 seconds: 3),
  //                                                         autoPlayAnimationDuration:
  //                                                             Duration(
  //                                                                 milliseconds:
  //                                                                     800),
  //                                                         autoPlay: false,
  //                                                         aspectRatio: 2.0,
  //                                                         enlargeCenterPage:
  //                                                             true,
  //                                                       ),
  //                                                     ))
  //                                               ],
  //                                             );
  //                                           });

  // }
}

// FirebaseFirestore
//     .instance
//     .collection(
//         'partner')
//     .doc(FirebaseAuth
//         .instance
//         .currentUser
//         .uid)
//     .collection(
//         'orders')
//     .doc(document[
//         'orderid'])
//     .update(
//   {
//     'request':
//         true,
//     'orderstate':
//         2
//   },
// );

// FirebaseFirestore
//     .instance
//     .collection(
//         'allads')
//     .doc(document[
//         'orderid'])
//     .update({
//   'request':
//       true,
//   'pname': prodoc[
//       'name'],
//   'partnerid':
//       FirebaseAuth
//           .instance
//           .currentUser
//           .uid,
//   'ppic': prodoc[
//       'profilepic'],
//   'time':
//       DateTime
//           .now(),
//   'msgid': FirebaseAuth
//           .instance
//           .currentUser
//           .uid +
//       document[
//           'orderid'],
//   'rating': 5,
//   'distance': 1,
//   'orderstate':
//       2
// });

// // for messaging

// String
//     timestamp =
//     DateTime.now()
//         .millisecondsSinceEpoch
//         .toString();
// var msgData = {
//   'msg':
//       'Hello',
//   'timestamp':
//       timestamp,
//   'sender': 'p',
//   'type': 'text'
// };
// String temp =
//     jsonEncode(
//         msgData);
// FirebaseFirestore
//     .instance
//     .collection(
//         'messaging')
//     .doc(FirebaseAuth
//             .instance
//             .currentUser
//             .uid +
//         document[
//             'orderid'])
//     .set({
//   'createdAt':
//       DateTime
//           .now(),
//   'orderid':
//       document[
//           'orderid'],
//   'partnerid':
//       FirebaseAuth
//           .instance
//           .currentUser
//           .uid,
//   'id': FirebaseAuth
//           .instance
//           .currentUser
//           .uid +
//       document[
//           'orderid'],
//   'pname': prodoc[
//       'name'],
//   'ppic': prodoc[
//       'profilepic'],
//   'pnum': prodoc[
//       'pnum'],
//   'location':
//       prodoc[
//           'location.add1'],
//   'revealprofile':
//       false,
//   'body': FieldValue
//       .arrayUnion([
//     temp
//   ]),
//   'chatbuild':
//       true,
//   'pread': 0,
//   'uread': 0,
//   'umsgcount':
//       0,
//   'pmsgcount':
//       0,
//   'rating': 5,
//   'orderstate':
//       2,
//   'uname': null,
//   'upic': null,
//   'userid':
//       document[
//           'userid']
// });
// FirebaseFirestore
//     .instance
//     .collection(
//         'users')
//     .doc(document[
//         'userid'])
//     .collection(
//         'adpost')
//     .doc(document[
//         'orderid'])
//     .update({
//   'orderstate':
//       2
// });
