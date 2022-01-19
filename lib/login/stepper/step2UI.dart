import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:spotmies_partner/controllers/stepper_controller.dart';
import 'package:spotmies_partner/reusable_widgets/date_formates.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';
import 'package:spotmies_partner/reusable_widgets/textfield_widget.dart';

Widget step2(BuildContext context, StepperController? stepperController,
    double hight, double width, String type) {
  return Form(
    key: stepperController?.step2Formkey,
    child: Column(
      children: [
        Container(
          height: hight * 0.75,
          child: ListView(
            children: [
              Center(
                child: Container(
                  // padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(bottom: width * 0.07),
                  height: hight * 0.25,
                  width: width * 0.4,
                  child: CircleAvatar(
                    child: Center(
                      child: stepperController?.profilepics == null
                          ? IconButton(
                              padding: EdgeInsets.all(0.0),
                              onPressed: () {
                                stepperController?.profilePic();
                                stepperController?.refresh();
                              },
                              icon: Icon(
                                Icons.photo_camera,
                                color: Colors.grey[500],
                                size: width * 0.15,
                              ))
                          : Stack(
                              children: [
                                Container(
                                  height: hight * 0.27,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: FileImage(stepperController!
                                              .profilepics!))),
                                ),
                                Positioned(
                                    bottom: width * 0.02,
                                    right: width * 0.02,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey[300],
                                      radius: width * 0.05,
                                      child: IconButton(
                                          padding: EdgeInsets.all(0.0),
                                          onPressed: () {
                                            stepperController.profilePic();
                                          },
                                          icon: Icon(
                                            Icons.change_circle,
                                            color: Colors.grey[900],
                                            size: width * 0.055,
                                          )),
                                    ))
                              ],
                            ),
                    ),
                    radius: 30,
                    backgroundColor: Colors.grey[100]!,
                  ),
                ),
              ),
              registrationField(
                  hight,
                  context,
                  stepperController!,
                  'Name',
                  'Enter Valid Name',
                  stepperController.nameTf,
                  Icons.text_format,
                  "name",
                  TextInputType.name,
                  16),
              Container(
                height: hight * 0.08,
                margin: EdgeInsetsDirectional.only(bottom: hight * 0.01),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey[200]!)),
                child: ListTile(
                  dense: true,
                  visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                  onTap: () {
                    stepperController.pickedDates(context);
                  },
                  title: TextWid(
                    text: 'DOB',
                    size: hight * 0.015,
                    weight: FontWeight.w600,
                  ),
                  subtitle: TextWid(
                    text: getDate(stepperController
                            .pickedDate!.millisecondsSinceEpoch)
                        .toString(),
                  ),
                  trailing: Icon(
                    Icons.calendar_today,
                    size: hight * 0.025,
                  ),
                ),
              ),
              registrationField(
                  hight,
                  context,
                  stepperController,
                  'Email',
                  'Enter Valid Email',
                  stepperController.emailTf,
                  Icons.email,
                  "email",
                  TextInputType.emailAddress,
                  30),
              registrationField(
                  hight,
                  context,
                  stepperController,
                  'Alternative Number',
                  'Enter Valid Number',
                  stepperController.altnumberTf,
                  Icons.phone_android,
                  "phone",
                  TextInputType.phone,
                  10),
              registrationField(
                  hight,
                  context,
                  stepperController,
                  'Temparery address',
                  'Enter Valid address',
                  stepperController.tempadTf,
                  Icons.location_city,
                  "address",
                  TextInputType.streetAddress,
                  200),
              registrationField(
                  hight,
                  context,
                  stepperController,
                  'Perminent address',
                  'Enter Valid address',
                  stepperController.peradTf,
                  Icons.location_city,
                  "address",
                  TextInputType.streetAddress,
                  200),
              Container(
                width: width * 0.9,
                height: hight * 0.18,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[200]!),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        checkbox(
                          stepperController,
                          'Telugu',
                          width,
                        ),
                        checkbox(
                          stepperController,
                          'English',
                          width,
                        ),
                        checkbox(
                          stepperController,
                          'Hindi',
                          width,
                        ),
                      ],
                    ),
                    Container(
                      height: hight * 0.07,
                      padding: EdgeInsets.only(
                          left: width * 0.03, right: width * 0.03),
                      child: TextFieldWidget(
                        hint: 'Other Languege',
                        isRequired: false,
                        enableBorderColor: Colors.grey[200]!,
                        focusBorderColor: Colors.grey,
                        enableBorderRadius: 10,
                        focusBorderRadius: 10,
                        errorBorderRadius: 10,
                        focusErrorRadius: 10,
                        maxLines: 1,
                        postIcon: Icon(
                          Icons.language,
                          size: hight * 0.025,
                        ),
                        controller: stepperController.otherlan!,
                        // onSubmitField: (value) {
                        //   // stepperController.otherlan = value;
                        //   // log(stepperController.otherlan.text.toString());
                        //   // if (value != null)
                        //   //   stepperController.localLang
                        //   //       .add(stepperController.otherlan.text);
                        // },
                        postIconColor: Colors.grey[600]!,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

checkbox(
  StepperController stepperController,
  lan,
  double width,
) {
  return Row(
    children: [
      TextWid(
        text: lan,
        size: width * 0.04,
      ),
      Checkbox(
        activeColor: Colors.indigo[900],
        onChanged: (bool? value) {
          if (lan == 'Telugu') {
            stepperController.telugu = value;
            if (stepperController.telugu == true) {
              stepperController.lan1 = lan;
              stepperController.localLang!.add(stepperController.lan1);
            } else {
              stepperController.localLang!.remove(stepperController.lan1);
            }
          }
          if (lan == 'English') {
            stepperController.english = value;
            if (stepperController.english == true) {
              stepperController.lan2 = lan;
              stepperController.localLang!.add(stepperController.lan2);
            } else {
              stepperController.localLang!.remove(stepperController.lan2);
            }
          }
          if (lan == 'Hindi') {
            stepperController.hindi = value;
            if (stepperController.hindi == true) {
              stepperController.lan3 = lan;
              stepperController.localLang!.add(stepperController.lan3);
            } else {
              stepperController.localLang!.remove(stepperController.lan3);
            }
          }

          log(stepperController.localLang.toString());

          stepperController.refresh();
        },
        shape: CircleBorder(),
        value: lan == 'Telugu'
            ? stepperController.telugu
            : lan == 'English'
                ? stepperController.english
                : stepperController.hindi,
      ),
    ],
  );
}

registrationField(
    hight,
    BuildContext context,
    StepperController stepperController,
    hint,
    validmsg,
    _controller,
    icon,
    validator,
    keyboardtype,
    length) {
  return Container(
    height: hight * 0.08,
    margin: EdgeInsets.only(bottom: hight * 0.01),
    child: TextFieldWidget(
      isRequired: true,

      type: validator,
      maxLength: length,
      // formatter: <TextInputFormatter>[
      //   FilteringTextInputFormatter.allow(
      //       RegExp(r'[a-z]', caseSensitive: false)),
      // ],
      controller: _controller,
      hint: hint,
      enableBorderColor: Colors.grey[200]!,
      focusBorderColor: Colors.grey,
      enableBorderRadius: 10,
      focusBorderRadius: 10,
      errorBorderRadius: 10,
      focusErrorRadius: 10,
      // contentPad: 15.0,
      validateMsg: validmsg,
      keyBoardType: keyboardtype,
      maxLines: 1,
      postIcon: Icon(
        icon,
        size: hight * 0.025,
      ),
      postIconColor: Colors.grey[600]!,
    ),
  );
}
