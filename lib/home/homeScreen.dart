import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
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
                      child: Container(
                        child: Row(
                          children: [
                            FlutterSwitch(
                                activeColor: Colors.blue[900],
                                activeIcon: Icon(Icons.done),
                                inactiveIcon: Icon(Icons.gps_off_outlined),
                                inactiveColor: Colors.blue[900],
                                activeToggleColor: Colors.greenAccent[700],
                                inactiveToggleColor: Colors.redAccent[700],
                                activeText: 'Online',
                                inactiveText: 'Offline',

                                // activeTextFontWeight: FontWeight.normal,
                                // activeTextColor: Colors.amber,
                                width: 130.0,
                                height: 40.0,
                                valueFontSize: 25.0,
                                toggleSize: 45.0,
                                borderRadius: 30.0,
                                padding: 5.0,
                                showOnOff: true,
                                value: isSwitch,
                                onToggle: (value) {
                                  setState(() {
                                    //isSwitched = value;
                                    FirebaseFirestore.instance
                                        .collection('partner')
                                        .doc(FirebaseAuth
                                            .instance.currentUser.uid)
                                        .update({
                                      'availability': value,
                                    });
                                  });
                                }),
                            // Column(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     Text('N',
                            //         style: TextStyle(
                            //             fontSize: 24,
                            //             fontWeight: FontWeight.w900)),
                            //     Text('FF',
                            //         style: TextStyle(
                            //             fontSize: 24,
                            //             fontWeight: FontWeight.w900)),
                            //   ],
                            // )
                          ],
                        ),
                      ),
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
