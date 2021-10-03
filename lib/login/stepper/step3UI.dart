import 'package:flutter/material.dart';
import 'package:spotmies_partner/controllers/stepper_controller.dart';
import 'package:spotmies_partner/login/stepper/step2UI.dart';
import 'package:spotmies_partner/reusable_widgets/dottedBorder.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';

Widget step3UI(BuildContext context, StepperController stepperController,
    double _hight, double _width, String type) {
  return Container(
    height: _hight * 0.75,
    child: Form(
      key: stepperController.step3Formkey,
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(
                left: _width * 0.03,
                right: _width * 0.00,
                bottom: _width * 0.03),
            height: _hight * 0.08,
            width: _width * 0.8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWid(
                  text: 'Business type:',
                  color: Colors.grey[900],
                  size: _width * 0.05,
                  weight: FontWeight.w600,
                ),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.only(
                        left: _width * 0.03, right: _width * 0.03),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey[300],
                              blurRadius: 3,
                              spreadRadius: 1)
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: DropdownButton(
                      underline: SizedBox(),
                      value: stepperController.dropDownValue,
                      icon: Icon(
                        Icons.arrow_drop_down_circle,
                        size: _width * 0.06,
                        color: Colors.indigo[900],
                      ),
                      items: <int>[
                        0,
                        1,
                        2,
                        3,
                        4,
                        5,
                        6,
                        7,
                        8,
                        9,
                        10,
                        11,
                      ].map<DropdownMenuItem<int>>((int jobFromFAB) {
                        return DropdownMenuItem<int>(
                            value: jobFromFAB,
                            child: TextWid(
                              text: stepperController.jobs.elementAt(
                                  // jobFromHome == null
                                  //     ?
                                  jobFromFAB
                                  // : jobFromHome,
                                  ),
                              color: Colors.grey[900],
                              size: _width * 0.04,
                              weight: FontWeight.w500,
                            ));
                      }).toList(),
                      onChanged: (newVal) {
                        stepperController.dropDownValue = newVal;
                        stepperController.refresh();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          registrationField(
              _hight,
              context,
              stepperController,
              type != 'student' ? 'Business Name' : 'College Name',
              'Enter Valid Business Name',
              stepperController.businessNameTf,
              Icons.business,
              'text',
              TextInputType.name,
              30),
          registrationField(
              _hight,
              context,
              stepperController,
              'Years of experience',
              'Enter Valid Experience',
              stepperController.experienceTf,
              Icons.work,
              'number',
              TextInputType.number,
              2),
          uploadUI(_hight, _width, 'front', stepperController,
              stepperController.adharfront == null),
          uploadUI(_hight, _width, 'back', stepperController,
              stepperController.adharback == null),
          uploadUI(_hight, _width, 'clgId', stepperController,
              stepperController.clgId == null),
        ],
      ),
    ),
  );
}

uploadUI(
  double hight,
  double width,
  imageType,
  StepperController stepperController,
  bool condition,
) {
  return Container(
    padding: const EdgeInsets.all(8.0),
    decoration:
        BoxDecoration(borderRadius: BorderRadiusDirectional.circular(15)),
    child: condition
        ? DottedBorder(
            radius: Radius.circular(30),
            borderType: BorderType.RRect,
            child: Container(
              height: hight * 0.2,
              width: width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      if (imageType == 'front')
                        stepperController.adharfrontpage();
                      if (imageType == 'back') stepperController.adharBack();
                      if (imageType == 'clgId') stepperController.clgIdImage();
                    },
                    child: Icon(
                      Icons.cloud_upload,
                      size: width * 0.2,
                      color: Colors.teal,
                    ),
                  ),
                  TextWid(
                    text: imageType == 'front'
                        ? 'Aadhar Front'
                        : imageType == 'back'
                            ? 'Aadhar Back'
                            : 'College Identity',
                    size: width * 0.045,
                  )
                ],
              ),
            ))
        : Container(
            height: hight * 0.2,
            width: width * 0.70,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                shape: BoxShape.rectangle,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: FileImage(imageType == 'front'
                        ? stepperController.adharfront
                        : imageType == 'back'
                            ? stepperController.adharback
                            : stepperController.clgId))),
          ),
  );
}
