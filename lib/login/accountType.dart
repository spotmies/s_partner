import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotmies_partner/login/stepper/stepperpersonalinfo.dart';
import 'package:spotmies_partner/reusable_widgets/elevatedButtonWidget.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';
import 'package:spotmies_partner/utilities/snackbar.dart';

class AccountType extends StatefulWidget {
  final String? phoneNumber;
  final Map? coordinates;
  AccountType({this.phoneNumber, this.coordinates});

  @override
  _AccountTypeState createState() => _AccountTypeState();
}

class _AccountTypeState extends State<AccountType> {
  bool freelanace = false;
  bool student = false;
  String userAccountType = "";
  @override
  void initState() {
    super.initState();
  }

  userType(student, freelanace, BuildContext context) {
    if (userAccountType == "")
      return snackbar(context, 'Please select any one of above');

    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (_) => StepperPersonalInfo(
              phone: widget.phoneNumber!,
              type: userAccountType,
              coordinates: widget.coordinates!)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _hight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: _hight * 0.1,
          ),
          Container(
            height: _hight * 0.2,
            child: SvgPicture.asset(
              'assets/accountType.svg',
            ),
          ),
          SizedBox(
            height: _hight * 0.07,
          ),
          Container(
            // height: _hight * 0.6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: _width * 0.05),
                  height: _hight * 0.07,
                  width: _width * 0.9,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.blueGrey[200]!)),
                  child: TextWid(
                    text: "What is your role ?",
                    size: _width * 0.055,
                    weight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: _hight * 0.04,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      // freelanace = !freelanace;
                      // student = false;
                      userAccountType = "business";
                    });
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: _width * 0.05),
                    // height: _hight * 0.06,
                    width: _width * 0.9,
                    decoration: BoxDecoration(
                        color: freelanace ? Colors.indigo[900] : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                            color: !freelanace
                                ? Colors.blueGrey[200]!
                                : Colors.white)),
                    child: Row(
                      children: [
                        Checkbox(
                            activeColor: Colors.white,
                            checkColor: Colors.indigo[900],
                            value: userAccountType == "business",
                            shape: CircleBorder(),
                            onChanged: (bool? value) {
                              setState(() {
                                // freelanace = value;
                                // student = false;
                                userAccountType = "business";
                              });
                            }),
                        Container(
                          child: TextWid(
                            text: "Self Employee / Local Business",
                            size: _width * 0.055,
                            weight: FontWeight.w600,
                            maxlines: 3,
                            color:
                                freelanace ? Colors.white : Colors.grey[700]!,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: _hight * 0.01,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      // student = !student;
                      // freelanace = false;
                      userAccountType = "student";
                    });
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: _width * 0.05),
                    height: _hight * 0.06,
                    width: _width * 0.9,
                    decoration: BoxDecoration(
                        color: student ? Colors.indigo[900] : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                            color: !student
                                ? Colors.blueGrey[200]!
                                : Colors.white)),
                    child: Row(
                      children: [
                        Checkbox(
                            activeColor: Colors.white,
                            checkColor: Colors.indigo[900],
                            value: userAccountType == "student",
                            shape: CircleBorder(),
                            onChanged: (bool? value) {
                              setState(() {
                                // student = value;
                                // freelanace = false;
                                userAccountType = "student";
                              });
                            }),
                        TextWid(
                          text: "Student",
                          size: _width * 0.055,
                          weight: FontWeight.w600,
                          color: student ? Colors.white : Colors.grey[700]!,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: _hight * 0.01,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      // student = !student;
                      // freelanace = false;
                      userAccountType = "freelancer";
                    });
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: _width * 0.05),
                    height: _hight * 0.06,
                    width: _width * 0.9,
                    decoration: BoxDecoration(
                        color: student ? Colors.indigo[900] : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                            color: !student
                                ? Colors.blueGrey[200]!
                                : Colors.white)),
                    child: Row(
                      children: [
                        Checkbox(
                            activeColor: Colors.white,
                            checkColor: Colors.indigo[900],
                            value: userAccountType == "freelancer",
                            shape: CircleBorder(),
                            onChanged: (bool? value) {
                              setState(() {
                                // student = value;
                                // freelanace = false;
                                userAccountType = "freelancer";
                              });
                            }),
                        TextWid(
                          text: "freelancer",
                          size: _width * 0.055,
                          weight: FontWeight.w600,
                          color: student ? Colors.white : Colors.grey[700]!,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: _hight * 0.35,
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButtonWidget(
                    height: _hight * 0.06,
                    minWidth: _width * 0.35,
                    buttonName: 'Join',
                    bgColor: Colors.indigo[900]!,
                    textColor: Colors.white,
                    textSize: _width * 0.05,
                    borderRadius: 15.0,
                    allRadius: true,
                    trailingIcon: Icon(
                      Icons.app_registration,
                    ),
                    onClick: () {
                      userType(student, freelanace, context);
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}



// userType(student, freelanace, BuildContext context) {
//   if (student == true) {
//     Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (_) => StepperPersonalInfo(type: 'student')),
//         (route) => false);
//   }
//   if (freelanace == true) {
//     Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(
//             builder: (_) => StepperPersonalInfo(type: 'Freelance')),
//         (route) => false);
//   } else {
//     snackbar(context, 'Please select any one of above');
//   }
// }


