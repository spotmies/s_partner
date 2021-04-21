import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spotmies_partner/chat/chat_screen.dart';
import 'package:spotmies_partner/profile/settings.dart';

class ChatHome extends StatefulWidget {
  @override
  _ChatHomeState createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
  @override
  Widget build(BuildContext context) {
    final _hight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                icon: Icon(
                  Icons.person_pin_rounded,
                  size: 27,
                  color: Colors.blue[900],
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Setting()));
                })
          ],
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text('Conversations',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
        ),
        body: Container(
          height: _hight * 1,
          width: _width * 1,
          child: Column(
            children: [
              // Padding(
              //   padding: EdgeInsets.only(top: 16, left: 16, right: 16),
              //   child: TextField(
              //     decoration: InputDecoration(
              //       hintText: "Search...",
              //       hintStyle: TextStyle(color: Colors.grey.shade600),
              //       prefixIcon: Icon(
              //         Icons.search,
              //         color: Colors.grey.shade600,
              //         size: 20,
              //       ),
              //       filled: true,
              //       fillColor: Colors.grey.shade100,
              //       contentPadding: EdgeInsets.all(8),
              //       enabledBorder: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(20),
              //           borderSide: BorderSide(color: Colors.grey.shade100)),
              //     ),
              //   ),
              // ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('messaging')
                      .where('partnerid',
                          isEqualTo: FirebaseAuth.instance.currentUser.uid)
                      //.orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    return Expanded(
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.all(20),
                        children: snapshot.data.docs.map((document) {
                          List<String> msgs = List.from(document['body']);
                          print(msgs);

                          var msgid = document['id'];
                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  print('$msgid');
                                  FirebaseFirestore.instance
                                      .collection('messaging')
                                      .doc(msgid)
                                      .update({'pstatus': 1});
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                      value: msgid,
                                    ),
                                  ));
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  height: _hight * 0.1,
                                  width: _width * 0.95,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20.0),
                                      boxShadow: kElevationToShadow[0]),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        child: ClipOval(
                                          child: document['upic'] == null
                                              ? Icon(
                                                  Icons.person,
                                                  color: Colors.black,
                                                  size: 30,
                                                )
                                              : Image.network(
                                                  document['upic'],
                                                  fit: BoxFit.cover,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                ),
                                        ),
                                        backgroundColor: Colors.grey[100],
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(document['uname'] == null
                                          ? 'User'
                                          : document['uname'])
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    );
                  }),
            ],
          ),
        ));
  }
}
