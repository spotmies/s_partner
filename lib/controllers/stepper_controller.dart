import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';
import 'package:spotmies_partner/apiCalls/apiCalling.dart';
import 'package:spotmies_partner/apiCalls/apiUrl.dart';
import 'package:spotmies_partner/home/navBar.dart';
import 'package:spotmies_partner/providers/partnerDetailsProvider.dart';
import 'package:spotmies_partner/providers/theme_provider.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';
import 'package:spotmies_partner/utilities/app_config.dart';
import 'package:spotmies_partner/utilities/shared_preference.dart';
import 'package:spotmies_partner/utilities/snackbar.dart';
import 'package:spotmies_partner/utilities/uploadFilesToCloud.dart';

class StepperController extends ControllerMVC {
  PartnerDetailsProvider? partnerProvider;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey? stepperCotroller = GlobalKey<ScaffoldState>();
  TextEditingController? nameTf = TextEditingController();
  TextEditingController? dobTf = TextEditingController();
  TextEditingController? emailTf = TextEditingController();
  TextEditingController? numberTf = TextEditingController();
  TextEditingController? altnumberTf = TextEditingController();
  TextEditingController? peradTf = TextEditingController();
  TextEditingController? tempadTf = TextEditingController();
  TextEditingController? experienceTf = TextEditingController();
  TextEditingController? businessNameTf = TextEditingController();
  TextEditingController? collegeNameTf = TextEditingController(text: "");
  TextEditingController? otherlan = TextEditingController();
  ScrollController? scrollController = ScrollController();

  String? value;
  bool? isProcess = false;
  bool? isFail = false;
  // _StepperPersonalInfoState(this.value);
  // var controller = TestController();
  String? name;
  String? dob;
  String? email;
  String? number;
  String? verifiedNumber;
  String? perAd;
  String? tempAd;
  String? job;
  String? businessName;
  String? experience;
  DateTime? pickedDate;
  TimeOfDay? pickedTime;
  GlobalKey<FormState> step2Formkey = GlobalKey<FormState>();
  GlobalKey<FormState> step3Formkey = GlobalKey<FormState>();
  int currentStep = 0;
  String? altnumber;
  bool? accept = false;
  String? tca;
  File? profilepics;
  String? pictureLink = "";
  File? adharfront;
  String? adharBackpageLink =
      "https://firebasestorage.googleapis.com/v0/b/spotmiess.appspot.com/o/assets%2Fadharcardsdemo%2Faadhaar_back.jpeg?alt=media&token=20121bc6-37c6-49e8-98a5-303241e84d33";
  String? clgIdLink = "";
  File? adharback;
  File? clgId;
  String? adharFrontpageLink =
      "https://firebasestorage.googleapis.com/v0/b/spotmiess.appspot.com/o/assets%2Fadharcardsdemo%2Faadhaar_front.jpeg?alt=media&token=b97993d5-66ea-47b7-ae2b-0a07028d556f";
  Map<String, double>? workLocation;

  List? offlineTermsAndConditions = [
    "Spotmies partner not supposed to Save customer details,as well as not supposed to give contact information to customer",
    "Spotmies partners are not supposed to share customer details to others,it will be considered as an illegal activity",
    "we do not Entertain any illegal activities.if perform severe actions will be taken",
    "partners are responsible for the damages done during the services and they bare whole forfeit",
    "we do not provide  any kind of training,equipment/material and  labor to perform any Service",
    "We do not provide any shipping charges,travelling fares",
    "partner should take good care of their appearance ,language ,behaviour while they perform service",
    "partner should fellow all the covid regulations",
  ];

  //langueges

  String? lan1;
  String? lan2;
  String? lan3;
  List? localLang = [];
  bool? telugu = false;
  bool? english = false;
  bool? hindi = false;
  int? dropDownValue;
  DateTime? now = DateTime.now();

  List? jobs = [
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

  step1(BuildContext context) {
    log(accept.toString());
    if (accept!) {
      log('119');
      currentStep += 1;
    } else {
      log('122');
      Timer(
          Duration(milliseconds: 100),
          () => scrollController!
              .jumpTo(scrollController!.position.maxScrollExtent));

      snackbar(context, 'Please accept the Terms & Conditions');
    }
  }

  step2(BuildContext context) async {
    // if (otherlan.text != null) localLang.add(otherlan.text);
    if (step2Formkey.currentState!.validate()) {
      currentStep += 1;
    } else {
      snackbar(context, 'Fill all the fields');
    }
  }

  step3(BuildContext context, String type, String phone, Map coordinates) {
    if (dropDownValue == null || dropDownValue! < 0)
      return snackbar(context, "please select business type");
    if (
        // adharfront != null &&
        //   adharback != null &&
        step3Formkey.currentState!.validate()) {
      step4(context, type, phone, coordinates);
    } else {
      snackbar(context, 'Please check all fields');
    }
  }

  step4(
      BuildContext context, String type, String phone, Map coordinates) async {
    partnerProvider =
        Provider.of<PartnerDetailsProvider>(context, listen: false);
    partnerProvider?.setRegistrationInProgress(true);
    snackbar(context, "Uploading images.....");
    // setState(() {
    //   isProcess = true;
    // });

    await imageUpload();

    var legalDocs = {
      "otherDocs": ["pan", "voter"],
      "adharF": adharFrontpageLink,
      "adharB": adharBackpageLink
    };

    Object docs = jsonEncode(legalDocs);
    log("ph2 $verifiedNumber $phone");
    var body = {
      "docs": docs,
      "partnerPic": pictureLink.toString(),
      "altNum": altnumberTf?.text.toString(),
      "name": nameTf?.text.toString(),
      "phNum": (phone.isEmpty) ? await getNumber() : phone,
      "eMail": emailTf?.text.toString(),
      "job": (dropDownValue).toString(),
      "pId": FirebaseAuth.instance.currentUser?.uid.toString(),
      "join": DateTime.now().millisecondsSinceEpoch.toString(),
      "accountType": type,
      "permission": "0",
      "lastLogin": DateTime.now().millisecondsSinceEpoch.toString(),
      "dob": pickedDate?.millisecondsSinceEpoch.toString(),
      "businessName": businessNameTf?.text.toString(),
      "collegeName": collegeNameTf?.text.toString(),
      "experience": experienceTf?.text.toString(),
      "acceptance": "100",
      "availability": "false",
      "perAdd": peradTf?.text.toString(),
      // "tempAdd": tempadTf?.text.toString(),
      "partnerDeviceToken":
          await FirebaseMessaging.instance.getToken().then((value) {
        return value.toString();
      }),
      "isTermsAccepted": accept.toString(),
      "workLocation.coordinates.0": workLocation!['lat'].toString(),
      "workLocation.coordinates.1": workLocation!['log'].toString(),
      "homeLocation.coordinates.0": workLocation!['lat'].toString(),
      "homeLocation.coordinates.1": workLocation!['log'].toString(),
      "currentLocation.coordinates.0": workLocation!['lat'].toString(),
      "currentLocation.coordinates.1": workLocation!['log'].toString(),
    };
    for (var i = 0; i < localLang!.length; i++) {
      body["lang.$i"] = localLang![i];
    }
    log(body.toString());
    snackbar(context, "Please wait...");
    Server().postMethod(API.partnerRegister, body).then((response) {
      partnerProvider?.setRegistrationInProgress(false);
      log(response.statusCode.toString());

      if (response.statusCode == 200 || response.statusCode == 204) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => NavBar()), (route) => false);
        //  isProcess = false;
      } else {
        try {
          snackbar(context, jsonDecode(response.body).toString());
          log(jsonDecode(response.body).toString());
        } catch (e) {
          snackbar(context, response.body.toString());
          log(response.body.toString());
        }
        snackbar(context, 'Something Went Wrong');
      }
    });
  }

  //utilities

  Future<void> imageUpload() async {
    final String? pId = FirebaseAuth.instance.currentUser?.uid;
    // final String location1 = "partner/$pId/documents";
    final String location2 = "partner/$pId/profile";
    // adharFrontpageLink =
    //     await uploadFilesToCloud(adharfront, cloudLocation: location1);
    // adharBackpageLink =
    //     await uploadFilesToCloud(adharback, cloudLocation: location1);
    pictureLink = profilepics != null
        ? await uploadFilesToCloud(profilepics, cloudLocation: location2)
        : "";
    // clgIdLink = clgId.toString();
  }

  //image pick
  Future<void> profilePic(context, Function onSetState) async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16), color: Colors.white),
              width: width(context) * 0.9,
              height: height(context) * 0.23,
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWid(
                    text: 'Choose Source',
                    weight: FontWeight.bold,
                    size: height(context) * 0.03,
                    color: SpotmiesTheme.primary,
                  ),
                  TextWid(
                    text:
                        'Would like to take a picture using your camera or use an existing image as your profile picture.',
                    size: height(context) * 0.02,
                    flow: TextOverflow.visible,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          color: SpotmiesTheme.secondary,
                          onPressed: () async {
                            var profile = await ImagePicker().pickImage(
                              source: ImageSource.camera,
                              imageQuality: 50,
                              preferredCameraDevice: CameraDevice.front,
                            );
                            profilepics = File(profile!.path);
                            Navigator.of(context).pop();
                            onSetState();
                          },
                          child: TextWid(
                            text: 'Camera',
                            weight: FontWeight.bold,
                            size: height(context) * 0.02,
                            color: SpotmiesTheme.background,
                          ),
                        ),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          color: SpotmiesTheme.primary,
                          onPressed: () async {
                            var profile = await ImagePicker().pickImage(
                              source: ImageSource.gallery,
                              imageQuality: 50,
                            );

                            profilepics = File(profile!.path);
                            Navigator.of(context).pop();
                            onSetState();
                          },
                          child: TextWid(
                            text: 'Choose Image',
                            weight: FontWeight.bold,
                            size: height(context) * 0.02,
                            color: SpotmiesTheme.background,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  //image pick
  Future<void> adharfrontpage() async {
    var front = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      preferredCameraDevice: CameraDevice.rear,
    );
    adharfront = File(front!.path);
    log(adharfront.toString());
    // setState(() {});
  }

  Future<void> adharBack() async {
    var back = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      preferredCameraDevice: CameraDevice.rear,
    );
    adharback = File(back!.path);
    // setState(() {});
  }

  Future<void> clgIdImage() async {
    var id = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      preferredCameraDevice: CameraDevice.rear,
    );
    clgId = File(id!.path);
    // setState(() {
    //   clgId = File(id!.path);
    // });
  }

  pickedDates(BuildContext context) async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: pickedDate!,
        firstDate: DateTime(DateTime.now().year - 80),
        lastDate: DateTime(
          DateTime.now().year + 0,
          DateTime.now().month + 0,
          DateTime.now().day + 0,
        ));
    if (date != null) {
      // setState(() {
      pickedDate = date;
      // });
    }
  }

  pagename(step) {
    switch (step) {
      case 0:
        return 'Terms & Conditions';
      case 1:
        return 'Personal Details';
      case 2:
        return 'Business Details';

      default:
        return 'Create account';
    }
  }
}
