import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

// Future<void> docid() async {
//   path = FirebaseFirestore.instance
//       .collection('partner')
//       .doc(FirebaseAuth.instance.currentUser.uid)
//       .collection('updatedpost')
//       .doc();
// }

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

  String pmoney;
  DateTime pickedDate;
  TimeOfDay pickedTime;
  @override
  void initState() {
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
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Scaffold(
          backgroundColor: Colors.grey[50],
          body: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('partner')
                  .doc(FirebaseAuth.instance.currentUser.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                var prodoc = snapshot.data;

                return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('partner')
                        .doc(FirebaseAuth.instance.currentUser.uid)
                        .collection('orders')
                        .where('orderstate', isEqualTo: 0)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot1) {
                      if (!snapshot1.hasData)
                        return Center(
                          child: CircularProgressIndicator(),
                        );

                      //var document = snapshot.data;
                      return Container(
                        padding: EdgeInsets.all(10),
                        child: ListView(
                            scrollDirection: Axis.vertical,
                            padding: EdgeInsets.all(15),
                            children: snapshot1.data.docs.map((document) {
                              List<String> images =
                                  List.from(document['media']);
                              return Column(
                                children: [
                                  Container(
                                    padding:
                                        EdgeInsets.only(left: 15, right: 10),
                                    height: _hight * 0.045,
                                    decoration: BoxDecoration(
                                        color: Colors.blue[900],
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15)),
                                        boxShadow: kElevationToShadow[0]),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          (() {
                                            if (document['job'] == 0) {
                                              return 'AC Service';
                                            }
                                            if (document['job'] == 1) {
                                              return 'Computer';
                                            }
                                            if (document['job'] == 2) {
                                              return 'TV Repair';
                                            }
                                            if (document['job'] == 3) {
                                              return 'Development';
                                            }
                                            if (document['job'] == 4) {
                                              return 'Tutor';
                                            }
                                            if (document['job'] == 5) {
                                              return 'Beauty';
                                            }
                                            if (document['job'] == 6) {
                                              return 'Photography';
                                            }
                                            if (document['job'] == 7) {
                                              return 'Drivers';
                                            }
                                            if (document['job'] == 8) {
                                              return 'Events';
                                            }
                                          }())
                                              .toString(),
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
                                              showCupertinoModalPopup(
                                                  context: context,
                                                  builder:
                                                      (context) =>
                                                          CupertinoActionSheet(
                                                            title: Text(
                                                                'Update your possible prices and time'),
                                                            // message: Text('data'),
                                                            actions: [
                                                              CupertinoActionSheetAction(
                                                                  isDefaultAction:
                                                                      true,
                                                                  onPressed:
                                                                      () {
                                                                    showDialog(
                                                                        context:
                                                                            context,
                                                                        barrierDismissible:
                                                                            false,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return AlertDialog(
                                                                            title:
                                                                                Text('Customize'),
                                                                            content:
                                                                                SingleChildScrollView(
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
                                                                                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                                                                                      child: Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                        children: [
                                                                                          Text('Date:  ${pickedDate.day}/${pickedDate.month}/${pickedDate.year}', style: TextStyle(fontSize: 15)),
                                                                                          Text('Time:  ${pickedTime.hour}:${pickedTime.minute}', style: TextStyle(fontSize: 15))
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Container(
                                                                                    //padding: EdgeInsets.all(10),
                                                                                    height: 60,
                                                                                    width: 380,
                                                                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
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
                                                                                      // await getProfileDatails();
                                                                                      // await docid();
                                                                                      Navigator.pop(context);
                                                                                      var dataa = [
                                                                                        'satishp'
                                                                                      ];
                                                                                      FirebaseFirestore.instance.collection('messaging').doc(FirebaseAuth.instance.currentUser.uid + document['orderid']).set({
                                                                                        'createdAt': DateTime.now(),
                                                                                        'partnerid': FirebaseAuth.instance.currentUser.uid,
                                                                                        'id': FirebaseAuth.instance.currentUser.uid + document['orderid'],
                                                                                        'orderid': document['orderid'],
                                                                                        'orderstate': 0,
                                                                                        'pname': prodoc['name'],
                                                                                        'ppic': prodoc['profilepic'],
                                                                                        'body': FieldValue.arrayUnion(dataa),
                                                                                        'chatbuild': false,
                                                                                        'pread': 0,
                                                                                        'rating': 5,
                                                                                        'distance': 1
                                                                                      });

                                                                                      //request

                                                                                      FirebaseFirestore.instance.collection('request').doc().set({
                                                                                        'distance': 1,
                                                                                        'ptime': '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}',
                                                                                        'pdate': '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}',
                                                                                        'job': prodoc['job'],
                                                                                        'media': 'http://t0.gstatic.com/images?q=tbn:ANd9GcSKRDZSJjs-NWGJC1sD1o634i2kP42OB1eEo72Z4eWIV4yS_ASMEnXs03Ay3Xm3',
                                                                                        'pmoney': pmoney,
                                                                                        'pname': prodoc['name'],
                                                                                        'msgid': FirebaseAuth.instance.currentUser.uid + document['orderid'],
                                                                                        'problem': 'problem',
                                                                                        'time': DateTime.now(),
                                                                                        'orderid': document['orderid'],
                                                                                        'partnerid': FirebaseAuth.instance.currentUser.uid,
                                                                                        'orderstate': 0,
                                                                                        'userid': document['userid'],
                                                                                        'rating': 5,
                                                                                        'ppic': 'http://t0.gstatic.com/images?q=tbn:ANd9GcSKRDZSJjs-NWGJC1sD1o634i2kP42OB1eEo72Z4eWIV4yS_ASMEnXs03Ay3Xm3'
                                                                                      });
                                                                                      FirebaseFirestore.instance.collection('partner').doc(FirebaseAuth.instance.currentUser.uid).collection('updatedpost').doc().set({
                                                                                        'distance': 1,
                                                                                        'job': prodoc['job'],
                                                                                        'media': 'http://t0.gstatic.com/images?q=tbn:ANd9GcSKRDZSJjs-NWGJC1sD1o634i2kP42OB1eEo72Z4eWIV4yS_ASMEnXs03Ay3Xm3',
                                                                                        'money': pmoney,
                                                                                        'name': prodoc['name'],
                                                                                        'msgid': FirebaseAuth.instance.currentUser.uid + document['orderid'],
                                                                                        'problem': 'problem',
                                                                                        'ptime': '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}',
                                                                                        'pdate': '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}',
                                                                                        'orderid': document['orderid'],
                                                                                        'partnerid': FirebaseAuth.instance.currentUser.uid,
                                                                                        'userid': document['userid'],
                                                                                        'pic': 'http://t0.gstatic.com/images?q=tbn:ANd9GcSKRDZSJjs-NWGJC1sD1o634i2kP42OB1eEo72Z4eWIV4yS_ASMEnXs03Ay3Xm3'
                                                                                      });
                                                                                    }),
                                                                              ),
                                                                            ],
                                                                          );
                                                                        });
                                                                  },
                                                                  child: Text(
                                                                      'Update Bid',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.black))),
                                                            ],
                                                            cancelButton:
                                                                CupertinoActionSheetAction(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: Text(
                                                                      'Cancel',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.black),
                                                                    )),
                                                          ));
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
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          insetPadding:
                                                              EdgeInsets.zero,
                                                          contentPadding:
                                                              EdgeInsets.zero,
                                                          clipBehavior: Clip
                                                              .antiAliasWithSaveLayer,
                                                          actions: [
                                                            Container(
                                                                height: _hight *
                                                                    0.35,
                                                                width:
                                                                    _width * 1,
                                                                child:
                                                                    CarouselSlider
                                                                        .builder(
                                                                  itemCount:
                                                                      images
                                                                          .length,
                                                                  itemBuilder: (ctx,
                                                                      index,
                                                                      realIdx) {
                                                                    return Container(
                                                                        child: Image.network(images[index].substring(
                                                                            0,
                                                                            images[index].length -
                                                                                1)));
                                                                  },
                                                                  options:
                                                                      CarouselOptions(
                                                                    autoPlayInterval:
                                                                        Duration(
                                                                            seconds:
                                                                                3),
                                                                    autoPlayAnimationDuration:
                                                                        Duration(
                                                                            milliseconds:
                                                                                800),
                                                                    autoPlay:
                                                                        false,
                                                                    aspectRatio:
                                                                        2.0,
                                                                    enlargeCenterPage:
                                                                        true,
                                                                  ),
                                                                ))
                                                          ],
                                                        );
                                                      });
                                                },
                                                child: Container(
                                                    height: _hight * 0.15,
                                                    width: _width * 0.2,
                                                    child: CircleAvatar(
                                                      backgroundImage:
                                                          NetworkImage(
                                                              images.first),
                                                    )),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                    document['problem']
                                                        .toString(),
                                                    style:
                                                        TextStyle(fontSize: 20),
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
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: _width * 0.4,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Money:',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        Text(document['money']
                                                            .toString()),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text('Location:',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                        Text(document[
                                                            'location.add1']),
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
                                                                    FontWeight
                                                                        .w500)),
                                                        Text(document[
                                                            'scheduledate']),
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
                                                                    FontWeight
                                                                        .w500)),
                                                        Text(document[
                                                            'scheduletime']),
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
                                        document['orderstate'] == 0
                                            ? Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        width: _width * 0.4,
                                                        child: ElevatedButton(
                                                            style: ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty.all(
                                                                        Colors.blue[
                                                                            900])),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Container(
                                                                    color: Colors
                                                                            .blue[
                                                                        900],
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
                                                            onPressed:
                                                                () async {
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'partner')
                                                                  .doc(FirebaseAuth
                                                                      .instance
                                                                      .currentUser
                                                                      .uid)
                                                                  .collection(
                                                                      'orders')
                                                                  .doc(document[
                                                                      'orderid'])
                                                                  .update(
                                                                {
                                                                  'request':
                                                                      true,
                                                                  'orderstate':
                                                                      2
                                                                },
                                                              );

                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'allads')
                                                                  .doc(document[
                                                                      'orderid'])
                                                                  .update({
                                                                'request': true,
                                                                'pname': prodoc[
                                                                    'name'],
                                                                'partnerid':
                                                                    FirebaseAuth
                                                                        .instance
                                                                        .currentUser
                                                                        .uid,
                                                                'ppic': prodoc[
                                                                    'profilepic'],
                                                                'time': DateTime
                                                                    .now(),
                                                                'msgid': FirebaseAuth
                                                                        .instance
                                                                        .currentUser
                                                                        .uid +
                                                                    document[
                                                                        'orderid'],
                                                                'rating': 5,
                                                                'distance': 1,
                                                                'orderstate': 2
                                                              });

                                                              // for messaging

                                                              String timestamp =
                                                                  DateTime.now()
                                                                      .millisecondsSinceEpoch
                                                                      .toString();
                                                              var msgData = {
                                                                'msg': 'Hello',
                                                                'timestamp':
                                                                    timestamp,
                                                                'sender': 'p',
                                                                'type': 'text'
                                                              };
                                                              String temp =
                                                                  jsonEncode(
                                                                      msgData);
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'messaging')
                                                                  .doc(FirebaseAuth
                                                                          .instance
                                                                          .currentUser
                                                                          .uid +
                                                                      document[
                                                                          'orderid'])
                                                                  .set({
                                                                'createdAt':
                                                                    DateTime
                                                                        .now(),
                                                                'orderid':
                                                                    document[
                                                                        'orderid'],
                                                                'partnerid':
                                                                    FirebaseAuth
                                                                        .instance
                                                                        .currentUser
                                                                        .uid,
                                                                'id': FirebaseAuth
                                                                        .instance
                                                                        .currentUser
                                                                        .uid +
                                                                    document[
                                                                        'orderid'],
                                                                'pname': prodoc[
                                                                    'name'],
                                                                'ppic': prodoc[
                                                                    'profilepic'],
                                                                'body': FieldValue
                                                                    .arrayUnion(
                                                                        [temp]),
                                                                'chatbuild':
                                                                    false,
                                                                'pread': 0,
                                                                'uread': 0,
                                                                'umsgcount': 0,
                                                                'pmsgcount': 0,
                                                                'rating': 5,
                                                                'orderstate': 2,
                                                                'uname': null,
                                                                'upic': null,
                                                                'userid':
                                                                    document[
                                                                        'userid']
                                                              });
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'users')
                                                                  .doc(document[
                                                                      'userid'])
                                                                  .collection(
                                                                      'adpost')
                                                                  .doc(document[
                                                                      'orderid'])
                                                                  .update({
                                                                'orderstate': 2
                                                              });
                                                            }),
                                                      ),
                                                      Container(
                                                        width: _width * 0.4,
                                                        child: ElevatedButton(
                                                            style: ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty.all(
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
                                                                        Icons
                                                                            .cancel,
                                                                        color: Color(
                                                                            0xfff50000))),
                                                              ],
                                                            ),
                                                            // color: Colors.blue[900],
                                                            onPressed: () {
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'partner')
                                                                  .doc(FirebaseAuth
                                                                      .instance
                                                                      .currentUser
                                                                      .uid)
                                                                  .collection(
                                                                      'orders')
                                                                  .doc(document[
                                                                      'orderid'])
                                                                  .update({
                                                                'request':
                                                                    false,
                                                              });
                                                              var pid = [
                                                                FirebaseAuth
                                                                    .instance
                                                                    .currentUser
                                                                    .uid,
                                                              ];
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'allads')
                                                                  .doc(document[
                                                                      'orderid'])
                                                                  .update({
                                                                'request':
                                                                    false,
                                                                'reject': FieldValue
                                                                    .arrayUnion(
                                                                        pid)
                                                              });
                                                            }),
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
                            }).toList()),
                      );
                    });
              }),
        ));
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
}
