import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spotmies_partner/home/offline.dart';
import 'package:spotmies_partner/home/online.dart';

String name;
getname() async {
  QuerySnapshot getname;

  getname = await FirebaseFirestore.instance
      .collection('partner')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection('profileInfo')
      // .doc(FirebaseAuth.instance.currentUser.uid)
      .get();

  name = getname.docs[0]['name'];
  //orderid = getOrderDetails.docs[0]['orderid'];
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('partner')
              .doc(FirebaseAuth.instance.currentUser.uid)
              .collection('ProfileInfo')
              .doc(FirebaseAuth.instance.currentUser.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return new CircularProgressIndicator();
            }
            var document = snapshot.data;
            return Container(
                child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  height: 80,
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.blue[900]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'welcome ' + document['name'],
                        //isSwitched ? 'online' : 'offline',
                        style: TextStyle(
                          fontSize: 23,
                          color: Colors.white,
                        ),
                      ),
                      Switch(
                          activeColor: Colors.white,
                          //activeTrackColor: Colors.grey[500],
                          inactiveThumbColor: Colors.grey,
                          value: isSwitched,
                          onChanged: (value) {
                            setState(() {
                              isSwitched = value;
                              FirebaseFirestore.instance
                                  .collection('partner')
                                  .doc(FirebaseAuth.instance.currentUser.uid)
                                  .update({
                                'availability': value,
                              });
                              // SnackBar(content: isSwitched ? 'online':12);
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content:
                                      Text(isSwitched ? 'online' : 'offline')));
                            });
                          })
                    ],
                  ),
                ),
                Container(
                  height: 597,
                  width: double.infinity,
                  child: isSwitched ? Online() : Offline(),
                ),
              ],
            ));
          }),
    );
  }
}
