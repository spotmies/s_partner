import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';
import 'package:spotmies_partner/controllers/edit_profile_controller.dart';
import 'package:spotmies_partner/home/drawer%20and%20appBar/help/faq.dart';
import 'package:spotmies_partner/providers/partnerDetailsProvider.dart';
import 'package:spotmies_partner/providers/theme_provider.dart';

import 'package:spotmies_partner/reusable_widgets/basic_app_bar.dart';
import 'package:spotmies_partner/reusable_widgets/elevatedButtonWidget.dart';
import 'package:spotmies_partner/reusable_widgets/profile_pic.dart';
import 'package:spotmies_partner/reusable_widgets/progress_waiter.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';
import 'package:spotmies_partner/reusable_widgets/textfield_widget.dart';
import 'package:spotmies_partner/utilities/app_config.dart';
import 'package:spotmies_partner/utilities/snackbar.dart';

photoPicker() async {
  final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 40,
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
    log(pickedFile.path.toString());
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
  ) {
    return Consumer<PartnerDetailsProvider>(builder: (context, data, child) {
      return Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              color: SpotmiesTheme.background,
              padding: MediaQuery.of(context).viewInsets,
              child: Column(
                children: [
                  SizedBox(
                    height: height(context) * 0.04,
                  ),
                  Center(
                    child: Container(
                      padding: EdgeInsets.only(top: 20),
                      child: ProfilePic(
                        name: _editProfileController!.partner!['name'],
                        profile: _editProfileController!.profilePic,
                        size: width(context) * 0.18,
                        onClick: () {
                          changeImages("profile", _editProfileController);
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height(context) * 0.04,
                  ),
                  Form(
                      key: _editProfileController!.editProfileForm,
                      child: Column(
                        children: [
                          nameField(),
                          Container(
                            width: width(context) * 0.9,
                            padding: EdgeInsets.only(bottom: 15),
                            child: TextFieldWidget(
                              label: "Email",
                              controller:
                                  _editProfileController!.emailController,
                              hint: 'Email',
                              enableBorderColor: Colors.grey,
                              focusBorderColor: SpotmiesTheme.primary,
                              enableBorderRadius: 15,
                              focusBorderRadius: 15,
                              errorBorderRadius: 15,
                              focusErrorRadius: 15,
                              type: "email",
                              validateMsg: 'Enter Valid Email address',
                              maxLines: 1,
                              postIcon: Icon(Icons.change_circle),
                              postIconColor: SpotmiesTheme.primary,
                            ),
                          ),
                          Container(
                            width: width(context) * 0.9,
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
                              focusBorderColor: SpotmiesTheme.primary,
                              enableBorderRadius: 15,
                              focusBorderRadius: 15,
                              errorBorderRadius: 15,
                              focusErrorRadius: 15,
                              validateMsg: 'Enter Valid Phone number',
                              maxLines: 1,
                              postIcon: Icon(Icons.change_circle),
                              postIconColor: SpotmiesTheme.primary,
                            ),
                          ),
                          Container(
                            width: width(context) * 0.9,
                            padding: EdgeInsets.only(bottom: 15),
                            child: TextFieldWidget(
                              label: "Temparary address",
                              type: "address",
                              maxLength: 200,
                              controller:
                                  _editProfileController!.tempAddressControl,
                              hint: 'ex: Dr no,street,colony, city',
                              enableBorderColor: Colors.grey,
                              focusBorderColor: SpotmiesTheme.primary,
                              enableBorderRadius: 15,
                              focusBorderRadius: 15,
                              errorBorderRadius: 15,
                              focusErrorRadius: 15,
                              validateMsg: 'Enter Valid Temporary address',
                              maxLines: 4,
                              postIcon: Icon(Icons.change_circle),
                              postIconColor: SpotmiesTheme.primary,
                            ),
                          ),
                          Container(
                            width: width(context) * 0.9,
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
                              focusBorderColor: SpotmiesTheme.primary,
                              enableBorderRadius: 15,
                              focusBorderRadius: 15,
                              type: "address",
                              errorBorderRadius: 15,
                              focusErrorRadius: 15,
                              validateMsg: 'Enter Valid perminent address',
                              maxLines: 4,
                              postIcon: Icon(Icons.change_circle),
                              postIconColor: SpotmiesTheme.primary,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 15),
                            child: InkWell(
                              onTap: () async {
                                await _editProfileController!.pickDate(context);
                                setState(() {});
                              },
                              child: Container(
                                  width: width(context) * 0.9,
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: SpotmiesTheme.shadow,
                                            blurRadius: 3,
                                            spreadRadius: 1)
                                      ],
                                      color: SpotmiesTheme.surfaceVariant,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          TextWid(
                                            text: 'Date of Birth:',
                                            color:
                                                SpotmiesTheme.secondaryVariant,
                                            size: width(context) * 0.05,
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
                                              color: SpotmiesTheme
                                                  .secondaryVariant,
                                              size: width(context) * 0.04,
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
                              width: width(context) * 0.95,
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
                          InkWell(
                            onTap: () {
                              if (!_editProfileController!
                                  .enableModifications!) {
                                snackbar(context,
                                    "You don't have a access to update this data",
                                    label: "Ask permission", ontap: () {
                                  return newQuery(context,
                                      defaultContent:
                                          "Give access to update my professional data",
                                      onSubmit: (String output) {
                                    submitQuery(
                                        output,
                                        _editProfileController?.partner!["_id"],
                                        context,
                                        suggestionFor: "other");
                                  });
                                });
                              }
                            },
                            child: AbsorbPointer(
                              absorbing:
                                  !_editProfileController!.enableModifications!,
                              child: Column(
                                children: [
                                  Container(
                                    width: width(context) * 0.9,
                                    padding: EdgeInsets.only(bottom: 15),
                                    child: Column(
                                      children: [
                                        Container(
                                            alignment: Alignment.centerLeft,
                                            child: TextWid(
                                              text: "Select your Category",
                                              size: width(context) * 0.04,
                                              weight: FontWeight.bold,
                                            )),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              alignment: Alignment.centerRight,
                                              child: DropdownButton(
                                                underline: SizedBox(),
                                                value:
                                                    _editProfileController!.job,
                                                icon: Icon(
                                                  Icons.arrow_drop_down_circle,
                                                  size: width(context) * 0.06,
                                                  color: SpotmiesTheme.primary,
                                                ),
                                                items: data.getServiceList
                                                    .where((element) =>
                                                        element[
                                                            'isMainService'] ==
                                                        true)
                                                    .map((location) {
                                                  return DropdownMenuItem(
                                                    child: TextWid(
                                                      text: location[
                                                          'nameOfService'],
                                                      color: SpotmiesTheme
                                                          .secondaryVariant,
                                                      size: width(context) *
                                                          0.035,
                                                      weight: FontWeight.w500,
                                                    ),
                                                    value:
                                                        location['serviceId'],
                                                  );
                                                }).toList(),
                                                onChanged: (newVal) {
                                                  _editProfileController!.job =
                                                      newVal as int?;

                                                  _editProfileController!
                                                      .refresh();
                                                  setState(() {});
                                                },
                                              ),
                                            ),
                                            Container(
                                              // width: width(context) * 0.4,
                                              alignment: Alignment.centerRight,
                                              // color: Colors.amber,
                                              child: DropdownButton(
                                                isDense: true,
                                                underline: SizedBox(),
                                                value: _editProfileController!
                                                    .dropDownValue,
                                                icon: Icon(
                                                  Icons.arrow_drop_down_circle,
                                                  size: width(context) * 0.06,
                                                  color: SpotmiesTheme.primary,
                                                ),
                                                items: _editProfileController!
                                                    .accountType!
                                                    .map((type) {
                                                  return DropdownMenuItem(
                                                      value:
                                                          _editProfileController!
                                                              .accountType!
                                                              .indexOf(type),
                                                      child: TextWid(
                                                        text: type,
                                                        color: SpotmiesTheme
                                                            .secondaryVariant,
                                                        size: width(context) *
                                                            0.035,
                                                        weight: FontWeight.w500,
                                                      ));
                                                }).toList(),
                                                onChanged: (newVal) {
                                                  if (newVal == 0) return;
                                                  _editProfileController!
                                                          .dropDownValue =
                                                      newVal as int?;
                                                  _editProfileController!
                                                      .refresh();
                                                  setState(() {});
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: width(context) * 0.9,
                                    padding: EdgeInsets.only(bottom: 15),
                                    // padding: EdgeInsets.all(15),
                                    child: TextFieldWidget(
                                      label: _editProfileController!
                                                  .dropDownValue ==
                                              2
                                          ? "College Name"
                                          : "Business Name",
                                      maxLength: 60,
                                      controller: _editProfileController!
                                                  .dropDownValue ==
                                              2
                                          ? _editProfileController!
                                              .collgeNameControl
                                          : _editProfileController!
                                              .businessNameControl,
                                      hint: _editProfileController!
                                                  .dropDownValue ==
                                              2
                                          ? 'Enter your collge name here'
                                          : 'ex : Interior service pvt',
                                      enableBorderColor: Colors.grey,
                                      focusBorderColor: SpotmiesTheme.primary,
                                      enableBorderRadius: 15,
                                      focusBorderRadius: 15,
                                      errorBorderRadius: 15,
                                      focusErrorRadius: 15,
                                      validateMsg: _editProfileController!
                                                  .dropDownValue ==
                                              2
                                          ? 'Enter Valid College Name'
                                          : 'Enter valid Business name',
                                      maxLines: 1,
                                      postIcon: Icon(Icons.change_circle),
                                      postIconColor: SpotmiesTheme.primary,
                                      isRequired: false,
                                    ),
                                  ),
                                  Container(
                                    // color: Colors.green,
                                    width: width(context) * 0.9,
                                    padding: EdgeInsets.only(bottom: 15),
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
                                      focusBorderColor: SpotmiesTheme.primary,
                                      enableBorderRadius: 15,
                                      focusBorderRadius: 15,
                                      errorBorderRadius: 15,
                                      focusErrorRadius: 15,
                                      validateMsg: 'Enter Valid experience',
                                      maxLines: 1,
                                      postIcon: Icon(Icons.change_circle),
                                      postIconColor: SpotmiesTheme.primary,
                                    ),
                                  ),
                                  Container(
                                    height: height(context) * 0.25,
                                    width: width(context) * 0.9,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: FittedBox(
                                        fit: BoxFit.fill,
                                        child: ProfilePic(
                                          name: "F",
                                          profile:
                                              _editProfileController!.adharF,
                                          isProfile: false,
                                          size: width(context) * 0.15,
                                          onClick: () {
                                            changeImages("adharF",
                                                _editProfileController);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(15),
                                    child: TextWid(
                                      text: "Aadhar ID Front",
                                      size: width(context) * 0.035,
                                    ),
                                  ),
                                  Container(
                                    height: height(context) * 0.25,
                                    width: width(context) * 0.9,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: FittedBox(
                                        fit: BoxFit.fill,
                                        child: ProfilePic(
                                          name: "B",
                                          profile:
                                              _editProfileController!.adharB,
                                          isProfile: false,
                                          size: width(context) * 0.15,
                                          onClick: () {
                                            changeImages("adharB",
                                                _editProfileController);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(15),
                                    child: TextWid(
                                      text: "Aadhar ID Back",
                                      size: width(context) * 0.035,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: width(context) * 0.9,
                            padding: EdgeInsets.symmetric(vertical: 30),
                            child: ElevatedButtonWidget(
                              // trailingIcon: Icon(Icons.cloud_done),
                              bgColor: SpotmiesTheme.primary,
                              minWidth: width(context),
                              height: height(context) * 0.06,
                              textColor: SpotmiesTheme.surfaceVariant,
                              buttonName: 'Save',
                              textSize: width(context) * 0.05,
                              textStyle: FontWeight.w600,
                              borderRadius: 10.0,
                              allRadius: true,
                              borderSideColor: SpotmiesTheme.surfaceVariant,
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

  Container nameField() {
    return Container(
      width: width(context) * 0.9,
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
        focusBorderColor: SpotmiesTheme.primary,
        enableBorderRadius: 15,
        focusBorderRadius: 15,
        errorBorderRadius: 15,
        focusErrorRadius: 15,
        validateMsg: 'Enter Valid Name',
        maxLines: 1,
        postIcon: Icon(Icons.change_circle),
        postIconColor: SpotmiesTheme.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    log("===============  Render editform ================");
    return Scaffold(
      key: _editProfileController!.scaffoldkey,
      backgroundColor: SpotmiesTheme.background,
      appBar: basicAppbar(context,
          title: "Edit profile details",
          leadingIcon: Icon(
            Icons.edit,
            color: SpotmiesTheme.secondaryVariant,
          )),
      body: editDetails(context),
    );
  }
}
