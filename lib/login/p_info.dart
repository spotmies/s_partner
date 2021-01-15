import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spotmies_partner/home/home.dart';

class PersonalInfo extends StatefulWidget {
  @override
  _PersonalInfoState createState() => _PersonalInfoState();
}
class _PersonalInfoState extends State<PersonalInfo> {
  String name;
  String dob;
  String email;
  String number;
  String perAd;
  String tempAd;
  String job;
  //drop down value for service type;
  int dropDownValue = 0;
  // var format = DateFormat.yMd('ar').format(DateTime.now());
  DateTime now = DateTime.now();

  CrudMethods adPost = new CrudMethods();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Personal Details',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.grey[100],
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: Center(
        child: ListView(children: [
          Column(
            children: [
              Container(
                height: 520,
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
                      height: 7,
                    ),
                    Container(
                        padding: EdgeInsets.all(25),
                        height: 90,
                        width: 380,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          children: [
                            // Text("data"),
                            DropdownButton(
                              value: dropDownValue,
                              hint: Text(
                                '$dropDownValue',
                                style: TextStyle(fontSize: 18),
                              ),
                              icon: Icon(Icons.arrow_downward_outlined),
                              items: [
                                DropdownMenuItem(
                                  value: 0,
                                  child: Text('AC Service'),
                                ),
                                DropdownMenuItem(
                                  value: 1,
                                  child: Text('Computer'),
                                ),
                                DropdownMenuItem(
                                  value: 2,
                                  child: Text('TV Repair'),
                                ),
                                DropdownMenuItem(
                                  value: 3,
                                  child: Text('development'),
                                ),
                                DropdownMenuItem(
                                  value: 4,
                                  child: Text('tutor'),
                                ),
                                DropdownMenuItem(
                                  value: 5,
                                  child: Text('beauty'),
                                ),
                                DropdownMenuItem(
                                  value: 6,
                                  child: Text('photography'),
                                ),
                                DropdownMenuItem(
                                  value: 7,
                                  child: Text('drivers'),
                                ),
                                DropdownMenuItem(
                                  value: 8,
                                  child: Text('events'),
                                ),
                              ],
                              onChanged: (newVal) {
                                print(dropDownValue);
                                setState(() {
                                  dropDownValue = newVal;
                                });
                              },
                            ),
                          ],
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => Home()),
                            (route) => false);
                        Map<String, dynamic> postData = {
                          'name': this.name,
                          'dob': this.dob,
                          'perAd': this.perAd,
                          'altNum': this.number,
                          'email': this.email,
                          'tempAd': this.tempAd,
                          'job': this.dropDownValue,
                          'partnerid': FirebaseAuth.instance.currentUser.uid,
                        };
                        adPost.addData(postData).then((result) {
                          // dialogTrrigger(context);
                        }).catchError((e) {
                          print(e);
                        });
                         FirebaseFirestore.instance
                  .collection('partner')
                  .doc(FirebaseAuth.instance.currentUser.uid).set({'job':dropDownValue,});
                      }),
                  RaisedButton(
                    child: Text('skip',style: TextStyle(color: Colors.white),),
                    color: Colors.blue[900],
                     shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                    onPressed: () {
                    Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => Home()),
                            (route) => false);
                    
                  })
                ],
              )
            ],
          ),
        ]),
      ),
    );
  }
}

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
          .collection('partner')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection('ProfileInfo')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .set(postData)
          .catchError((e) {
        print(e);
      });
    } else {
      print('You need to login');
    }
  }
}
