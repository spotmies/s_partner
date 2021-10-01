import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:spotmies_partner/apiCalls/apiCalling.dart';
import 'package:spotmies_partner/apiCalls/apiUrl.dart';
import 'package:spotmies_partner/home/navBar.dart';
import 'package:spotmies_partner/utilities/snackbar.dart';

class StepperController extends ControllerMVC {
  var stepperCotroller = GlobalKey<ScaffoldState>();
  TextEditingController nameTf = TextEditingController();
  TextEditingController dobTf = TextEditingController();
  TextEditingController emailTf = TextEditingController();
  TextEditingController numberTf = TextEditingController();
  TextEditingController altnumberTf = TextEditingController();
  TextEditingController peradTf = TextEditingController();
  TextEditingController tempadTf = TextEditingController();
  TextEditingController experienceTf = TextEditingController();
  TextEditingController businessNameTf = TextEditingController();
  TextEditingController otherlan = TextEditingController();
  ScrollController scrollController = ScrollController();

  String value;
  // _StepperPersonalInfoState(this.value);
  // var controller = TestController();
  String name;
  String dob;
  String email;
  String number;
  String perAd;
  String tempAd;
  String job;
  String businessName;
  String experience;
  DateTime pickedDate;
  TimeOfDay pickedTime;
  final step2Formkey = GlobalKey<FormState>();
  final step3Formkey = GlobalKey<FormState>();
  int currentStep = 0;
  String altnumber;
  bool accept = false;
  String tca;
  File profilepics;
  String picture = "";
  File adharfront;
  String adharBackpage = "";
  File adharback;
  String adharFrontpage = "";

  //langueges

  String lan1;
  String lan2;
  String lan3;
  List localLang = [];
  bool telugu = false;
  bool english = false;
  bool hindi = false;
  int dropDownValue = 0;
  DateTime now = DateTime.now();

  List jobs = [
    'Select',
    'AC Service',
    'Computer',
    'TV Repair',
    'development',
    'tutor',
    'beauty',
    'photography',
    'drivers',
    'events',
    'Electrician',
    'Carpentor',
    'Plumber',
  ];

  //functions

  step1(BuildContext context, StepperController stepperController) {
    if (accept == true) {
      currentStep += 1;
    } else {
      Timer(
          Duration(milliseconds: 100),
          () => scrollController
              .jumpTo(scrollController.position.maxScrollExtent));

      snackbar(context, 'Need to accept all the terms & conditions');
    }
  }

  step2(BuildContext context) async {
    // if (otherlan.text != null) localLang.add(otherlan.text);
    if (step2Formkey.currentState.validate()) {
      currentStep += 1;
    } else {
      snackbar(context, 'Fill all the fields');
    }
  }

  step3(BuildContext context) {
    if (adharfront != null &&
        adharback != null &&
        dropDownValue != null &&
        step3Formkey.currentState.validate()) {
      step4(context);
    } else {
      snackbar(context, 'Need to Upload Documents');
    }
  }

  step4(BuildContext context) async {
    //await imageUpload();

    var legalDocs = {
      "otherDocs": ["pan", "voter"],
      "adharF": adharFrontpage,
      "adharB": adharBackpage
    };

    Object docs = jsonEncode(legalDocs);
    // String lang = [lan1, lan2].toString();

    var body = {
      "docs": docs,
      "partnerPic": picture.toString(),
      "lang": localLang,
      "name": nameTf.text.toString(),
      "phNum": 8019933883.toString(),
      "eMail": emailTf.text.toString(),
      "job": 4.toString(),
      "pId": FirebaseAuth.instance.currentUser.uid.toString(),
      "join": DateTime.now().millisecondsSinceEpoch.toString(),
      "accountType": "student",
      "permission": 0.toString(),
      "lastLogin": DateTime.now().millisecondsSinceEpoch.toString(),
      "dob": pickedDate.millisecondsSinceEpoch.toString(),
      "businessName": businessNameTf.text.toString(),
      "experience": experienceTf.text.toString(),
      "acceptance": 100.toString(),
      "availability": false.toString(),
      "rate": 100.toString(),
      "perAdd": peradTf.text.toString(),
      "tempAdd": tempadTf.text.toString(),
      "partnerDeviceToken":
          await FirebaseMessaging.instance.getToken().then((value) {
        return value.toString();
      }),
      "isTermsAccepted": accept.toString()
    };
    // Server().postMethod(API.partnerRegister, body).then((response) {
    //   if (response.statusCode == 200) {
    //     Navigator.pushAndRemoveUntil(context,
    //         MaterialPageRoute(builder: (_) => NavBar()), (route) => false);
    //   } else {
    //     snackbar(context, 'Need to Upload Profile picture');
    //   }
    // });
    log(body.toString());
    // if(resp != 200)return; //write the code if post request not work well
    // controller.postData();
    // .profilepic != null
    //     ? Navigator.pushAndRemoveUntil(context,
    //         MaterialPageRoute(builder: (_) => Home()), (route) => false)
    //     : snackbar(context, 'Need to Upload Profile picture');
    // currentStep += 1;
  }

  //utilities

  Future<void> imageUpload() async {
    var postImageRef = FirebaseStorage.instance.ref().child('legalDoc');
    UploadTask pic = postImageRef
        .child(DateTime.now().toString() + ".jpg")
        .putFile(profilepics);
    UploadTask adharF = postImageRef
        .child(DateTime.now().toString() + ".jpg")
        .putFile(adharfront);
    UploadTask adharB = postImageRef
        .child(DateTime.now().toString() + ".jpg")
        .putFile(adharback);
    var profilepic = await (await pic).ref.getDownloadURL();
    var adharFront = await (await adharF).ref.getDownloadURL();
    var adharBack = await (await adharB).ref.getDownloadURL();

    adharFrontpage = adharFront.toString();
    adharBackpage = adharBack.toString();
    picture = profilepic.toString();
  }

  //image pick
  Future<void> profilePic() async {
    var front = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 10,
      preferredCameraDevice: CameraDevice.rear,
    );
    setState(() {
      profilepics = File(front.path);
    });
  }

  //image pick
  Future<void> adharfrontpage() async {
    var front = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 10,
      preferredCameraDevice: CameraDevice.rear,
    );
    setState(() {
      adharfront = File(front.path);
    });
  }

  Future<void> adharBack() async {
    var front = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 10,
      preferredCameraDevice: CameraDevice.rear,
    );
    setState(() {
      adharback = File(front.path);
    });
  }

  pickedDates(BuildContext context) async {
    DateTime date = await showDatePicker(
        context: context,
        initialDate: pickedDate,
        firstDate: DateTime(DateTime.now().year - 80),
        lastDate: DateTime(
          DateTime.now().year + 0,
          DateTime.now().month + 0,
          DateTime.now().day + 0,
        ));
    if (date != null) {
      setState(() {
        pickedDate = date;
      });
    }
  }
}
