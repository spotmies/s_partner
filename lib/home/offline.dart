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
  double perValue = 0.7;
  double accValue = 0.6;
  var total = 100;
  @override
  Widget build(BuildContext context) {
    //hight width ratio

    final _hight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;

    return Scaffold(
      // backgroundColor: Colors.white,
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
          List<String> reference = List.from(document['reference']);
          var rateValue = document['rate'] / 20;
          return Center(
              child: Container(
            padding: EdgeInsets.all(10),
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.grey[100]),
            child: ListView(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Container(
                  //   height: _hight * 0.13,
                  //   decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       borderRadius: BorderRadius.circular(15),
                  //       boxShadow: [
                  //         new BoxShadow(
                  //           color: Colors.grey[200],
                  //           blurRadius: 1.0,
                  //         ),
                  //       ]),
                  //   child: Center(
                  //       child: Text(
                  //     'Launching Soon',
                  //     style: TextStyle(
                  //         fontSize: 25,
                  //         color: Colors.blue[700],
                  //         fontWeight: FontWeight.bold),
                  //   )),
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  Container(
                    width: double.infinity,
                    height: _hight * 0.35,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: _hight * 0.35,
                          width: _width * 0.45,
                          padding: EdgeInsets.all(30),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                new BoxShadow(
                                  color: Colors.grey[200],
                                  blurRadius: 1.0,
                                ),
                              ]),
                          child: CircularPercentIndicator(
                            radius: 120,
                            lineWidth: 13,
                            animation: true,
                            animationDuration: 1000,
                            percent: document['rate'] / 100,
                            backgroundColor: Colors.grey[200],
                            progressColor: Colors.amber,
                            circularStrokeCap: CircularStrokeCap.round,
                            footer: Text('Rating'),
                            center: Text(
                              rateValue.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20.0),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          padding: EdgeInsets.all(30),
                          height: _hight * 0.35,
                          width: _width * 0.45,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                new BoxShadow(
                                  color: Colors.grey[200],
                                  blurRadius: 1.0,
                                ),
                              ]),
                          child: CircularPercentIndicator(
                            radius: 120,
                            lineWidth: 13,
                            animation: true,
                            animationDuration: 1000,
                            percent: document['acceptance'] / 100,
                            backgroundColor: Colors.grey[200],
                            progressColor: Colors.amber,
                            circularStrokeCap: CircularStrokeCap.round,
                            footer: Text('Acceptance Ratio'),
                            center: Text(
                              document['acceptance'].toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    height: 230,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          padding: EdgeInsets.all(30),
                          height: _hight * 0.35,
                          width: _width * 0.45,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                new BoxShadow(
                                  color: Colors.grey[200],
                                  blurRadius: 1.0,
                                ),
                              ]),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text((document['orders'].toString()),
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w900,
                                      )),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.cloud_done,
                                    color: Colors.amber,
                                  ),
                                ],
                              ),
                              Text('Orders Completed',
                                  style: TextStyle(
                                    fontSize: 15,
                                  )),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          padding: EdgeInsets.all(30),
                          height: _hight * 0.35,
                          width: _width * 0.45,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                new BoxShadow(
                                  color: Colors.grey[200],
                                  blurRadius: 1.0,
                                ),
                              ]),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(reference.length.toString(),
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w900,
                                      )),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(Icons.person_add, color: Colors.amber),
                                ],
                              ),
                              Text('Referenceces',
                                  style: TextStyle(
                                    fontSize: 15,
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ]),
          ));
        },
      ),
    );
  }
}
