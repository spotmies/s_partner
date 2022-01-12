import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spotmies_partner/home/navBar.dart';

class Addimage extends StatefulWidget {
  @override
  _AddimageState createState() => _AddimageState();
}

class _AddimageState extends State<Addimage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: AdharFront());
  }
}

class AdharFront extends StatefulWidget {
  @override
  _AdharFrontState createState() => _AdharFrontState();
}

class _AdharFrontState extends State<AdharFront> {
  File? _adharfront;
  String? imageLink = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Upload Photo Identity Card',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Text('First Page',style: TextStyle(fontSize: 30),),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
                // border: Border.all()
              ),
              child: _adharfront == null
                  ? Icon(
                      Icons.image,
                      size: 100,
                      color: Colors.grey,
                    )
                  : Image.file(_adharfront!),
            ),
          ),
          Container(
            height: 40,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
              // border: Border.all()
            ),
            child: TextButton(
                onPressed: () {
                  adharfront();
                },
                // icon: Icon(Icons.select_all),
                child: Text(
                  'Choose Image',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                )),
            // child: FlatButton(color:Colors.blue[700], onPressed: (){}, child: Text('Choose image')),
          ),
          SizedBox(
            height: 65,
          ),
          (_adharfront == null)
              ? Text(
                  'Upload Aadhar Card Front Page',
                  style: TextStyle(fontSize: 20),
                )
              : ElevatedButton(
                  //color: Colors.blue[700],
                  onPressed: () {
                    uploadimage();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => AdharBack()),
                        (route) => false);
                  },
                  child: Text(
                    'upload',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
        ],
      ),
    );
  }

//image pick
  Future<void> adharfront() async {
    var front = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 40,
      preferredCameraDevice: CameraDevice.rear,
    );
    setState(() {
      _adharfront = File(front!.path);
    });
  }

//image upload function
  Future<void> uploadimage() async {
    var postImageRef = FirebaseStorage.instance.ref().child('legalDoc');
    UploadTask uploadTask = postImageRef
        .child(DateTime.now().toString() + ".jpg")
        .putFile(_adharfront!);
    var imageUrl = await (await uploadTask).ref.getDownloadURL();
    imageLink = imageUrl.toString();
    FirebaseFirestore.instance
        .collection('partner')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'adhar.front': imageLink});
  }
}

//adhar back

class AdharBack extends StatefulWidget {
  @override
  _AdharBackState createState() => _AdharBackState();
}

class _AdharBackState extends State<AdharBack> {
  File? _adharback;
  String imageLink2 = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Upload Photo Identity Card',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Text('Second Page',style: TextStyle(fontSize: 30),),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
                // border: Border.all()
              ),
              child: _adharback == null
                  ? Icon(
                      Icons.image,
                      size: 100,
                      color: Colors.grey,
                    )
                  : Image.file(_adharback!),
            ),
          ),
          Container(
            height: 40,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
              // border: Border.all()
            ),
            child: TextButton(
                onPressed: () {
                  adharfront();
                },
                // icon: Icon(Icons.select_all),
                child: Text(
                  'Choose Image',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                )),
            // child: FlatButton(color:Colors.blue[700], onPressed: (){}, child: Text('Choose image')),
          ),
          SizedBox(
            height: 65,
          ),
          (_adharback == null)
              ? Text(
                  'Upload Aadhar Card Back Page',
                  style: TextStyle(fontSize: 20),
                )
              : ElevatedButton(
                  // color: Colors.blue[700],
                  onPressed: () {
                    uploadimage();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => ProfilePic()),
                        (route) => false);
                  },
                  child: Text(
                    'upload',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
        ],
      ),
    );
  }

//image pick
  Future<void> adharfront() async {
    var front = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 40,
      preferredCameraDevice: CameraDevice.rear,
    );
    setState(() {
      _adharback = File(front!.path);
    });
  }

//image upload function
  Future<void> uploadimage() async {
    var postImageRef = FirebaseStorage.instance.ref().child('legalDoc');
    UploadTask uploadTask = postImageRef
        .child(DateTime.now().toString() + ".jpg")
        .putFile(_adharback!);
    print(uploadTask);
    var imageUrl = await (await uploadTask).ref.getDownloadURL();
    imageLink2 = imageUrl.toString();
    FirebaseFirestore.instance
        .collection('partner')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'adhar.back': imageLink2});
  }
}

class ProfilePic extends StatefulWidget {
  @override
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  File? _profilepic;
  String imageLink3 = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Container(
        padding: EdgeInsets.all(70),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Profile Picture',
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                padding: EdgeInsets.all(10),
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  // border: Border.all()
                ),
                child: CircleAvatar(
                  child: ClipOval(
                    child: Center(
                      child: _profilepic == null
                          ? Icon(
                              Icons.person,
                              color: Colors.blue,
                              size: 65,
                            )
                          : Image.file(
                              _profilepic!,
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width,
                            ),
                    ),
                  ),
                  radius: 30,
                  backgroundColor: Colors.grey[100],
                ),
              ),
            ),
            Container(
              height: 40,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
                // border: Border.all()
              ),
              child: TextButton(
                  onPressed: () {
                    profilePic();
                  },
                  // icon: Icon(Icons.select_all),
                  child: Text(
                    'Choose Image',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  )),
              // child: FlatButton(color:Colors.blue[700], onPressed: (){}, child: Text('Choose image')),
            ),
            SizedBox(
              height: 65,
            ),
            (_profilepic == null)
                ? Text(
                    '',
                    style: TextStyle(fontSize: 20),
                  )
                : ElevatedButton(
                    // color: Colors.blue[700],
                    onPressed: () {
                      uploadimage();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => NavBar()),
                          (route) => false);
                    },
                    child: Text(
                      'upload',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

//image pick
  Future<void> profilePic() async {
    var front = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 40,
      preferredCameraDevice: CameraDevice.rear,
    );
    setState(() {
      _profilepic = File(front!.path);
    });
  }

//image upload function
  Future<void> uploadimage() async {
    var postImageRef = FirebaseStorage.instance.ref().child('legalDoc');
    UploadTask uploadTask = postImageRef
        .child(DateTime.now().toString() + ".jpg")
        .putFile(_profilepic!);
    print('aaa');
    print(uploadTask);
    var imageUrl = await (await uploadTask).ref.getDownloadURL();
    imageLink3 = imageUrl.toString();
    FirebaseFirestore.instance
        .collection('partner')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'profilepic': imageLink3});
  }
}
