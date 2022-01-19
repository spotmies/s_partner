import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';
import 'package:spotmies_partner/apiCalls/apiCalling.dart';
import 'package:spotmies_partner/apiCalls/apiUrl.dart';
import 'package:spotmies_partner/home/navBar.dart';
import 'package:spotmies_partner/providers/partnerDetailsProvider.dart';
import 'package:spotmies_partner/utilities/snackbar.dart';
import 'package:spotmies_partner/utilities/uploadFilesToCloud.dart';

class EditProfileController extends ControllerMVC {
  PartnerDetailsProvider editProvider;

  DateTime pickedDate = DateTime.now();
  int dropDownValue = 0;
  List accountType = [
    'Select AccountType',
    'business',
    'student',
    'freelancer'
  ];
  int job = 0;

  var profilePic;
  var adharF;
  var adharB;
  List otherDocs = [];
  Map partner = {};
  bool enableModifications = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController tempAddressControl = TextEditingController();
  TextEditingController perAddressControl = TextEditingController();
  TextEditingController businessNameControl = TextEditingController();
  TextEditingController collgeNameControl = TextEditingController();
  TextEditingController experienceControl = TextEditingController();

  GlobalKey<FormState> editProfileForm = GlobalKey<FormState>();

  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();

  void initState() {
    editProvider = Provider.of<PartnerDetailsProvider>(context, listen: false);
    super.initState();
  }

  fillAllForms(partnerData) {
    partner = partnerData;
    enableModifications = partnerData['enableModifications'] ?? false;

    setDate(partnerData['dob']);
    profilePic = partner['partnerPic'];
    adharF = partner['docs']['adharF'];
    adharB = partner['docs']['adharB'];
    otherDocs = partner['docs']['otherDocs'];
    job = partner['job'].runtimeType == String
        ? int.parse(partner['job'])
        : partner['job'];
    nameController.text =
        partner['name'] != null ? partner['name'].toString() : "";
    emailController.text =
        partner['eMail'] != null ? partner['eMail'].toString() : "";
    mobileController.text =
        partner['altNum'] != null ? partner['altNum'].toString() : "";
    tempAddressControl.text =
        partner['tempAdd'] != null ? partner['tempAdd'].toString() : "";
    perAddressControl.text =
        partner['perAdd'] != null ? partner['perAdd'].toString() : "";
    businessNameControl.text = partner['businessName'] != null
        ? partner['businessName'].toString()
        : "";
    collgeNameControl.text = partner['collegeName'] ?? "";
    experienceControl.text =
        partner['experience'] != null ? partner['experience'].toString() : "";
    setAccountType(partner['accountType']);
    refresh();
  }

  setAccountType(value) {
    for (var i = 0; i < accountType.length; i++) {
      if (accountType[i] == value.toString()) {
        dropDownValue = i;
        break;
      }
    }
  }

  setDate(timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
    setState(() {
      pickedDate = date;
    });
  }

  pickDate(BuildContext context) async {
    DateTime date = await showDatePicker(
        confirmText: 'SET DATE',
        context: context,
        initialDate: pickedDate,
        // firstDate: pickedDate,
        firstDate: DateTime(DateTime.now().year - 80, DateTime.now().month - 0,
            DateTime.now().day - 0),
        lastDate: DateTime.now());
    if (date != null) {
      setState(() {
        pickedDate = date;
        print(pickedDate.millisecondsSinceEpoch);
        print(pickedDate);
      });
    }
  }

  Future<void> saveChanges() async {
    if (editProfileForm.currentState.validate()) {
      log("valid");
      editProfileForm.currentState.save();
      if (dropDownValue == 0) {
        snackbar(context, "Select account type Business or student");
        return;
      }

      // log("$profilePic $adharF $adharB  ");
      editProvider.setEditLoader(true, loaderName: "Uploading Images");
      await uploadFile();
      editProvider.setEditLoader(false);

      log("loop completed");
      var docs = {
        "adharF": adharF.toString(),
        "adharB": adharB.toString(),
        "otherDocs": partner['docs']['otherDocs']
      };
      var body = {
        "name": "${nameController.text}",
        "altNum": "${mobileController.text}",
        "eMail": "${emailController.text}",
        "job": "$job",
        "accountType": "${accountType[dropDownValue]}",
        "dob": "${pickedDate.millisecondsSinceEpoch}",
        "businessName": "${businessNameControl.text}",
        "collegeName": "${collgeNameControl.text}",
        "experience": "${experienceControl.text}",
        "perAdd": "${perAddressControl.text}",
        "tempAdd": "${tempAddressControl.text}",
        "partnerPic": "$profilePic",
        "docs": jsonEncode(docs),
      };
      log("body $body");
      editProvider.setEditLoader(true, loaderName: "Applying Changes");
      log("uid>> $pId");
      var response = await Server().editMethod(API.partnerDetails + pId, body);
      editProvider.setEditLoader(false);
      if (response.statusCode == 200) {
        log("change applyed");
        var res = jsonDecode(response.body);
        editProvider.setPartnerDetailsOnly(res);

        log("response $res");
        Navigator.pop(context);
      } else {
        log("something went wrong");
      }

      log("body is $body");
    }
  }

  Future<void> uploadFile() async {
    var listMedia = [];
    listMedia.add(profilePic ?? " ");
    listMedia.add(adharF ?? " ");
    listMedia.add(adharB ?? " ");
    for (int i = 0; i < listMedia.length; i++) {
      var downloadedLink = await uploadFilesToCloud(listMedia[i]);
      log("douwnload link $downloadedLink");
      if (downloadedLink != null) {
        switch (i) {
          case 0:
            profilePic = downloadedLink.toString();
            break;
          case 1:
            adharF = downloadedLink.toString();
            break;
          case 2:
            adharB = downloadedLink.toString();
            break;
          default:
            print("out of case for updalod");
            break;
        }
        refresh();
      }
    }

    log("$profilePic $adharF $adharB  ");
  }
}
