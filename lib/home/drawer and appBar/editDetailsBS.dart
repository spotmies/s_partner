import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';
import 'package:spotmies_partner/controllers/edit_profile_controller.dart';
import 'package:spotmies_partner/providers/partnerDetailsProvider.dart';

import 'package:spotmies_partner/reusable_widgets/basic_app_bar.dart';
import 'package:spotmies_partner/reusable_widgets/elevatedButtonWidget.dart';
import 'package:spotmies_partner/reusable_widgets/profile_pic.dart';
import 'package:spotmies_partner/reusable_widgets/progress_waiter.dart';
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
  PartnerDetailsProvider editProvider;

  void initState() {
    editProvider = Provider.of<PartnerDetailsProvider>(context, listen: false);
    _editProfileController.fillAllForms(widget.partner);
    log("date ${_editProfileController.partner} ");
    log("other ${_editProfileController.otherDocs[0]} ");

    super.initState();
  }

  photoPicker() async {
    final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 30,
        preferredCameraDevice: CameraDevice.rear);
    return pickedFile;
  }

  void changeImages(whichImage) async {
    print(" profile ${_editProfileController.profilePic}");
    final pickedFile = await photoPicker();
    switch (whichImage) {
      case "profile":
        _editProfileController.profilePic = File(pickedFile?.path);
        break;
      case "adharF":
        _editProfileController.adharF = File(pickedFile?.path);
        break;
      case "adharB":
        _editProfileController.adharB = File(pickedFile?.path);
        break;

      default:
    }

    log("pic ${_editProfileController.profilePic}");
    setState(() {});

    // if (pickedFile.path == null) retrieveLostData();
  }

  editDetails(
    BuildContext context,
    double hight,
    double width,
  ) {
    var boxConstraints = BoxConstraints(
        minHeight: 30,
        maxHeight: hight * 0.4,
        minWidth: 10,
        maxWidth: width * 0.9);
    return Consumer<PartnerDetailsProvider>(builder: (context, data, child) {
      return Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: MediaQuery.of(context).viewInsets,
              child: Column(
                children: [
                  Center(
                    child: Container(
                      padding: EdgeInsets.only(top: 20),
                      child: ProfilePic(
                        name: _editProfileController.partner['name'],
                        profile: _editProfileController.profilePic,
                        size: width * 0.15,
                        onClick: () {
                          changeImages("profile");
                        },
                      ),
                    ),
                  ),
                  Form(
                      key: _editProfileController.editProfileForm,
                      child: Column(
                        children: [
                          nameField(width),
                          Container(
                            width: width * 0.9,
                            padding: EdgeInsets.only(bottom: 15),
                            child: TextFieldWidget(
                              label: "Email",
                              controller:
                                  _editProfileController.emailController,
                              hint: 'Email',
                              enableBorderColor: Colors.grey,
                              focusBorderColor: Colors.indigo[900],
                              enableBorderRadius: 15,
                              focusBorderRadius: 15,
                              errorBorderRadius: 15,
                              focusErrorRadius: 15,
                              type: "email",
                              validateMsg: 'Enter Valid Email address',
                              maxLines: 1,
                              postIcon: Icon(Icons.change_circle),
                              postIconColor: Colors.indigo[900],
                            ),
                          ),
                          Container(
                            width: width * 0.9,
                            padding: EdgeInsets.only(bottom: 15),
                            child: TextFieldWidget(
                              // isRequired: false,
                              label: "Alternative Number",
                              type: "phone",
                              maxLength: 10,
                              formatter: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                              controller:
                                  _editProfileController.mobileController,
                              hint: 'ex : 9876543210',
                              enableBorderColor: Colors.grey,
                              focusBorderColor: Colors.indigo[900],
                              enableBorderRadius: 15,
                              focusBorderRadius: 15,
                              errorBorderRadius: 15,
                              focusErrorRadius: 15,
                              validateMsg: 'Enter Valid Phone number',
                              maxLines: 1,
                              postIcon: Icon(Icons.change_circle),
                              postIconColor: Colors.indigo[900],
                            ),
                          ),
                          Container(
                            width: width * 0.9,
                            padding: EdgeInsets.only(bottom: 15),
                            child: TextFieldWidget(
                              label: "Temparary address",
                              type: "address",
                              maxLength: 200,
                              controller:
                                  _editProfileController.tempAddressControl,
                              hint: 'ex: Dr no,street,colony, city',
                              enableBorderColor: Colors.grey,
                              focusBorderColor: Colors.indigo[900],
                              enableBorderRadius: 15,
                              focusBorderRadius: 15,
                              errorBorderRadius: 15,
                              focusErrorRadius: 15,
                              validateMsg: 'Enter Valid Temporary address',
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
                              isRequired: false,
                              label: "perminent address",
                              maxLength: 200,
                              controller:
                                  _editProfileController.perAddressControl,
                              hint: 'ex: Dr no,street,colony, city',
                              enableBorderColor: Colors.grey,
                              focusBorderColor: Colors.indigo[900],
                              enableBorderRadius: 15,
                              focusBorderRadius: 15,
                              type: "address",
                              errorBorderRadius: 15,
                              focusErrorRadius: 15,
                              validateMsg: 'Enter Valid perminent address',
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
                                                      (DateTime.fromMillisecondsSinceEpoch(
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
                              maxLength: 60,
                              controller:
                                  _editProfileController.businessNameControl,
                              hint: 'ex : electronic shop , skml parlour',
                              enableBorderColor: Colors.grey,
                              focusBorderColor: Colors.indigo[900],
                              enableBorderRadius: 15,
                              focusBorderRadius: 15,
                              errorBorderRadius: 15,
                              focusErrorRadius: 15,
                              validateMsg: 'Enter Valid Business Name',
                              maxLines: 1,
                              postIcon: Icon(Icons.change_circle),
                              postIconColor: Colors.indigo[900],
                            ),
                          ),
                          Container(
                            width: width * 0.9,
                            padding: EdgeInsets.only(bottom: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Container(
                                    // color: Colors.green,

                                    // padding: EdgeInsets.all(15),
                                    child: TextFieldWidget(
                                      label: "Experience",
                                      controller: _editProfileController
                                          .experienceControl,
                                      maxLength: 2,
                                      formatter: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9]')),
                                      ],
                                      hint: 'ex : 1 year, 2 year, etc...,',
                                      enableBorderColor: Colors.grey,
                                      focusBorderColor: Colors.indigo[900],
                                      enableBorderRadius: 15,
                                      focusBorderRadius: 15,
                                      errorBorderRadius: 15,
                                      focusErrorRadius: 15,
                                      validateMsg: 'Enter Valid experience',
                                      maxLines: 1,
                                      postIcon: Icon(Icons.change_circle),
                                      postIconColor: Colors.indigo[900],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    // color: Colors.amber,
                                    child: DropdownButton(
                                      underline: SizedBox(),
                                      value:
                                          _editProfileController.dropDownValue,
                                      icon: Icon(
                                        Icons.arrow_drop_down_circle,
                                        size: width * 0.06,
                                        color: Colors.indigo[900],
                                      ),
                                      items: <int>[0, 1, 2]
                                          .map<DropdownMenuItem<int>>(
                                              (int jobFromFAB) {
                                        return DropdownMenuItem<int>(
                                            value: jobFromFAB,
                                            child: TextWid(
                                              text: _editProfileController
                                                  .accountType
                                                  .elementAt(
                                                      // jobFromHome == null
                                                      //     ?
                                                      jobFromFAB
                                                      // : jobFromHome,
                                                      ),
                                              color: Colors.grey[900],
                                              size: width * 0.04,
                                              weight: FontWeight.w500,
                                            ));
                                      }).toList(),
                                      onChanged: (newVal) {
                                        _editProfileController.dropDownValue =
                                            newVal;
                                        _editProfileController.refresh();
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 20),
                            constraints: boxConstraints,
                            child: ProfilePic(
                              name: "F",
                              profile: _editProfileController.adharF,
                              isProfile: false,
                              size: width * 0.15,
                              onClick: () {
                                changeImages("adharF");
                              },
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 20),
                            constraints: boxConstraints,
                            child: ProfilePic(
                              name: "B",
                              profile: _editProfileController.adharB,
                              isProfile: false,
                              size: width * 0.15,
                              onClick: () {
                                changeImages("adharB");
                              },
                            ),
                          ),
                          // otherDocs != null
                          //     ? Container(
                          //         height: 200,
                          //         width: 300,
                          //         child: ListView.builder(
                          //             itemCount: otherDocs.length,
                          //             itemBuilder: (BuildContext cxtx, int index) {
                          //               return Container(
                          //                 padding: EdgeInsets.only(top: 20),
                          //                 constraints: boxConstraints,
                          //                 color: Colors.amber,
                          //                 child: ProfilePic(
                          //                   name: "B",
                          //                   profile: otherDocs[index],
                          //                   isProfile: false,
                          //                   size: width * 0.15,
                          //                   // onClick: () {
                          //                   //   changeImages("adharB");
                          //                   // },
                          //                 ),
                          //               );
                          //             }),
                          //       )
                          //     : Container(),
                          Container(
                            padding: EdgeInsets.all(5),
                            child: ElevatedButtonWidget(
                              bgColor: Colors.indigo[50],
                              minWidth: width,
                              // height: hight * 0.06,
                              textColor: Colors.grey[900],
                              buttonName: 'Save',
                              textSize: width * 0.05,
                              textStyle: FontWeight.w600,
                              borderRadius: 5.0,
                              borderSideColor: Colors.indigo[50],
                              onClick: _editProfileController.saveChanges,
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
          ProgressWaiter(
            contextt: context,
            loaderState: data.editLoader,
            loadingName: data.editProfileLoaderName,
          )
        ],
      );
    });
  }

  Container nameField(double width) {
    return Container(
      width: width * 0.9,
      padding: EdgeInsets.only(bottom: 15, top: 15),
      child: TextFieldWidget(
        controller: _editProfileController.nameController,
        hint: 'Name',
        label: "Name",
        maxLength: 20,
        formatter: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
        ],
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
    );
  }

  @override
  Widget build(BuildContext context) {
    log("===============  Render editform ================");
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
