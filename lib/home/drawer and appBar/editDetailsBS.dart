import 'dart:async';
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

import '../../apiCalls/apiCalling.dart';

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
  EditProfileController? _editProfileController;
  // Timer? _debounce;
  // int _debouncetime = 500;

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
    _editProfileController = EditProfileController();
    editProvider = Provider.of<PartnerDetailsProvider>(context, listen: false);
    _editProfileController!.fillAllForms(widget.partner);
    // _editProfileController?.storeIdControl.addListener(_onSearchChanged);
    log("date ${_editProfileController!.partner} ");
    log("other ${_editProfileController!.otherDocs![0]} ");

    super.initState();
  }

  // _onSearchChanged() {
  //   if (_debounce?.isActive ?? false) _debounce?.cancel();
  //   _debounce = Timer(Duration(milliseconds: _debouncetime), () async {
  //     String val = _editProfileController!.storeIdControl.text;
  //     val = val.replaceAll(" ", "");
  //     if (val.length > 3) {
  //       ///here you perform your search
  //       if (val == editProvider?.partnerDetailsFull!['storeId']) {
  //         return editProvider?.setHelperText(
  //             "www.spotmies.com/store/$val is your store url",
  //             color: Color.fromARGB(255, 53, 134, 56));
  //       }
  //       editProvider?.setHelperText("Checking ....");
  //       bool result = await _editProfileController?.checkStoreId(val);

  //       if (result) {
  //         return editProvider?.setHelperText(
  //             "✅  www.spotmies.com/store/$val  available",
  //             color: Color.fromARGB(255, 53, 134, 56));
  //       }
  //       return editProvider?.setHelperText(
  //           "❌ www.spotmies.com/store/$val Not available",
  //           color: Colors.red);
  //     }
  //   });
  // }

  @override
  void dispose() {
    editProvider?.setHelperText("", notify: false);
    // _editProfileController!.storeIdControl.removeListener(_onSearchChanged);
    _editProfileController!.storeIdControl.dispose();

    super.dispose();
  }

  editDetails(
    BuildContext context,
  ) {
    log("rendering edit-----------");
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
                            // child:
                            // AbsorbPointer(
                            //   absorbing:
                            //       !_editProfileController!.enableModifications!,
                            //   absorbing: false,
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
                                                color: Colors.indigo[900],
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
                                                    color: Colors.grey[900]!,
                                                    size:
                                                        width(context) * 0.035,
                                                    weight: FontWeight.w500,
                                                  ),
                                                  value: location['serviceId'],
                                                );
                                              }).toList(),
                                              onChanged: (newVal) {
                                                _editProfileController!.job =
                                                    newVal as int;

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
                                                color: Colors.indigo[900],
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
                                                      color: Colors.grey[900]!,
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
                                    label:
                                        _editProfileController!.dropDownValue ==
                                                2
                                            ? "College Name"
                                            : "Business Name",
                                    maxLength: 60,
                                    controller:
                                        _editProfileController!.dropDownValue ==
                                                2
                                            ? _editProfileController!
                                                .collgeNameControl
                                            : _editProfileController!
                                                .businessNameControl,
                                    hint:
                                        _editProfileController!.dropDownValue ==
                                                2
                                            ? 'Enter your collge name here'
                                            : 'ex : Interior service pvt',
                                    enableBorderColor: Colors.grey,
                                    focusBorderColor: Colors.indigo[900]!,
                                    enableBorderRadius: 15,
                                    focusBorderRadius: 15,
                                    errorBorderRadius: 15,
                                    focusErrorRadius: 15,
                                    validateMsg:
                                        _editProfileController!.dropDownValue ==
                                                2
                                            ? 'Enter Valid College Name'
                                            : 'Enter valid Business name',
                                    maxLines: 1,
                                    postIcon: Icon(Icons.change_circle),
                                    postIconColor: Colors.indigo[900]!,
                                    isRequired: false,
                                  ),
                                ),
                                StoreIdFormField(
                                  onChange: (val) {
                                    _editProfileController!
                                        .storeIdControl.text = val;
                                  },
                                  text: _editProfileController!
                                      .storeIdControl.text,
                                  hint: _editProfileController!
                                      .businessNameControl.text,
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
                                Visibility(
                                  visible: _editProfileController!
                                      .enableModifications!,
                                  child: Column(
                                    children: [
                                      Container(
                                        height: height(context) * 0.25,
                                        width: width(context) * 0.9,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: FittedBox(
                                            fit: BoxFit.fill,
                                            child: ProfilePic(
                                              name: "F",
                                              profile: _editProfileController!
                                                  .adharF,
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: FittedBox(
                                            fit: BoxFit.fill,
                                            child: ProfilePic(
                                              name: "B",
                                              profile: _editProfileController!
                                                  .adharB,
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
                              ],
                            ),
                            // ),
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
      key: scaffoldkeyEditProfile,
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

class StoreIdFormField extends StatefulWidget {
  const StoreIdFormField(
      {Key? key,
      required this.onChange,
      required this.text,
      required this.hint})
      : super(key: key);

  final Function onChange;
  final String text;
  final String hint;

  @override
  State<StoreIdFormField> createState() => _StoreIdFormFieldState();
}

class _StoreIdFormFieldState extends State<StoreIdFormField> {
  PartnerDetailsProvider? editProvider;
  TextEditingController storeIdControl = TextEditingController();

  Timer? _debounce;
  int _debouncetime = 500;
  void initState() {
    editProvider = Provider.of<PartnerDetailsProvider>(context, listen: false);
    storeIdControl.addListener(_onSearchChanged);
    storeIdControl.text = widget.text;

    super.initState();
  }

  @override
  void dispose() {
    editProvider?.setHelperText("", notify: false);
    storeIdControl.removeListener(_onSearchChanged);
    storeIdControl.dispose();

    super.dispose();
  }

  _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: _debouncetime), () async {
      String val = storeIdControl.text;
      val = val.replaceAll(" ", "");
      if (val.length > 3) {
        ///here you perform your search
        if (val == editProvider?.partnerDetailsFull!['storeId']) {
          return editProvider?.setHelperText(
              "www.spotmies.com/store/$val is your store url",
              color: Color.fromARGB(255, 53, 134, 56));
        }
        editProvider?.setHelperText("Checking ....");
        bool result = await checkStoreId(val);

        if (result) {
          return editProvider?.setHelperText(
              "✅  www.spotmies.com/store/$val  available",
              color: Color.fromARGB(255, 53, 134, 56));
        }
        return editProvider?.setHelperText(
            "❌ www.spotmies.com/store/$val Not available",
            color: Colors.red);
      }
    });
  }

  checkStoreId(String value) async {
    return await Server().checkStoreIdAvailability(value);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PartnerDetailsProvider>(builder: (context, data, child) {
      return Container(
        width: width(context) * 0.9,
        padding: EdgeInsets.only(bottom: 15),
        child: TextFieldWidget(
          label: "Your store Url",
          controller: storeIdControl,
          maxLength: 20,
          isRequired: false,
          hint: 'ex : ${widget.hint}',
          enableBorderColor: Colors.grey,
          focusBorderColor: Colors.indigo[900]!,
          enableBorderRadius: 15,
          focusBorderRadius: 15,
          errorBorderRadius: 15,
          focusErrorRadius: 15,
          validateMsg: 'Enter valid url',
          maxLines: 1,
          postIcon: Icon(Icons.change_circle),
          postIconColor: Colors.indigo[900]!,
          helperText: editProvider?.helperText,
          helperColor: editProvider?.helperColor,
          formatter: [
            FilteringTextInputFormatter.allow(RegExp("[a-z]")),
          ],
          onChange: (val) async {
            widget.onChange(val);
            if (val?.length < 4) {
              return editProvider?.setHelperText(
                  "❌ www.spotmies.com/store/$val Not available",
                  color: Colors.red);
            }
          },
        ),
      );
    });
  }
}
