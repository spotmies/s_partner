import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:spotmies_partner/apiCalls/apiCalling.dart';
import 'package:spotmies_partner/apiCalls/apiUrl.dart';
import 'package:spotmies_partner/home/navBar.dart';
import 'package:spotmies_partner/providers/partnerDetailsProvider.dart';
import 'package:spotmies_partner/utilities/snackbar.dart';
import 'package:spotmies_partner/utilities/uploadFilesToCloud.dart';

GlobalKey<ScaffoldState> scaffoldkeyEditProfile = GlobalKey<ScaffoldState>();

class EditProfileController extends ControllerMVC {
  PartnerDetailsProvider? editProvider;

  DateTime? pickedDate = DateTime.now();
  int? dropDownValue = 0;
  List? accountType = [
    'Select Account Type',
    'Business',
    'Student',
    'Freelancer'
  ];
  int job = 0;

  dynamic profilePic;
  dynamic adharF;
  dynamic adharB;
  List? otherDocs = [];
  Map? partner;
  bool? enableModifications = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController tempAddressControl = TextEditingController();
  TextEditingController perAddressControl = TextEditingController();
  TextEditingController businessNameControl = TextEditingController();
  TextEditingController collgeNameControl = TextEditingController();
  TextEditingController experienceControl = TextEditingController();
  TextEditingController storeIdControl = TextEditingController(text: "");

  GlobalKey<FormState> editProfileForm = GlobalKey<FormState>();

  // void initState() {
  //   editProvider = Provider.of<PartnerDetailsProvider>(context, listen: false);
  //   super.initState();
  // }

  fillAllForms(partnerData) {
    partner = partnerData;
    enableModifications = partnerData['enableModifications'] ?? false;
    setDate(partnerData['dob']);
    profilePic = partner!['partnerPic'];
    adharF = partner!['docs']['adharF'];
    adharB = partner!['docs']['adharB'];
    otherDocs = partner!['docs']['otherDocs'];
    job = partner!['job'].runtimeType == String
        ? int.parse(partner!['job'])
        : partner!['job'];
    nameController.text =
        partner!['name'] != null ? partner!['name'].toString() : "";
    emailController.text =
        partner!['eMail'] != null ? partner!['eMail'].toString() : "";
    mobileController.text =
        partner!['altNum'] != null ? partner!['altNum'].toString() : "";
    tempAddressControl.text =
        partner!['tempAdd'] != null ? partner!['tempAdd'].toString() : "";
    perAddressControl.text =
        partner!['perAdd'] != null ? partner!['perAdd'].toString() : "";
    businessNameControl.text = partner!['businessName'] != null
        ? partner!['businessName'].toString()
        : "";
    collgeNameControl.text = partner!['collegeName'] ?? "";
    experienceControl.text =
        partner!['experience'] != null ? partner!['experience'].toString() : "";
    storeIdControl.text = partner!['storeId'] ?? "";
    setAccountType(partner!['accountType']);
    refresh();
  }

  setAccountType(value) {
    for (var i = 0; i < accountType!.length; i++) {
      if (accountType![i] == value.toString()) {
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
    DateTime? date = await showDatePicker(
        confirmText: 'SET DATE',
        context: context,
        initialDate: pickedDate!,
        // firstDate: pickedDate,
        firstDate: DateTime(DateTime.now().year - 80, DateTime.now().month - 0,
            DateTime.now().day - 0),
        lastDate: DateTime.now());
    log(date.toString());
    if (date != null) {
      // setState(() {
      pickedDate = date;
      print(pickedDate!.millisecondsSinceEpoch);
      print(pickedDate);
      // });

    }
    setState(() {});
  }

  saveChanges(BuildContext context) async {
    if (editProfileForm.currentState!.validate()) {
      log("valid");
      editProfileForm.currentState!.save();
      if (dropDownValue == 0) {
        snackbar(context, "Select account type Business or student");
        return;
      }

      // log("$profilePic $adharF $adharB  ");
      editProvider?.setEditLoader(true, loaderName: "Uploading Images");
      snackbar(context, "Uploading Images");
      await uploadFile();
      editProvider?.setEditLoader(false);

      log("loop completed");
      Map<String, dynamic> docs = {
        "adharF": adharF.toString(),
        "adharB": adharB.toString(),
        "otherDocs": partner!['docs']['otherDocs']
      };
      Map<String, String> body = {
        "name": "${nameController.text}",
        "altNum": "${mobileController.text}",
        "eMail": "${emailController.text}",
        "job": "$job",
        "accountType": "${accountType![dropDownValue!]}",
        "dob": "${pickedDate!.millisecondsSinceEpoch}",
        "businessName": "${businessNameControl.text}",
        "collegeName": "${collgeNameControl.text}",
        "experience": "${experienceControl.text}",
        "perAdd": "${perAddressControl.text}",
        "tempAdd": "${tempAddressControl.text}",
        "partnerPic": "$profilePic",
        if (storeIdControl.text.length > 3)
          "storeId": storeIdControl.text.toString(),
        "docs": jsonEncode(docs),
      };
      log("body $body");
      editProvider?.setEditLoader(true, loaderName: "Applying Changes");
      snackbar(context, "Applying Changes");
      log("uid>> $pId");
      dynamic response =
          await Server().editMethod(API.partnerDetails + pId, body);
      editProvider?.setEditLoader(false);
      if (response.statusCode == 200) {
        //log("change applyed");
        dynamic res = jsonDecode(response.body);
        editProvider?.setPartnerDetailsOnly(res!);

        //log("response $res");
        snackbar(context, "Your changes updated");
        Navigator.pop(context);
      } else {
        //log("something went wrong");
      }

      //log("body is $body");
    }
  }

  checkStoreId(String value) async {
    return await Server().checkStoreIdAvailability(value);
    // bool result = await Server().checkStoreIdAvailability(value);
    // log(result.toString());
    // if (result) {
    //   return editProvider?.setHelperText("✅ This name available");
    // }
    // return editProvider?.setHelperText("❌ Not available");
  }

  Future<void> uploadFile() async {
    final String location1 = "partner/$pId/documents";
    final String location2 = "partner/$pId/profile";
    List<dynamic> listMedia = [];
    listMedia.add(profilePic ?? " ");
    listMedia.add(adharF ?? " ");
    listMedia.add(adharB ?? " ");
    for (int i = 0; i < listMedia.length; i++) {
      String cloudLoc = i == 0 ? location2 : location1;
      var downloadedLink =
          await uploadFilesToCloud(listMedia[i], cloudLocation: cloudLoc);
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

updatePartnerDetails(PartnerDetailsProvider provider, body) async {
  dynamic response = await Server().editMethod(
      API.partnerDetails + FirebaseAuth.instance.currentUser!.uid, body);
  if (response.statusCode == 200) {
    dynamic body = jsonDecode(response.body);
    log(body.toString());
    provider.setPartnerDetailsOnly(body!);
  }
  return response;
}
