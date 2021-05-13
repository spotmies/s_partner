import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotmies_partner/orders/orderview.dart';

class OnGoing extends StatefulWidget {
  @override
  _OnGoingState createState() => _OnGoingState();
}

class _OnGoingState extends State<OnGoing> {
  DateTime now = DateTime.now();
  List jobs = [
    'AC Service',
    'Computer',
    'TV Repair',
    'development',
    'tutor',
    'beauty',
    'photography',
    'drivers',
    'events'
  ];

  @override
  Widget build(BuildContext context) {
    final _hight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('partner')
              .doc(FirebaseAuth.instance.currentUser.uid)
              .collection('orders')
              .where('orderstate', isEqualTo: 2)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if ((snapshot.hasData)) {
              return Container(
                height: double.infinity,
                width: double.infinity,
                // color: Colors.white,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.all(15),
                  children: snapshot.data.docs.map((document) {
                    return Column(children: [
                      Container(
                          height: _hight * 0.32,
                          width: _width * 0.93,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey[200],
                                    blurRadius: 2,
                                    spreadRadius: 1,
                                    offset: Offset(3, 3)),
                                BoxShadow(
                                    color: Colors.grey[100],
                                    blurRadius: 2,
                                    spreadRadius: 2,
                                    offset: Offset(-2, -2))
                              ]),
                          child: Column(
                            children: [
                              Container(
                                height: _hight * 0.035,
                                width: _width * 0.93,
                                padding: EdgeInsets.only(left: _width * 0.03),
                                decoration: BoxDecoration(
                                    color: Colors.blue[900],
                                    borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(15),
                                      topRight: const Radius.circular(15),
                                    )),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      jobs.elementAt(document['job']),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    IconButton(
                                        padding: EdgeInsets.only(
                                            bottom: _width * 0.05),
                                        icon: Icon(
                                          Icons.more_horiz,
                                          color: Colors.white,
                                          size: _width * 0.07,
                                        ),
                                        onPressed: () {
                                          String id = document['orderid'];
                                          menu(id, context);
                                        })
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: _hight * 0.01,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      padding: EdgeInsets.all(_width * 0.03),
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            document['media'].first),
                                      )),
                                  Column(
                                    children: [
                                      Container(
                                        height: _hight * 0.025,
                                        width: _width * 0.7,
                                        child: Column(
                                          children: [
                                            Text(document['problem'].toString(),
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: _hight * 0.18,
                                        width: _width * 0.7,
                                        // color: Colors.amber,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  height: _hight * 0.05,
                                                  width: _width * 0.35,
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.attach_money,
                                                        size: 20,
                                                      ),
                                                      Text(' Money:' +
                                                          document['money']
                                                              .toString()),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  height: _hight * 0.05,
                                                  width: _width * 0.35,
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.attach_money,
                                                        size: 20,
                                                      ),
                                                      Text(' distance:' +
                                                          '4km'.toString()),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  height: _hight * 0.05,
                                                  width: _width * 0.35,
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.timer,
                                                            size: 20,
                                                          ),
                                                          Text('ScheduleDate:')
                                                        ],
                                                      ),
                                                      Text(document[
                                                          'scheduledate']),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  height: _hight * 0.05,
                                                  width: _width * 0.35,
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.timer,
                                                            size: 20,
                                                          ),
                                                          Text('ScheduleTime:')
                                                        ],
                                                      ),
                                                      Text(document[
                                                              'scheduletime']
                                                          .toString()),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              height: _hight * 0.07,
                                              width: _width * 0.7,
                                              child: Row(
                                                // crossAxisAlignment:
                                                //     CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: _width * 0.35,
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .person_pin_circle,
                                                          size: 20,
                                                        ),
                                                        Text(' Location:')
                                                      ],
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      width: _width * 0.5,
                                                      padding: EdgeInsets.only(
                                                          left: _width * 0.02),
                                                      child: Text(document[
                                                              'location.add1']
                                                          .toString()),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: _width * 0.68,
                                        padding: EdgeInsets.only(
                                            right: _width * 0.07),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextButton(
                                                onPressed: () {
                                                  var id = document['orderid'];
                                                  print(id);
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              OrderView(
                                                                value: '$id',
                                                              )));
                                                },
                                                child: Text(
                                                  'View your post',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.blue[900]),
                                                )),
                                            Container(
                                                height: _hight * 0.04,
                                                width: _width * 0.25,
                                                decoration: BoxDecoration(
                                                    color: Colors.blue[900],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                child: Center(
                                                  child: Text(
                                                    'Ongoing',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          )),
                      SizedBox(
                        height: 10,
                      )
                    ]);
                  }).toList(),
                ),
              );
            } else {
              return Center(
                  child: Text(
                'No data found',
                style: TextStyle(fontSize: 18),
              ));
            }
          },
        ));
  }

  menu(id, BuildContext context) {
    showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
              actions: [
                CupertinoActionSheetAction(
                    isDefaultAction: true,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => OrderView(value: id),
                      ));
                    },
                    child: Text('View Order',
                        style: TextStyle(color: Colors.black))),
                CupertinoActionSheetAction(
                    isDefaultAction: true,
                    onPressed: () {
                      //   FirebaseFirestore.instance
                      //       .collection('users')
                      //       .doc(id)
                      //       .update({
                      //     'delete': true,
                      //   });
                      //   FirebaseFirestore.instance
                      //       .collection('users')
                      //       .doc(FirebaseAuth.instance.currentUser.uid)
                      //       .collection('adpost')
                      //       .doc(id)
                      //       .delete();
                    },
                    child:
                        Text('Complete', style: TextStyle(color: Colors.black)))
              ],
              cancelButton: CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Close',
                    style: TextStyle(color: Colors.black),
                  )),
            ));
  }
}
