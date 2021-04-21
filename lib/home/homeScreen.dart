import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spotmies_partner/home/offline.dart';
import 'package:spotmies_partner/home/online.dart';

TextEditingController isSwitched = TextEditingController();

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('partner')
                  .doc(FirebaseAuth.instance.currentUser.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                var document = snapshot.data;
                bool isSwitch = document['availability'];

                isSwitched = isSwitch;

                CircularProgressIndicator();
                return Text(
                    document['name'] == null ? 'User' : document['name']);
              }),
          actions: [
            Container(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('partner')
                      .doc(FirebaseAuth.instance.currentUser.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    var document = snapshot.data;
                    bool isSwitch = document['availability'];
                    CircularProgressIndicator();
                    return Transform.scale(
                      scale: 0.8,
                      child: CupertinoSwitch(
                          activeColor: Colors.grey[100],
                          trackColor: Colors.grey[400],
                          value: isSwitch,
                          onChanged: (value) {
                            setState(() {
                              //isSwitched = value;
                              FirebaseFirestore.instance
                                  .collection('partner')
                                  .doc(FirebaseAuth.instance.currentUser.uid)
                                  .update({
                                'availability': value,
                              });
                            });
                          }),
                    );
                  }),
            )
          ],
        ),
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
              var document = snapshot.data;
              bool isSwitch = document['availability'];

              //isSwitched = isSwitch;

              CircularProgressIndicator();
              return isSwitch ? Online() : Offline();
            }));
  }
}
