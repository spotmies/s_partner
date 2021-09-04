import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotmies_partner/apiCalls/apiCalling.dart';
import 'package:spotmies_partner/apiCalls/apiUrl.dart';
import 'package:spotmies_partner/localDB/localGet.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:spotmies_partner/reusable_widgets/elevatedButtonWidget.dart';
import 'package:spotmies_partner/reusable_widgets/progressIndicator.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';

class Online extends StatefulWidget {
  Online(pr);

  @override
  _OnlineState createState() => _OnlineState();
}

class _OnlineState extends State<Online> {
  var path;
  var userid;
  var orderid;
  var incoming;
  var partner;
  var localData;
  // var socketincomingorder;
  String pmoney;
  DateTime pickedDate;
  TimeOfDay pickedTime;

  StreamController _socketIncomingOrders;

  Stream stream;
  var onlineOrd;
  var localOrd;
  IO.Socket socket;
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

  void socketOrders() {
    socket = IO.io("https://spotmiesserver.herokuapp.com", <String, dynamic>{
      "transports": ["websocket", "polling", "flashsocket"],
      "autoConnect": false,
    });
    socket.onConnect((data) {
      print("Connected");
      socket.on("message", (msg) {
        print(msg);
      });
    });
    socket.connect();
    socket.emit('join-partner', FirebaseAuth.instance.currentUser.uid);
    socket.on('inComingOrders', (socket) async {
      _socketIncomingOrders.add(socket);
    });
  }

  @override
  void initState() {
    _socketIncomingOrders = StreamController();
    stream = _socketIncomingOrders.stream.asBroadcastStream();
    socketOrders();
    stream.listen((event) {
      log(event.toString());
    });

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
        body: FutureBuilder(
            future: localPartnerDetailsGet(),
            builder: (context, localPartner) {
              if (localPartner.data == null)
                return Center(child: CircularProgressIndicator());
              var p = localPartner.data;
              return FutureBuilder(
                  future: localOrdersGet(),
                  builder: (context, localOrders) {
                    var ld = localOrders.data;
                 
                    var o = List.from(ld.reversed);
                    if (o == null)
                      return Center(child: circleProgress());
                    return StreamBuilder(
                        stream: stream,
                        builder: (context, orderSocket) {
                          var neworders = orderSocket.data;

                          if (orderSocket.data != null) {
                            if (ld.last['ordId'] != neworders['ordId']) {
                              WidgetsBinding.instance
                                  .addPostFrameCallback((_) async {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString(
                                    'inComingOrders',
                                    jsonEncode(List.from(ld)
                                      ..addAll([orderSocket.data])));
                                setState(() {});
                              });
                            }
                          }
                          return Container(
                              // padding: EdgeInsets.all(10),
                              child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: o.length,
                                  padding: EdgeInsets.all(15),
                                  itemBuilder: (BuildContext ctxt, int index) {
                                    var u = o[index]['uDetails'];
                                    List<String> images =
                                        List.from(o[index]['media']);
                                    // print(o[index]['media'][0].length);
                                    return Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 15, right: 10),
                                          height: _hight * 0.045,
                                          decoration: BoxDecoration(
                                              color: Colors.indigo[900],
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(15),
                                                  topRight:
                                                      Radius.circular(15)),
                                              boxShadow: kElevationToShadow[0]),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              TextWid(
                                                text: jobs
                                                    .elementAt(o[index]['job']),
                                                size: _width * 0.04,
                                                color: Colors.white,
                                                weight: FontWeight.w600,
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
                                          margin: EdgeInsets.only(bottom: 10),
                                          padding: EdgeInsets.all(10),
                                          height: _hight * 0.27,
                                          // width: _width * 0.88,
                                          decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(15),
                                                  bottomRight:
                                                      Radius.circular(15)),
                                              boxShadow: kElevationToShadow[0]),
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(10),
                                                height: _hight * 0.1,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[50],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {},
                                                      child: Container(
                                                        height: _hight * 0.15,
                                                        width: _width * 0.2,
                                                        // child:
                                                        //  CircleAvatar(
                                                        //   child: images == null
                                                        //       ? NetworkImage(images.first)
                                                        //       : Icon(Icons.ac_unit),
                                                        // )
                                                      ),
                                                    ),
                                                    Container(
                                                      width: _width * 0.6,
                                                      child: TextWid(
                                                        text:
                                                            toBeginningOfSentenceCase(
                                                          o[index]['problem']
                                                              .toString(),
                                                        ),
                                                        align: TextAlign.center,
                                                        flow: TextOverflow
                                                            .visible,
                                                        size: _width * 0.04,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: 5, bottom: 10),
                                                padding: EdgeInsets.all(5),
                                                height: _hight * 0.07,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[50],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Flexible(
                                                      flex: 2,
                                                      // width: _width * 0.4,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              TextWid(
                                                                text: 'Money: ',
                                                                size: _width *
                                                                    0.03,
                                                                weight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                              SizedBox(
                                                                width: _width *
                                                                    0.05,
                                                              ),
                                                              TextWid(
                                                                text: o[index][
                                                                        'money']
                                                                    .toString(),
                                                                size: _width *
                                                                    0.03,
                                                              )
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              TextWid(
                                                                text:
                                                                    'Location: ',
                                                                size: _width *
                                                                    0.03,
                                                                weight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                              SizedBox(
                                                                width: _width *
                                                                    0.02,
                                                              ),
                                                              TextWid(
                                                                text: o[index]['loc']
                                                                            [0]
                                                                        .toString() +
                                                                    "," +
                                                                    o[index]['loc']
                                                                            [1]
                                                                        .toString(),
                                                                size: _width *
                                                                    0.03,
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      width: _width * 0.3,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              
                                                               TextWid(
                                                                text:
                                                                    'Date: ',
                                                                size: _width *
                                                                    0.04,
                                                                weight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                               TextWid(
                                                                text:  o[index][
                                                                          'schedule']
                                                                      .toString(),
                                                                size: _width *
                                                                    0.03,
                                                              ),
                                                            
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                                TextWid(
                                                                text:
                                                                    'Time: ',
                                                                size: _width *
                                                                    0.04,
                                                                weight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                               TextWid(
                                                                text:
                                                                     o[index][
                                                                        'schedule']
                                                                    .toString(),
                                                                size: _width *
                                                                    0.03,
                                                               
                                                              ),
                                                            
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              o[index]['ordState'] == 'req'
                                                  ? Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            ElevatedButtonWidget(
                                                              buttonName:
                                                                  'Reject',
                                                              height:
                                                                  _hight * 0.05,
                                                              minWidth:
                                                                  _width * 0.3,
                                                              bgColor: Colors
                                                                  .indigo[50],
                                                              textColor: Colors
                                                                  .grey[900],
                                                              textSize:
                                                                  _width * 0.04,
                                                              leadingIcon: Icon(
                                                                Icons.close,
                                                                color: Colors
                                                                        .grey[
                                                                    900],
                                                                size: _width *
                                                                    0.04,
                                                              ),
                                                              borderRadius:
                                                                  15.0,
                                                              borderSideColor:
                                                                  Colors.indigo[
                                                                      50],
                                                              onClick: () {},
                                                            ),
                                                            ElevatedButtonWidget(
                                                              buttonName:
                                                                  'Accept',
                                                              height:
                                                                  _hight * 0.05,
                                                              minWidth:
                                                                  _width * 0.55,
                                                              bgColor: Colors
                                                                  .indigo[900],
                                                              textColor:
                                                                  Colors.white,
                                                              textSize:
                                                                  _width * 0.04,
                                                              trailingIcon:
                                                                  Icon(
                                                                Icons.check,
                                                                color: Colors
                                                                    .white,
                                                                size: _width *
                                                                    0.04,
                                                              ),
                                                              borderRadius:
                                                                  15.0,
                                                              borderSideColor:
                                                                  Colors.indigo[
                                                                      100],
                                                              onClick:
                                                                  () async {
                                                                var ordid = o[
                                                                        index]
                                                                    ['ordId'];
                                                                var api = API
                                                                        .acceptOrder
                                                                        .toString() +
                                                                    "$ordid";
                                                                Server()
                                                                    .editMethod(
                                                                        api, {
                                                                  'pId': API.pid
                                                                      .toString(),
                                                                  'ordState':
                                                                      'onGoing'
                                                                }).catchError(
                                                                        (e) {
                                                                  print(e);
                                                                });
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    )
                                                  : TextWid(
                                                      text: 'Order Accepted',
                                                      size: _width * 0.05,
                                                      weight: FontWeight.w600,
                                                    )
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  }));
                        });
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

  // storeNewData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   log('somthing');
  //   var newOrder = List.from(localData)..addAll(socketincomingorder);
  //   if (socketincomingorder != null)
  //     prefs.setString('inComingOrders', jsonEncode(newOrder)).then((value) {
  //       if (value == true) {
  //         setState(() {});
  //       }
  //       log('$value');
  //     });
  // }

  // FutureBuilder<Object>(
  //     future: localGet(),
  //     builder: (context, localOrders) {
  //       localData = localOrders.data;

  //       // if (socketincomingorder == null) {
  //       //   socketincomingorder.add(localData);
  //       //   // storeNewData();
  //       //   // socketincomingorder.clear();
  //       // }
  //       // socketincomingorder.clear();
  //       // setState(() {});
  //       // if (snap.data == null) return CircularProgressIndicator();
  //       return StreamBuilder(
  //           stream: stream,
  //           builder: (context, orderSocket) {
  //             var neworders = orderSocket.data;
  //             // log(localData.toString());
  //             log(localData.last['ordId'].toString());
  //             if (orderSocket.data != null)
  //               log(neworders['ordId'].toString());
  //             if (orderSocket.data != null) {
  //               log('line225');
  //               if (localData.last['ordId'] != neworders['ordId']) {
  //                 log('true');
  //                 WidgetsBinding.instance.addPostFrameCallback((_) async {
  //                   final prefs = await SharedPreferences.getInstance();
  //                   prefs.setString(
  //                       'inComingOrders',
  //                       jsonEncode(List.from(localData)
  //                         ..addAll([orderSocket.data])));
  //                   setState(() {});
  //                 });
  //               }
  //             }

  //             // WidgetsBinding.instance.addPostFrameCallback((_) async {
  //             //   final prefs = await SharedPreferences.getInstance();
  //             //   prefs.setString(
  //             //       'inComingOrders',
  //             //       jsonEncode(List.from(localData)
  //             //         ..addAll([orderSocket.data])));
  //             //   // setState(() {});
  //             // });
  //             // if (orderSocket.data != null)
  //             //   socketincomingorder.add(orderSocket.data);
  //             // print(socketincomingorder.toString());

  //             // prefs.setString('inComingOrders', jsonEncode(newOrder));

  //             // if (socketincomingorder.isNotEmpty) {
  //             //   for (var i = [orderSocket.data].length; i > 0; i--) {
  //             //     log('Item $i');
  //             //     storeNewData();

  //             //   }

  //             // log('satish');
  //             // log(socketincomingorder.toString());

  //             //}
  //             // // log(localData.toString());
  //             // log(socketincomingorder.toString());
  //             // socketincomingorder.clear();
  //             // var s = ['oko'];
  //             // if (localData != null && s != null) {
  //             //   var i;
  //             //   print('something');
  //             //   print(orderSocket.data);
  //             //   // test(localData);
  //             //   //for (i = s.length - 1; i >= 0; i--) {
  //             //   log('objects');
  //             //   // qwerty(localData, s);
  //             //   //}
  //             //   //qwerty(localData, s);
  //             // }
  //             // test(localData);
  //             // socketincomingorder.removeLast();

  //             // print('satish');
  //             // print(socketOrders);
  //             // print('satish');

  //             // print(orderSocket.data);
  //             //if (localData != null && socketOrders != null) {
  //             //socketOrders.clear();
  //             // storeNewData(localData, socketOrders);
  //             // }
  //             // socketOrders.clear();
  //             // dispose();
  //             return ListView(
  //               children: [
  //                 Text(localOrders.data.toString()),
  //                 IconButton(
  //                     onPressed: () async {
  //                       List da = ['three'];
  //                       var newList = new List.from(localOrders.data)
  //                         ..addAll(da);

  //                       // da.add('satish');
  //                       SharedPreferences prefs =
  //                           await SharedPreferences.getInstance();
  //                       prefs.setString(
  //                           'inComingOrders', jsonEncode(newList));
  //                       setState(() {});
  //                     },
  //                     icon: Icon(Icons.ac_unit))
  //               ],
  //             );
  //           });
  //     })

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
