import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';


void main() {
  runApp(Offline());
}

class Offline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PercentIndicator(),
    );
  }
}

class PercentIndicator extends StatefulWidget {
  @override
  _PercentIndicatorState createState() => _PercentIndicatorState();
}

class _PercentIndicatorState extends State<PercentIndicator> {
  var perValue = 0.7;
  var accValue = 0.6;

  var total = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('partner')
            .doc(FirebaseAuth.instance.currentUser.uid)
            .collection('profileInfo')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          return Center(
              child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
                //color: Colors.grey[200],
                ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: CircularPercentIndicator(
                        radius: 140,
                        lineWidth: 13,
                        animation: true,
                        animationDuration: 1000,
                        percent: perValue,
                        backgroundColor: Colors.grey[200],
                        progressColor: Colors.amber,
                        circularStrokeCap: CircularStrokeCap.round,
                        footer: Text('Rating'),
                        center: Text(
                          '$perValue',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0),
                        ),
                      ),
                    ),
                    Container(
                      child: CircularPercentIndicator(
                        radius: 140,
                        lineWidth: 13,
                        animation: true,
                        animationDuration: 1000,
                        percent: accValue,
                        backgroundColor: Colors.grey[200],
                        progressColor: Colors.amber,
                        circularStrokeCap: CircularStrokeCap.round,
                        footer: Text('Acceptance Ratio'),
                        center: Text(
                          '60%',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  height: 50,
                  width: 300,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Number of orders done',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blue[900],
                            fontWeight: FontWeight.w900,
                          )),
                      Icon(Icons.arrow_forward),
                      Text('58',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blue[900],
                            fontWeight: FontWeight.w900,
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 50,
                  width: 300,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Number of Referencece',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blue[900],
                            fontWeight: FontWeight.w900,
                          )),
                      Icon(Icons.arrow_forward),
                      Text('18',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blue[900],
                            fontWeight: FontWeight.w900,
                          )),
                    ],
                  ),
                )
              ],
            ),
          ));
        },
      ),
    );
  }
}
