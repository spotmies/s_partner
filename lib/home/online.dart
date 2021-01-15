import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:im_animations/im_animations.dart';

var path;
var userid;
var orderid;
Future<void> docid() async {
  path = FirebaseFirestore.instance
      .collection('partner')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection('updatedpost')
      .doc();
}

void getDatails() async {
  QuerySnapshot getOrderDetails;

  getOrderDetails = await FirebaseFirestore.instance
      .collection('partner')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection('orders')
      .get();

  userid = getOrderDetails.docs[0]['userid'];
  orderid = getOrderDetails.docs[0]['orderid'];
}

void main() {
  runApp(Online());
}

class Online extends StatefulWidget {
  @override
  _OnlineState createState() => _OnlineState();
}

class _OnlineState extends State<Online> {
  String pmoney;
  String ptime;
  @override
  Widget build(BuildContext context) {
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
                .collection('orders')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );
              return Center(
                  child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                ),
                child: ListView(
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.all(15),
                  children: snapshot.data.docs.map(
                    (document) {
                      return Container(
                        height: 400,
                        width: 350,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: kElevationToShadow[0]),
                        child: Column(
                          children: [
                            Text(
                              'job: ' + document['job'],
                            ), 
                            // Text(
                            //   'distance' + document['orderid'],
                            // ),
                            // Text(
                            //   'money' + document['orderid'],
                            // ),
                            RaisedButton(
                                child: Text(
                                  'accept',
                                  style: TextStyle(color: Colors.white),
                                ),
                                color: Colors.blue[900],
                                onPressed: () async {
                                  FirebaseFirestore.instance
                                      .collection('partner')
                                      .doc(
                                          FirebaseAuth.instance.currentUser.uid)
                                      .collection('orders')
                                      .doc(document['orderid'])
                                      .update({
                                    'request': true,
                                  });
                                }),
                            RaisedButton(
                                child: Text(
                                  'reject',
                                  style: TextStyle(color: Colors.white),
                                ),
                                color: Colors.blue[900],
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection('partner')
                                      .doc(
                                          FirebaseAuth.instance.currentUser.uid)
                                      .collection('orders')
                                      .doc(document['orderid'])
                                      .update({
                                    'request': false,
                                  });
                                }),
                            RaisedButton(
                                child: Text(
                                  'update',
                                  style: TextStyle(color: Colors.white),
                                ),
                                color: Colors.blue[900],
                                onPressed: () {
                                  _adUpdateDialog(context);
                                }),
                          ],
                        ),
                      );
                    },
                  ).toList(),
                ),
              ));
            },
          ),
        ));
  }
}

// class CrudMethods {
//   bool isLoggedIn() {
//     if (FirebaseAuth.instance.currentUser != null) {
//       return true;
//     } else {
//       return false;
//     }
//   }

//   Future<void> addData(postData) async {
//     if (isLoggedIn()) {
//       FirebaseFirestore.instance
//           .collection('PartnerData')
//           .doc(FirebaseAuth.instance.currentUser.uid)
//           .collection('orders')
//           .doc(FirebaseAuth.instance.currentUser.uid)
//           .set(postData)
//           .catchError((e) {
//         print(e);
//       });
//     } else {
//       print('You need to login');
//     }
//   }
// }

// class Homepage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[

//               Container(
//                 margin: EdgeInsets.all(5.0),
//                 child: Sonar(
//                   radius: 100,
//                   child: CircleAvatar(
//                     backgroundImage: AssetImage('assets/avatars/man.png'),
//                     radius: 100,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

//---------------------COLOR SONAR------------------------------//
class ColorSonarDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ColorSonar(
          contentAreaRadius: 48.0,
          waveFall: 15.0,
          innerWaveColor: Colors.grey[300],
          middleWaveColor: Colors.grey[200],
          outerWaveColor: Colors.grey[100],
          waveMotion: WaveMotion.synced,
          child: CircleAvatar(
            child: SpinKitDoubleBounce(
              color: Colors.grey[300],
            ),

            //  AwesomeLoader(
            //   loaderType: AwesomeLoader.AwesomeLoader4,
            //   color: Colors.grey[300],
            // ),
            backgroundColor: Colors.white,
            radius: 48.0,
          ),
        ),
      ),
    );
  }
}

String pmoney;
String ptime;
Future<void> _adUpdateDialog(BuildContext context) async {
  CrudMethods adPost = CrudMethods();
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Update your prices'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                height: 60,
                width: 380,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: TextField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: 17),
                    hintText: 'time',
                    suffixIcon: Icon(Icons.timer),
                    //border: InputBorder.none,
                    contentPadding: EdgeInsets.all(20),
                  ),
                  onChanged: (value) {
                    ptime = value;
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                height: 60,
                width: 380,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: TextField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: 17),
                    hintText: 'money',
                    suffixIcon: Icon(Icons.attach_money),
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
          TextButton(
            child: Text('send'),
            onPressed: () async {
              getDatails();
              Navigator.of(context).pop();
              Map<String, dynamic> post = {
                'p_money': pmoney,
                'p_time': ptime,
                'partnerid': FirebaseAuth.instance.currentUser.uid,
                'userid': userid,
                'orderid': orderid,
              };
              adPost.updateData(post).then((result) {}).catchError((e) {
                print(e);
              });
              adPost.requestData(post).then((result) {}).catchError((e) {
                print(e);
              });
            },
          ),
        ],
      );
    },
  );
}

class CrudMethods {
  bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> updateData(postData) async {
    docid();
    print(path.id);
    if (isLoggedIn()) {
      path.set(postData).catchError((e) {
        print(e);
      });
    } else {
      print('You need to login');
    }
  }

  Future<void> requestData(postData) async {
   // docid();
    print(path.id);
    if (isLoggedIn()) {
      FirebaseFirestore.instance
          .collection('request')
          .doc(path.id)
          .set(postData)
          .catchError((e) {
        print(e);
      });
    } else {
      print('You need to login');
    }
  }
}
