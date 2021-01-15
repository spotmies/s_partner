import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spotmies_partner/login/legal_doc.dart';

class ProInfo extends StatefulWidget {
  @override
  _ProInfoState createState() => _ProInfoState();
}

class _ProInfoState extends State<ProInfo> {
  String name;
  String dob;
  String email;
  String number;
  String perAd;
  String tempAd;
  //double timeStamp;

  // var format = DateFormat.yMd('ar').format(DateTime.now());
  DateTime now = DateTime.now();
  

  CrudMethods adPost = new CrudMethods();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Profissional details',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.grey[100],
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Container(
          height: 580,
          width: 380,
          //color: Colors.amber,
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                height: 60,
                width: 380,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: TextField(
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: 17),
                    hintText: 'Name',
                    suffixIcon: Icon(Icons.person),
                    //border: InputBorder.none,
                    contentPadding: EdgeInsets.all(20),
                  ),
                  onChanged: (value) {
                    this.name = value;
                  },
                ),
              ),
              SizedBox(
                height: 7,
              ),
              Container(
                padding: EdgeInsets.all(10),
                height: 60,
                width: 380,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: TextField(
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: 17),
                    hintText: 'Date of Birth',
                    suffixIcon: Icon(Icons.calendar_today),
                    //border: InputBorder.none,
                    contentPadding: EdgeInsets.all(20),
                  ),
                  onChanged: (value) {
                    this.dob = value;
                  },
                ),
              ),
              SizedBox(
                height: 7,
              ),
              Container(
                padding: EdgeInsets.all(10),
                height: 60,
                width: 380,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: 17),
                    hintText: 'Email',
                    suffixIcon: Icon(Icons.email),
                    //border: InputBorder.none,
                    contentPadding: EdgeInsets.all(20),
                  ),
                  onChanged: (value) {
                    this.email = value;
                  },
                ),
              ),
              SizedBox(
                height: 7,
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
                    hintText: 'Alternative Mobile Number',
                    suffixIcon: Icon(Icons.dialpad),
                    //border: InputBorder.none,
                    contentPadding: EdgeInsets.all(20),
                  ),
                  onChanged: (value) {
                    this.number = value;
                  },
                ),
              ),
              SizedBox(
                height: 7,
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
                    hintText: 'Temparary Address',
                    suffixIcon: Icon(Icons.add_road),
                    //border: InputBorder.none,
                    contentPadding: EdgeInsets.all(20),
                  ),
                  onChanged: (value) {
                    this.tempAd = value;
                  },
                ),
              ),
              SizedBox(
                height: 7,
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
                    hintText: 'Perminent Address',
                    suffixIcon: Icon(Icons.add_road),
                    //border: InputBorder.none,
                    contentPadding: EdgeInsets.all(20),
                  ),
                  onChanged: (value) {
                    this.perAd = value;
                  },
                ),
              ),
              SizedBox(
                height: 90,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.blue[900],
                      splashColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      onPressed: () async {
                        print(now);
                         Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (_) => AddImage()), (route) => false);
                        Map<String, dynamic> postData = {
                          'name': this.name,
                          'dob': this.dob,
                          'perAd': this.perAd,
                          'altNum': this.number,
                          'email':this.email,
                          'tempAd': this.tempAd
                        };
                        adPost.addData(postData).then((result) {
                         // dialogTrrigger(context);
                        }).catchError((e) {
                          print(e);
                        });
                      })
                ],
              )
            ],
          ), 
        ),
      ),
    );
  }
}

// Future<bool> dialogTrrigger(BuildContext context) async {
//   return showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Acknowledgement'),
//           content: Text('Post Succussfully Published'),
//           actions: [
//             FlatButton(
//                 onPressed: () {
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => Home()));
//                 },
//                 child: Text('ok'))
//           ],
//         );
//       });
// }
class CrudMethods {
  bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> addData(postData) async {
    if (isLoggedIn()) {
      FirebaseFirestore.instance
          .collection('PartnerData')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection('ProfileInfo')
          .add(postData)
          .catchError((e) {
        print(e);
      });
    } else {
      print('You need to login');
    }
  }
}