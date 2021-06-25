import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

String updatedEmail;
String updatedob;
String updatedNum;
String updatedtempad;
File _profilepic;
String imageLink1 = "";
var updatePath = FirebaseFirestore.instance
    .collection('partner')
    .doc(FirebaseAuth.instance.currentUser.uid);

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    final _hight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        iconTheme: IconThemeData(
          color: Colors.grey[900],
        ),
        title: Text(
          'Profile Info',
          style: TextStyle(color: Colors.grey[900]),
        ),
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: Center(
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
                return Center(
                    child: Container(
                  //color: Colors.amber,
                  padding: EdgeInsets.all(15),
                  height: _hight * 1,
                  // width: 350,
                  child: ListView(
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        height: _hight * 0.15,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: _width * 0.15,
                              width: _width * 0.15,
                              child: CircleAvatar(
                                backgroundColor: Colors.grey[100],
                                child: ClipOval(
                                  child: Center(
                                    child: document['profilepic'] == null
                                        ? Icon(
                                            Icons.person,
                                            color: Colors.blueGrey,
                                            size: _width * 0.12,
                                          )
                                        : Image.network(
                                            document['profilepic'],
                                            fit: BoxFit.cover,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            _profilepic == null
                                ? TextButton(
                                    onPressed: () {
                                      profilePic();
                                    },
                                    child: Text(
                                      'Change',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey[700]),
                                    ))
                                : TextButton(
                                    onPressed: () async {
                                      await uploadprofile();
                                    },
                                    child: Text(
                                      'Upload',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey[700]),
                                    )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        height: _hight * 0.15,
                        // width: 330,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          // boxShadow: kElevationToShadow[1]
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              document['email'],
                              style: TextStyle(fontSize: 18),
                            ),
                            TextButton(
                                onPressed: () {
                                  emailUpdate(context);
                                },
                                child: Text(
                                  'Change',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.grey[700]),
                                ))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        height: _hight * 0.15,
                        // width: 330,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          // boxShadow: kElevationToShadow[1]
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              document['dob'],
                              style: TextStyle(fontSize: 18),
                            ),
                            TextButton(
                                onPressed: () {
                                  dobUpdate(context);
                                },
                                child: Text(
                                  'Change',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.grey[700]),
                                ))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        height: _hight * 0.15,
                        // width: 330,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          // boxShadow: kElevationToShadow[1]
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              document['altnum'] == null
                                  ? 'Not Found'
                                  : document['altnum'],
                              style: TextStyle(fontSize: 18),
                            ),
                            TextButton(
                                onPressed: () {
                                  altNumUpdate(context);
                                },
                                child: Text(
                                  'Change',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.grey[700]),
                                ))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // Container(
                      //   padding: EdgeInsets.all(20),
                      //   height: _hight * 0.15,
                      //   // width: 330,
                      //   decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     borderRadius: BorderRadius.circular(30),
                      //     // boxShadow: kElevationToShadow[1]
                      //   ),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Text(
                      //         document['tempAd'],
                      //         style: TextStyle(fontSize: 18),
                      //       ),
                      //       TextButton(
                      //           onPressed: () {
                      //              updatete(context);
                      //           },
                      //           child: Text(
                      //             'Change',
                      //             style: TextStyle(
                      //                 fontSize: 18, color: Colors.grey[700]),
                      //           ))
                      //     ],
                      //   ),
                      // )
                    ],
                  ),
                ));
              })),
    );
  }

  Future<void> profilePic() async {
    var profile = await ImagePicker().getImage(
      source: ImageSource.camera,
      imageQuality: 10,
      preferredCameraDevice: CameraDevice.rear,
    );
    setState(() {
      _profilepic = File(profile.path);
    });
  }

//image upload function
  Future<void> uploadprofile() async {
    var postImageRef = FirebaseStorage.instance.ref().child('legalDoc');
    UploadTask uploadTask = postImageRef
        .child(DateTime.now().toString() + ".jpg")
        .putFile(_profilepic);
    var imageUrl = await (await uploadTask).ref.getDownloadURL();
    imageLink1 = imageUrl.toString();
    await FirebaseFirestore.instance
        .collection('partner')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({'profilepic': imageLink1});
    // setState(() {
    //   _profilepic = null;
    // });
  }
}

Future<void> emailUpdate(BuildContext context) async {
  return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text('Enter Email'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    //padding: EdgeInsets.all(10),
                    height: 60,
                    width: 380,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: TextField(
                      cursorColor: Colors.amber,
                      keyboardType: TextInputType.emailAddress,
                      //maxLines: 2,
                      //maxLength: 20,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(fontSize: 17),
                        hintText: 'Enter Email',
                        suffixIcon: Icon(
                          Icons.email,
                          color: Colors.blue[800],
                        ),
                        //border: InputBorder.none,
                        contentPadding: EdgeInsets.all(20),
                      ),
                      onChanged: (value) {
                        updatedEmail = value;
                      },
                    ),
                  ),
                  Container(
                      width: double.infinity,
                      child: ElevatedButton(
                          // color: Colors.blue[800],
                          onPressed: () {
                            Navigator.of(context).pop();

                            updatePath.update({'email': updatedEmail});
                          },
                          child: Text(
                            'Change',
                            style: TextStyle(color: Colors.white),
                          )))
                ],
              ),
            ));
      });
}

Future<void> dobUpdate(BuildContext context) async {
  return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text('Enter Date of Birth'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    //padding: EdgeInsets.all(10),
                    height: 60,
                    width: 380,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: TextField(
                      cursorColor: Colors.amber,
                      keyboardType: TextInputType.datetime,
                      //maxLines: 2,
                      //maxLength: 20,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(fontSize: 17),
                        hintText: 'Enter DoB',
                        suffixIcon: Icon(
                          Icons.calendar_today,
                          color: Colors.blue[800],
                        ),
                        //border: InputBorder.none,
                        contentPadding: EdgeInsets.all(20),
                      ),
                      onChanged: (value) {
                        updatedob = value;
                      },
                    ),
                  ),
                  Container(
                      width: double.infinity,
                      child: ElevatedButton(
                          // color: Colors.blue[800],
                          onPressed: () {
                            Navigator.of(context).pop();

                            updatePath.update({'dob': updatedob});
                          },
                          child: Text(
                            'Change',
                            style: TextStyle(color: Colors.white),
                          )))
                ],
              ),
            ));
      });
}

Future<void> altNumUpdate(BuildContext context) async {
  return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text('Enter Number'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    //padding: EdgeInsets.all(10),
                    height: 60,
                    width: 380,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: TextField(
                      cursorColor: Colors.amber,
                      keyboardType: TextInputType.number,
                      //maxLines: 2,
                      //maxLength: 20,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(fontSize: 17),
                        hintText: 'Enter Number',
                        suffixIcon: Icon(
                          Icons.phone_android,
                          color: Colors.blue[800],
                        ),
                        //border: InputBorder.none,
                        contentPadding: EdgeInsets.all(20),
                      ),
                      onChanged: (value) {
                        updatedNum = value;
                      },
                    ),
                  ),
                  Container(
                      width: double.infinity,
                      child: ElevatedButton(
                          // color: Colors.blue[800],
                          onPressed: () {
                            Navigator.of(context).pop();

                            updatePath.update({'altnum': updatedNum});
                          },
                          child: Text(
                            'Change',
                            style: TextStyle(color: Colors.white),
                          )))
                ],
              ),
            ));
      });
}

Future<void> updatedProfilePic(BuildContext context) async {
  return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text('Enter Address'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    //padding: EdgeInsets.all(10),
                    height: 200,
                    width: 380,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [CircleAvatar()],
                    ),
                  ),
                  Container(
                      width: double.infinity,
                      child: ElevatedButton(
                          // color: Colors.blue[800],
                          onPressed: () {
                            Navigator.of(context).pop();

                            updatePath.update({'profilepic': updatedtempad});
                          },
                          child: Text(
                            'Change',
                            style: TextStyle(color: Colors.white),
                          )))
                ],
              ),
            ));
      });
}
