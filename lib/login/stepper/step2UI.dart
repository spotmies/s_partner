import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:spotmies_partner/controllers/stepper_controller.dart';
import 'package:spotmies_partner/home/drawer%20and%20appBar/editDetailsBS.dart';
import 'package:spotmies_partner/reusable_widgets/date_formates.dart';
import 'package:spotmies_partner/reusable_widgets/profile_pic.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';
import 'package:spotmies_partner/reusable_widgets/textfield_widget.dart';

Widget step2(BuildContext context, StepperController stepperController,
    double hight, double width, String type) {
  return Form(
    key: stepperController.step2Formkey,
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
                      child: stepperController.profilepics == null
                          ? IconButton(
                              padding: EdgeInsets.all(0.0),
                              onPressed: () {
                                stepperController.profilePic();
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
                                          image: FileImage(
                                              stepperController.profilepics))),
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
                    backgroundColor: Colors.grey[100],
                  ),
                ),
              ),
              registrationField(
                  hight,
                  context,
                  stepperController,
                  'Name',
                  'Enter Valid Name',
                  stepperController.nameTf,
                  Icons.text_format,
                  "address",
                  TextInputType.name),
              Container(
                height: hight * 0.08,
                margin: EdgeInsetsDirectional.only(bottom: hight * 0.01),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey[200])),
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
                    text: getDate(
                            stepperController.pickedDate.millisecondsSinceEpoch)
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
                  TextInputType.emailAddress),
              registrationField(
                  hight,
                  context,
                  stepperController,
                  'Alternative Number',
                  'Enter Valid Number',
                  stepperController.altnumberTf,
                  Icons.phone_android,
                  "phone",
                  TextInputType.phone),
              registrationField(
                  hight,
                  context,
                  stepperController,
                  'Temparery address',
                  'Enter Valid address',
                  stepperController.tempadTf,
                  Icons.location_city,
                  "address",
                  TextInputType.streetAddress),
              registrationField(
                  hight,
                  context,
                  stepperController,
                  'Perminent address',
                  'Enter Valid address',
                  stepperController.peradTf,
                  Icons.location_city,
                  "address",
                  TextInputType.streetAddress),
              Container(
                width: width * 0.9,
                height: hight * 0.18,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[200]),
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
                        enableBorderColor: Colors.grey[200],
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
                        controller: stepperController.otherlan,
                        // onSubmitField: (value) {
                        //   // stepperController.otherlan = value;
                        //   // log(stepperController.otherlan.text.toString());
                        //   // if (value != null)
                        //   //   stepperController.localLang
                        //   //       .add(stepperController.otherlan.text);
                        // },
                        postIconColor: Colors.grey[600],
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
        onChanged: (bool value) {
          if (lan == 'Telugu') {
            stepperController.telugu = value;
            if (stepperController.telugu == true) {
              stepperController.lan1 = lan;
              stepperController.localLang.add(stepperController.lan1);
            } else {
              stepperController.localLang.remove(stepperController.lan1);
            }
          }
          if (lan == 'English') {
            stepperController.english = value;
            if (stepperController.english == true) {
              stepperController.lan2 = lan;
              stepperController.localLang.add(stepperController.lan2);
            } else {
              stepperController.localLang.remove(stepperController.lan2);
            }
          }
          if (lan == 'Hindi') {
            stepperController.hindi = value;
            if (stepperController.hindi == true) {
              stepperController.lan3 = lan;
              stepperController.localLang.add(stepperController.lan3);
            } else {
              stepperController.localLang.remove(stepperController.lan3);
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
    keyboardtype) {
  return Container(
    height: hight * 0.08,
    margin: EdgeInsets.only(bottom: hight * 0.01),
    child: TextFieldWidget(
      type: validator,
      // maxLength: 10,
      // formatter: <TextInputFormatter>[
      //   FilteringTextInputFormatter.allow(
      //       RegExp(r'[a-z]', caseSensitive: false)),
      // ],
      controller: _controller,
      hint: hint,
      enableBorderColor: Colors.grey[200],
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
      postIconColor: Colors.grey[600],
    ),
  );
}





// Widget step2UI(BuildContext context, StepperController stepperController,
//     double hight, double width) {
//   // var _hight = MediaQuery.of(context).size.height;
//   // var _width = MediaQuery.of(context).size.width;
//   return Padding(
//     padding: EdgeInsets.all(1),
//     child: Form(
//       key: stepperController.step2Formkey,
//       child: Container(
//         height: hight * 0.66,
//         child: ListView(children: [
//           Column(
//             children: [
//               Container(
//                 height: 530,
//                 width: width * 0.9,
//                 //color: Colors.amber,
//                 child: ListView(
//                   children: [
//                     Container(
//                       padding: EdgeInsets.all(10),
//                       // height: 90,
//                       width: width * 0.9,
//                       decoration: BoxDecoration(
//                           // color: Colors.amber,
//                           borderRadius: BorderRadius.circular(15)),
//                       child: TextFormField(
//                         keyboardType: TextInputType.name,
//                         controller: stepperController.nameTf,
//                         decoration: InputDecoration(
//                           hintStyle: TextStyle(fontSize: 17),
//                           hintText: 'Name',
//                           suffixIcon: Icon(Icons.person),
//                           //border: InputBorder.none,
//                           //contentPadding: EdgeInsets.all(20),
//                         ),
//                         validator: (value) {
//                           if (value.isEmpty) {
//                             return 'Please Enter Your Name';
//                           }
//                           return null;
//                         },
//                         onChanged: (value) {
//                           stepperController.name = value;
//                         },
//                       ),
//                     ),
//                     // SizedBox(
//                     //   height: 7,
//                     // ),
//                     InkWell(
//                       onTap: () {
//                         stepperController.pickedDates(context);
//                       },
//                       child: Container(
//                         padding: EdgeInsets.all(10),
//                         height: 90,
//                         width: width * 0.9,
//                         decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(15)),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               'Date of Birth:',
//                               style: TextStyle(
//                                   fontSize: 15, fontWeight: FontWeight.w500),
//                             ),
//                             Text(
//                                 '${stepperController.pickedDate.day}/${stepperController.pickedDate.month}/${stepperController.pickedDate.year}',
//                                 style: TextStyle(fontSize: 15)),
//                           ],
//                         ),
//                       ),
//                     ),
//                     // SizedBox(
//                     //   height: 7,
//                     // ),
//                     Container(
//                       padding: EdgeInsets.all(10),
//                       height: 90,
//                       width: width * 0.9,
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(15)),
//                       child: TextFormField(
//                         keyboardType: TextInputType.emailAddress,
//                         decoration: InputDecoration(
//                           hintStyle: TextStyle(fontSize: 17),
//                           hintText: 'Email',
//                           suffixIcon: Icon(Icons.email),
//                           //border: InputBorder.none,
//                           //contentPadding: EdgeInsets.all(20),
//                         ),
//                         validator: (value) {
//                           if (value.isEmpty || !value.contains('@')) {
//                             return 'Please Enter Valid Email';
//                           }
//                           return null;
//                         },
//                         controller: stepperController.emailTf,
//                         onChanged: (value) {
//                           stepperController.email = value;
//                         },
//                       ),
//                     ),
//                     SizedBox(
//                       height: 7,
//                     ),
//                     Container(
//                       padding: EdgeInsets.all(10),
//                       height: 90,
//                       width: width * 0.9,
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(15)),
//                       child: TextFormField(
//                         // inputFormatters: <TextInputFormatter>[
//                         //   FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
//                         // ],
//                         maxLength: 10,
//                         keyboardType: TextInputType.phone,
//                         decoration: InputDecoration(
//                             hintStyle: TextStyle(fontSize: 17),
//                             hintText: 'Alternative Mobile Number',
//                             suffixIcon: Icon(Icons.dialpad),
//                             //border: InputBorder.none,
//                             // //contentPadding: EdgeInsets.all(20),
//                             counterText: ""),
//                         validator: (value) {
//                           if (value.isEmpty || value.length < 10) {
//                             return 'Please Enter Valid Mobile Number';
//                           }
//                           return null;
//                         },
//                         controller: stepperController.numberTf,
//                         onChanged: (value) {
//                           stepperController.number = value;
//                         },
//                       ),
//                     ),
//                     SizedBox(
//                       height: 7,
//                     ),
//                     Container(
//                       padding: EdgeInsets.all(10),
//                       height: 90,
//                       width: width * 0.9,
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(15)),
//                       child: TextFormField(
//                         keyboardType: TextInputType.streetAddress,
//                         decoration: InputDecoration(
//                           hintStyle: TextStyle(fontSize: 17),
//                           hintText: 'Temparary Address',
//                           suffixIcon: Icon(Icons.add_road),
//                           //border: InputBorder.none,
//                           // //contentPadding: EdgeInsets.all(20),
//                         ),
//                         validator: (value) {
//                           if (value.isEmpty) {
//                             return 'Please Enter Address';
//                           }
//                           return null;
//                         },
//                         controller: stepperController.tempadTf,
//                         onChanged: (value) {
//                           stepperController.tempAd = value;
//                         },
//                       ),
//                     ),
//                     SizedBox(
//                       height: 7,
//                     ),
//                     Container(
//                       padding: EdgeInsets.all(10),
//                       height: 90,
//                       width: width * 0.9,
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(15)),
//                       child: TextFormField(
//                         keyboardType: TextInputType.streetAddress,
//                         decoration: InputDecoration(
//                           hintStyle: TextStyle(fontSize: 17),
//                           hintText: 'Perminent Address',
//                           suffixIcon: Icon(Icons.add_road),
//                           //border: InputBorder.none,
//                           ////contentPadding: EdgeInsets.all(20),
//                         ),
//                         validator: (value) {
//                           if (value.isEmpty) {
//                             return 'Please Enter Address';
//                           }
//                           return null;
//                         },
//                         controller: stepperController.peradTf,
//                         onChanged: (value) {
//                           stepperController.perAd = value;
//                         },
//                       ),
//                     ),
//                     SizedBox(
//                       height: 7,
//                     ),
//                     Container(
//                       padding: EdgeInsets.all(10),
//                       height: 250,
//                       width: width * 0.9,
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(15)),
//                       child: Column(
//                         children: [
//                           CheckboxListTile(
//                               title: Text('Telugu'),
//                               value: stepperController.telugu,
//                               onChanged: (bool value) {
//                                 stepperController.telugu = value;
//                                 if (stepperController.telugu == true) {
//                                   stepperController.lan1 = 'Telugu';
//                                 }
//                                 stepperController.refresh();
//                                 //Text('Telugu',style: TextStyle(color: Colors.amber),);
//                               }),
//                           CheckboxListTile(
//                               title: Text('English'),
//                               value: stepperController.english,
//                               onChanged: (bool value) {
//                                 stepperController.english = value;
//                                 if (stepperController.english == true) {
//                                   stepperController.lan2 = 'English';
//                                 }
//                                 stepperController.refresh();
//                                 //Text('Telugu',style: TextStyle(color: Colors.amber),);
//                               }),
//                           CheckboxListTile(
//                               title: Text('Hindi'),
//                               value: stepperController.hindi,
//                               onChanged: (bool value) {
//                                 stepperController.hindi = value;
//                                 if (stepperController.hindi == true) {
//                                   stepperController.lan3 = 'Hindi';
//                                 }
//                                 stepperController.refresh();
//                                 //Text('Telugu',style: TextStyle(color: Colors.amber),);
//                               }),
//                           TextFormField(
//                             keyboardType: TextInputType.name,
//                             decoration: InputDecoration(
//                               hintStyle: TextStyle(fontSize: 17),
//                               hintText: 'others',
//                               suffixIcon: Icon(Icons.add_road),
//                               //border: InputBorder.none,
//                               // //contentPadding: EdgeInsets.all(20),
//                             ),
//                             // onChanged: (value) {
//                             //   stepperController.otherlan = value;
//                             // },
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       height: 7,
//                     ),
//                     Container(
//                       padding: EdgeInsets.all(5),
//                       height: 90,
//                       width: width * 0.9,
//                       // alignment: Alignment.centerRight,
//                       decoration: BoxDecoration(
//                           // border: Border.all(color: Colors.grey),

//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(15)),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text('Select business type:',
//                               style: TextStyle(fontSize: 17)),
//                           SizedBox(
//                             width: 15,
//                           ),
//                           // Text("data"),
//                           DropdownButton(
//                             // itemHeight: 0,
//                             value: stepperController.dropDownValue,

//                             hint:
//                                 //'$dropDownValue'==null?Text('select your job'):
//                                 Text(
//                               '${stepperController.dropDownValue}',
//                               style: TextStyle(fontSize: 20),
//                             ),
//                             icon: Icon(Icons.arrow_downward_outlined),
//                             items: [
//                               DropdownMenuItem(
//                                 value: 0,
//                                 child: Text(
//                                   'AC Service',
//                                 ),
//                               ),
//                               DropdownMenuItem(
//                                 value: 1,
//                                 child: Text('Computer'),
//                               ),
//                               DropdownMenuItem(
//                                 value: 2,
//                                 child: Text('TV Repair'),
//                               ),
//                               DropdownMenuItem(
//                                 value: 3,
//                                 child: Text('Development'),
//                               ),
//                               DropdownMenuItem(
//                                 value: 4,
//                                 child: Text('Tutor'),
//                               ),
//                               DropdownMenuItem(
//                                 value: 5,
//                                 child: Text('Beauty'),
//                               ),
//                               DropdownMenuItem(
//                                 value: 6,
//                                 child: Text('Photography'),
//                               ),
//                               DropdownMenuItem(
//                                 value: 7,
//                                 child: Text('Drivers'),
//                               ),
//                               DropdownMenuItem(
//                                 value: 8,
//                                 child: Text('Events'),
//                               ),
//                             ],
//                             onChanged: (newVal) {
//                               stepperController.dropDownValue = newVal;
//                               stepperController.refresh();
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       height: 7,
//                     ),
//                     Container(
//                       padding: EdgeInsets.all(10),
//                       height: 90,
//                       width: width * 0.9,
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(15)),
//                       child: TextFormField(
//                         keyboardType: TextInputType.name,
//                         decoration: InputDecoration(
//                           hintStyle: TextStyle(fontSize: 17),
//                           hintText: 'Business Name',
//                           suffixIcon: Icon(Icons.add_road),
//                           //border: InputBorder.none,
//                           // //contentPadding: EdgeInsets.all(20),
//                         ),
//                         validator: (value) {
//                           if (value.isEmpty) {
//                             return 'Please Enter Business Name';
//                           }
//                           return null;
//                         },
//                         controller: stepperController.businessNameTf,
//                         onChanged: (value) {
//                           stepperController.businessName = value;
//                         },
//                       ),
//                     ),
//                     SizedBox(
//                       height: 7,
//                     ),
//                     Container(
//                       padding: EdgeInsets.all(10),
//                       height: 90,
//                       width: width * 0.9,
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(15)),
//                       child: TextFormField(
//                         // inputFormatters: <TextInputFormatter>[
//                         //   FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
//                         // ],
//                         maxLength: 2,
//                         keyboardType: TextInputType.phone,
//                         decoration: InputDecoration(
//                             hintStyle: TextStyle(fontSize: 17),
//                             hintText: 'Experience',
//                             suffixIcon: Icon(Icons.add_road),
//                             //border: InputBorder.none,
//                             //contentPadding: EdgeInsets.all(20),
//                             counterText: ""),
//                         validator: (value) {
//                           if (value.isEmpty) {
//                             return 'Please Enter Years of Experience';
//                           }
//                           return null;
//                         },
//                         controller: stepperController.experienceTf,
//                         onChanged: (value) {
//                           stepperController.experience = value;
//                         },
//                       ),
//                     ),
//                     SizedBox(
//                       height: hight * 0.07,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ]),
//       ),
//     ),
//   );
// }
