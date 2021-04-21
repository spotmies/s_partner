import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Completed extends StatefulWidget {
  @override
  _CompletedState createState() => _CompletedState();
}

class _CompletedState extends State<Completed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Colors.blue[900],
        body: StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('partner')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection('orders')
          .where('orderstate', isEqualTo: 3)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if ((snapshot.hasData)) {
          return Container(
            height: double.infinity,
            width: double.infinity,
            // decoration: BoxDecoration(
            color: Colors.grey[100],
            //     borderRadius: BorderRadius.only(
            //       topLeft: const Radius.circular(30),
            //       topRight: const Radius.circular(30),
            //     )),
            child: ListView(
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.all(15),
              children: snapshot.data.docs.map((document) {
                return Column(children: [
                  Container(
                      height: 170,
                      width: 370,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: kElevationToShadow[0]),
                      child: Column(
                        children: [
                          Container(
                            height: 25,
                            width: 370,
                            decoration: BoxDecoration(
                                color: Colors.blue[900],
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(15),
                                  topRight: const Radius.circular(15),
                                )),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  document['job'].toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 150,
                                ),
                                IconButton(
                                    padding: EdgeInsets.only(bottom: 15),
                                    icon: Icon(
                                      Icons.more_horiz,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    onPressed: () {})
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                    'https://images.indulgexpress.com/uploads/user/imagelibrary/2020/1/25/original/MaheshBabuSourceInternet.jpg'),
                              ),
                              Column(
                                children: [
                                  Container(
                                    height: 20,
                                    width: 270,
                                    child: Column(
                                      children: [
                                        Text(document['job'].toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 120,
                                        width: 120,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 2,
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.remove_red_eye,
                                                  size: 20,
                                                ),
                                                Text(' Views:' +
                                                    document['job'].toString()),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 11,
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.person_pin_circle,
                                                  size: 20,
                                                ),
                                                Text(' Distance:' +
                                                    document['job'].toString())
                                              ],
                                            ),
                                            TextButton(
                                                onPressed: () {},
                                                child: Text(
                                                  'View your post',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.blue[900]),
                                                )),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Container(
                                        height: 120,
                                        width: 120,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.attach_money,
                                                  size: 20,
                                                ),
                                                Text('Money:' +
                                                    document['job'].toString()),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.timer,
                                                  size: 20,
                                                ),
                                                Text('Time:' +
                                                    document['job'].toString()),
                                              ],
                                            ),
                                            Container(
                                                height: 25,
                                                width: 90,
                                                decoration: BoxDecoration(
                                                    color: Colors.blue[900],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                child: Center(
                                                  child: Text(
                                                    'Active',
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
          return Text('data');
        }
      },
    ));
  }
}
