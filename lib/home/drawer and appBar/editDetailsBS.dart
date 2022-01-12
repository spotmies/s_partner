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

photoPicker() async {
  final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 30,
      preferredCameraDevice: CameraDevice.rear);
  return pickedFile;
}

class EditProfile extends StatefulWidget {
  final Map partner;
  EditProfile(this.partner);
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends StateMVC<EditProfile> {
  EditProfileController? _editProfileController = EditProfileController();

  PartnerDetailsProvider? editProvider;
  void changeImages(whichImage, controller) async {
    print(" profile ${controller.profilePic}");
    final pickedFile = await photoPicker();
    switch (whichImage) {
      case "profile":
        controller.profilePic = File(pickedFile?.path);
        break;
      case "adharF":
        controller.adharF = File(pickedFile?.path);
        break;
      case "adharB":
        controller.adharB = File(pickedFile?.path);
        break;

      default:
    }
    setState(() {});
    log("pic ${controller.profilePic}");

    // if (pickedFile.path == null) retrieveLostData();
  }

  void initState() {
    editProvider = Provider.of<PartnerDetailsProvider>(context, listen: false);
    _editProfileController!.fillAllForms(widget.partner);
    log("date ${_editProfileController!.partner} ");
    log("other ${_editProfileController!.otherDocs![0]} ");

    super.initState();
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
                        name: _editProfileController!.partner!['name'],
                        profile: _editProfileController!.profilePic,
                        size: width * 0.15,
                        onClick: () {
                          changeImages("profile", _editProfileController);
                        },
                      ),
                    ),
                  ),
                  Form(
                      key: _editProfileController!.editProfileForm,
                      child: Column(
                        children: [
                          nameField(width),
                          Container(
                            width: width * 0.9,
                            padding: EdgeInsets.only(bottom: 15),
                            child: TextFieldWidget(
                              label: "Email",
                              controller:
                                  _editProfileController!.emailController,
                              hint: 'Email',
                              enableBorderColor: Colors.grey,
                              focusBorderColor: Colors.indigo[900]!,
                              enableBorderRadius: 15,
                              focusBorderRadius: 15,
                              errorBorderRadius: 15,
                              focusErrorRadius: 15,
                              type: "email",
                              validateMsg: 'Enter Valid Email address',
                              maxLines: 1,
                              postIcon: Icon(Icons.change_circle),
                              postIconColor: Colors.indigo[900]!,
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
                                  _editProfileController!.mobileController,
                              hint: 'ex : 9876543210',
                              enableBorderColor: Colors.grey,
                              focusBorderColor: Colors.indigo[900]!,
                              enableBorderRadius: 15,
                              focusBorderRadius: 15,
                              errorBorderRadius: 15,
                              focusErrorRadius: 15,
                              validateMsg: 'Enter Valid Phone number',
                              maxLines: 1,
                              postIcon: Icon(Icons.change_circle),
                              postIconColor: Colors.indigo[900]!,
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
                                  _editProfileController!.tempAddressControl,
                              hint: 'ex: Dr no,street,colony, city',
                              enableBorderColor: Colors.grey,
                              focusBorderColor: Colors.indigo[900]!,
                              enableBorderRadius: 15,
                              focusBorderRadius: 15,
                              errorBorderRadius: 15,
                              focusErrorRadius: 15,
                              validateMsg: 'Enter Valid Temporary address',
                              maxLines: 4,
                              postIcon: Icon(Icons.change_circle),
                              postIconColor: Colors.indigo[900]!,
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
                                  _editProfileController!.perAddressControl,
                              hint: 'ex: Dr no,street,colony, city',
                              enableBorderColor: Colors.grey,
                              focusBorderColor: Colors.indigo[900]!,
                              enableBorderRadius: 15,
                              focusBorderRadius: 15,
                              type: "address",
                              errorBorderRadius: 15,
                              focusErrorRadius: 15,
                              validateMsg: 'Enter Valid perminent address',
                              maxLines: 4,
                              postIcon: Icon(Icons.change_circle),
                              postIconColor: Colors.indigo[900]!,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 15),
                            child: InkWell(
                              onTap: () async {
                                await _editProfileController!.pickDate(context);
                              },
                              child: Container(
                                  width: width * 0.9,
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey[300]!,
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
                                            color: Colors.grey[900]!,
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
                                                          (_editProfileController!
                                                              .pickedDate!
                                                              .millisecondsSinceEpoch)))),
                                              color: Colors.grey[900]!,
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
                              width: width * 0.95,
                              padding: EdgeInsets.only(
                                  top: 50, bottom: 40, left: 15, right: 15),
                              child: Row(children: [
                                Expanded(
                                    child: Container(
                                  height: 3,
                                  color: Colors.grey,
                                )),
                                Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: TextWid(
                                        text: "Your Professional Details",
                                        weight: FontWeight.bold)),
                                Expanded(
                                    child: Container(
                                  height: 3,
                                  color: Colors.grey,
                                )),
                              ])),
                          Container(
                            width: width * 0.9,
                            padding: EdgeInsets.only(bottom: 15),
                            // padding: EdgeInsets.all(15),
                            child: TextFieldWidget(
                              label: _editProfileController!.dropDownValue == 2
                                  ? "College Name"
                                  : "Business Name",
                              maxLength: 60,
                              controller: _editProfileController!
                                          .dropDownValue ==
                                      2
                                  ? _editProfileController!.collgeNameControl
                                  : _editProfileController!.businessNameControl,
                              hint: _editProfileController!.dropDownValue == 2
                                  ? 'Enter your collge name here'
                                  : 'ex : Interior service pvt',
                              enableBorderColor: Colors.grey,
                              focusBorderColor: Colors.indigo[900]!,
                              enableBorderRadius: 15,
                              focusBorderRadius: 15,
                              errorBorderRadius: 15,
                              focusErrorRadius: 15,
                              validateMsg:
                                  _editProfileController!.dropDownValue == 2
                                      ? 'Enter Valid College Name'
                                      : 'Enter valid Business name',
                              maxLines: 1,
                              postIcon: Icon(Icons.change_circle),
                              postIconColor: Colors.indigo[900]!,
                              isRequired: false,
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
                                      controller: _editProfileController!
                                          .experienceControl,
                                      maxLength: 2,
                                      formatter: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9]')),
                                      ],
                                      hint: 'ex : 1 year, 2 year, etc...,',
                                      enableBorderColor: Colors.grey,
                                      focusBorderColor: Colors.indigo[900]!,
                                      enableBorderRadius: 15,
                                      focusBorderRadius: 15,
                                      errorBorderRadius: 15,
                                      focusErrorRadius: 15,
                                      validateMsg: 'Enter Valid experience',
                                      maxLines: 1,
                                      postIcon: Icon(Icons.change_circle),
                                      postIconColor: Colors.indigo[900]!,
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
                                          _editProfileController!.dropDownValue,
                                      icon: Icon(
                                        Icons.arrow_drop_down_circle,
                                        size: width * 0.06,
                                        color: Colors.indigo[900],
                                      ),
                                      items: _editProfileController!
                                          .accountType!
                                          .map((type) {
                                        return DropdownMenuItem(
                                            value: _editProfileController!
                                                .accountType!
                                                .indexOf(type),
                                            child: TextWid(
                                              text: type,
                                              color: Colors.grey[900]!,
                                              size: width * 0.04,
                                              weight: FontWeight.w500,
                                            ));
                                      }).toList(),
                                      onChanged: (newVal) {
                                        if (newVal == 0) return;
                                        _editProfileController!.dropDownValue =
                                            newVal as int?;
                                        _editProfileController!.refresh();
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: width * 0.9,
                            padding: EdgeInsets.only(bottom: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    child: TextWid(
                                  text: "Select your Category",
                                  size: width * 0.045,
                                  weight: FontWeight.bold,
                                )),
                                Container(
                                  child: DropdownButton(
                                    underline: SizedBox(),
                                    value: _editProfileController!.job,
                                    icon: Icon(
                                      Icons.arrow_drop_down_circle,
                                      size: width * 0.06,
                                      color: Colors.indigo[900],
                                    ),
                                    items: data.getServiceList.map((location) {
                                      return DropdownMenuItem(
                                        child: TextWid(
                                          text: location['nameOfService'],
                                          color: Colors.grey[900]!,
                                          size: width * 0.04,
                                          weight: FontWeight.w500,
                                        ),
                                        value: location['serviceId'],
                                      );
                                    }).toList(),
                                    onChanged: (newVal) {
                                      _editProfileController!.job =
                                          newVal as int?;

                                      _editProfileController!.refresh();
                                    },
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
                              profile: _editProfileController!.adharF,
                              isProfile: false,
                              size: width * 0.15,
                              onClick: () {
                                changeImages("adharF", _editProfileController);
                              },
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(15),
                            child: TextWid(
                              text: "Adhar ID Front",
                              size: width * 0.035,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 20),
                            constraints: boxConstraints,
                            child: ProfilePic(
                              name: "B",
                              profile: _editProfileController!.adharB,
                              isProfile: false,
                              size: width * 0.15,
                              onClick: () {
                                changeImages("adharB", _editProfileController);
                              },
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(15),
                            child: TextWid(
                              text: "Adhar ID Back",
                              size: width * 0.035,
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
                            width: width * 0.4,
                            padding: EdgeInsets.symmetric(vertical: 30),
                            child: ElevatedButtonWidget(
                              leadingIcon: Icon(Icons.save_rounded),
                              bgColor: Colors.indigo[900]!,
                              minWidth: width,
                              // height: hight * 0.06,
                              textColor: Colors.grey[50]!,
                              buttonName: 'Save',
                              textSize: width * 0.05,
                              textStyle: FontWeight.w600,
                              borderRadius: 5.0,
                              allRadius: true,
                              borderSideColor: Colors.indigo[50]!,
                              onClick: () {
                                _editProfileController!.saveChanges(context);
                              },
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
        controller: _editProfileController!.nameController,
        hint: 'Name',
        label: "Name",
        maxLength: 20,
        formatter: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
        ],
        enableBorderColor: Colors.grey,
        focusBorderColor: Colors.indigo[900]!,
        enableBorderRadius: 15,
        focusBorderRadius: 15,
        errorBorderRadius: 15,
        focusErrorRadius: 15,
        validateMsg: 'Enter Valid Name',
        maxLines: 1,
        postIcon: Icon(Icons.change_circle),
        postIconColor: Colors.indigo[900]!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    log("===============  Render editform ================");
    final width = MediaQuery.of(context).size.width;
    final hight = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _editProfileController!.scaffoldkey,
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
