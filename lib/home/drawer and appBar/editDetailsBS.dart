import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:spotmies_partner/controllers/drawerAndAppbar_controller.dart';
import 'package:spotmies_partner/controllers/edit_profile_controller.dart';
import 'package:spotmies_partner/home/drawer%20and%20appBar/appbar.dart';
import 'package:spotmies_partner/providers/partnerDetailsProvider.dart';
import 'package:spotmies_partner/reusable_widgets/basic_app_bar.dart';
import 'package:spotmies_partner/reusable_widgets/elevatedButtonWidget.dart';
import 'package:spotmies_partner/reusable_widgets/profile_pic.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';
import 'package:spotmies_partner/reusable_widgets/textfield_widget.dart';

List<Map<String, Object>> data = [
  {
    "name": "prabhas uppalapati",
    "email": "prabhasuppalapati@gmail.com",
    "mobile": "8019933883",
    "orders": 24,
    "savings": 1284,
  },
];

class EditProfile extends StatefulWidget {
  final Map partner;
  EditProfile(this.partner);
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends StateMVC<EditProfile> {
  EditProfileController _editProfileController;

  _EditProfileState() : super(EditProfileController()) {
    this._editProfileController = controller;
  }
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController tempAddressControl = TextEditingController();
  TextEditingController perAddressControl = TextEditingController();
  TextEditingController businessNameControl = TextEditingController();

  GlobalKey<FormState> editProfileForm = GlobalKey<FormState>();
  var editPic;
  Map partner;

  void initState() {
    setState(() {
      editPic = widget.partner['partnerPic'];
      partner = widget.partner;
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
    });
    _editProfileController.setDate(partner['dob']);
    var date = DateTime.fromMillisecondsSinceEpoch(int.parse(partner['dob']));
    log("date $date ");

    super.initState();
  }

  pickImage() async {
    print(" profile $editPic");
    final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
        preferredCameraDevice: CameraDevice.rear);
    editPic = File(pickedFile?.path);
    log("pic $editPic");
    setState(() {});

    // if (pickedFile.path == null) retrieveLostData();
  }

  editDetails(
    BuildContext context,
    double hight,
    double width,
  ) {
    return SingleChildScrollView(
      child: Container(
        padding: MediaQuery.of(context).viewInsets,
        child: Column(
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.only(top: 20),
                child: ProfilePic(
                  name: partner['name'],
                  profile: editPic,
                  size: width * 0.15,
                  onClick: () {
                    pickImage();
                  },
                ),
              ),
            ),
            Form(
                key: editProfileForm,
                child: Column(
                  children: [
                    Container(
                      width: width * 0.9,
                      padding: EdgeInsets.only(bottom: 15, top: 15),
                      child: TextFieldWidget(
                        controller: nameController,
                        hint: 'Name',
                        label: "Name",
                        enableBorderColor: Colors.grey,
                        focusBorderColor: Colors.indigo[900],
                        enableBorderRadius: 15,
                        focusBorderRadius: 15,
                        errorBorderRadius: 15,
                        focusErrorRadius: 15,
                        validateMsg: 'Enter Valid Name',
                        maxLines: 1,
                        postIcon: Icon(Icons.change_circle),
                        postIconColor: Colors.indigo[900],
                      ),
                    ),
                    Container(
                      width: width * 0.9,
                      padding: EdgeInsets.only(bottom: 15),
                      child: TextFieldWidget(
                        label: "Email",
                        controller: emailController,
                        hint: 'Email',
                        enableBorderColor: Colors.grey,
                        focusBorderColor: Colors.indigo[900],
                        enableBorderRadius: 15,
                        focusBorderRadius: 15,
                        errorBorderRadius: 15,
                        focusErrorRadius: 15,
                        validateMsg: 'Enter Valid Name',
                        maxLines: 1,
                        postIcon: Icon(Icons.change_circle),
                        postIconColor: Colors.indigo[900],
                      ),
                    ),
                    Container(
                      width: width * 0.9,
                      padding: EdgeInsets.only(bottom: 15),
                      child: TextFieldWidget(
                        label: "Alternative Number",
                        controller: mobileController,
                        hint: 'ex : 9876543210',
                        enableBorderColor: Colors.grey,
                        focusBorderColor: Colors.indigo[900],
                        enableBorderRadius: 15,
                        focusBorderRadius: 15,
                        errorBorderRadius: 15,
                        focusErrorRadius: 15,
                        validateMsg: 'Enter Valid Name',
                        maxLines: 1,
                        postIcon: Icon(Icons.change_circle),
                        postIconColor: Colors.indigo[900],
                      ),
                    ),
                    Container(
                      width: width * 0.9,
                      padding: EdgeInsets.only(bottom: 15),
                      child: TextFieldWidget(
                        label: "Temp address",
                        controller: tempAddressControl,
                        hint: 'ex: Dr no,street,colony, city',
                        enableBorderColor: Colors.grey,
                        focusBorderColor: Colors.indigo[900],
                        enableBorderRadius: 15,
                        focusBorderRadius: 15,
                        errorBorderRadius: 15,
                        focusErrorRadius: 15,
                        validateMsg: 'Enter Valid Name',
                        maxLines: 4,
                        postIcon: Icon(Icons.change_circle),
                        postIconColor: Colors.indigo[900],
                      ),
                    ),
                    Container(
                      width: width * 0.9,
                      padding: EdgeInsets.only(bottom: 15),
                      // padding: EdgeInsets.all(15),
                      child: TextFieldWidget(
                        label: "perminent address",
                        controller: perAddressControl,
                        hint: 'ex: Dr no,street,colony, city',
                        enableBorderColor: Colors.grey,
                        focusBorderColor: Colors.indigo[900],
                        enableBorderRadius: 15,
                        focusBorderRadius: 15,
                        errorBorderRadius: 15,
                        focusErrorRadius: 15,
                        validateMsg: 'Enter Valid Name',
                        maxLines: 4,
                        postIcon: Icon(Icons.change_circle),
                        postIconColor: Colors.indigo[900],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 15),
                      child: InkWell(
                        onTap: () async {
                          await _editProfileController.pickDate(context);
                        },
                        child: Container(
                            width: width * 0.9,
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey[300],
                                      blurRadius: 3,
                                      spreadRadius: 1)
                                ],
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    TextWid(
                                      text: 'Date of Birth:',
                                      color: Colors.grey[900],
                                      size: width * 0.05,
                                      weight: FontWeight.w600,
                                    ),
                                  ],
                                ),
                                Container(
                                  // height: hight * 0.07,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextWid(
                                        text: 'Date:  ' +
                                            DateFormat('dd MMM yyyy').format(
                                                (DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        (_editProfileController
                                                            .pickedDate
                                                            .millisecondsSinceEpoch)))),
                                        color: Colors.grey[900],
                                        size: width * 0.04,
                                        weight: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                    Container(
                      width: width * 0.9,
                      padding: EdgeInsets.only(bottom: 15),
                      // padding: EdgeInsets.all(15),
                      child: TextFieldWidget(
                        label: "Business Name",
                        controller: businessNameControl,
                        hint: 'ex : electronic shop , skml parlour',
                        enableBorderColor: Colors.grey,
                        focusBorderColor: Colors.indigo[900],
                        enableBorderRadius: 15,
                        focusBorderRadius: 15,
                        errorBorderRadius: 15,
                        focusErrorRadius: 15,
                        validateMsg: 'Enter Valid Name',
                        maxLines: 1,
                        postIcon: Icon(Icons.change_circle),
                        postIconColor: Colors.indigo[900],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      child: ElevatedButtonWidget(
                        bgColor: Colors.indigo[50],
                        minWidth: width,
                        // height: hight * 0.06,
                        textColor: Colors.grey[900],
                        buttonName: 'Close',
                        textSize: width * 0.05,
                        textStyle: FontWeight.w600,
                        borderRadius: 5.0,
                        borderSideColor: Colors.indigo[50],
                        onClick: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final hight = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _editProfileController.scaffoldkey,
      appBar: basicAppbar(context,
          title: "Edit profile details",
          leadingIcon: Icon(
            Icons.edit,
            color: Colors.grey[900],
          )),
      body: editDetails(context, hight, width),
    );
  }
}
