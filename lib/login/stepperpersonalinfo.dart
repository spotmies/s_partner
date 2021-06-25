import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spotmies_partner/apiCalls/apiCalling.dart';
import 'package:spotmies_partner/apiCalls/apiUrl.dart';
import 'package:spotmies_partner/apiCalls/testController.dart';
import 'package:spotmies_partner/home/home.dart';
import 'package:spotmies_partner/home/location.dart';
import 'package:spotmies_partner/utilities/snackbar.dart';

TextEditingController nameTf = TextEditingController();
TextEditingController dobTf = TextEditingController();
TextEditingController emailTf = TextEditingController();
TextEditingController numberTf = TextEditingController();
TextEditingController altnumberTf = TextEditingController();
TextEditingController peradTf = TextEditingController();
TextEditingController tempadTf = TextEditingController();
TextEditingController experienceTf = TextEditingController();
TextEditingController businessNameTf = TextEditingController();
ScrollController _scrollController = ScrollController();

class StepperPersonalInfo extends StatefulWidget {
  String value;
  StepperPersonalInfo({this.value});
  @override
  _StepperPersonalInfoState createState() => _StepperPersonalInfoState(value);
}

class _StepperPersonalInfoState extends State<StepperPersonalInfo> {
  String value;
  _StepperPersonalInfoState(this.value);
  var controller = TestController();
  String name;
  String dob;
  String email;
  String number;
  String perAd;
  String tempAd;
  String job;
  String businessName;
  String experience;
  DateTime pickedDate;
  TimeOfDay pickedTime;
  final _formkey = GlobalKey<FormState>();
  int _currentStep = 0;
  String altnumber;
  bool accept = false;
  String tca;
  File _profilepic;
  String picture = "";
  File _adharfront;
  String adharBackpage = "";
  File _adharback;
  String adharFrontpage = "";

  //langueges
  String otherlan;
  String lan1;
  String lan2;
  String lan3;
  bool telugu = false;
  bool english = false;
  bool hindi = false;
  int dropDownValue = 0;
  DateTime now = DateTime.now();

  void initState() {
    super.initState();
    pickedDate = DateTime.now();
    pickedTime = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    print(value);
    final _hight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Create account',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.grey[50],
        elevation: 0,
      ),
      backgroundColor: Colors.grey[50],
      body: Theme(
        data: ThemeData(primaryColor: Colors.blue[900]),
        child: Stepper(
            type: StepperType.horizontal,
            currentStep: _currentStep,
            onStepTapped: (int step) => setState(() => _currentStep = step),
            controlsBuilder: (BuildContext context,
                {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
              return Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: _width * 0.35,
                      child: ElevatedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.navigate_before),
                            Text('Back'),
                          ],
                        ),
                        onPressed: onStepCancel,
                        style: ButtonStyle(
                          backgroundColor: _currentStep > 0
                              ? MaterialStateProperty.all(Colors.blue[900])
                              : MaterialStateProperty.all(Colors.white),
                        ),
                      ),
                    ),
                    _currentStep == 3 // this is the last step
                        ? Container(
                            width: _width * 0.35,
                            child: ElevatedButton(
                              onPressed: () async {
                                step4();
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text('Finish'),
                                  Icon(Icons.navigate_next),
                                ],
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.blue[900]),
                              ),
                            ),
                          )
                        : Container(
                            width: _width * 0.35,
                            child: ElevatedButton(
                              onPressed: onStepContinue,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text('Next'),
                                  Icon(Icons.navigate_next),
                                ],
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.blue[900]),
                              ),
                            ),
                          ),
                  ],
                ),
              );
            },
            onStepContinue: _currentStep == 0
                ? () => setState(() {
                      step1();
                    })
                : _currentStep == 1
                    ? () => setState(() {
                          step2();
                        })
                    : _currentStep == 2
                        ? () => setState(() {
                              step3();
                            })
                        : _currentStep == 3
                            ? () => setState(() {
                                  step4();
                                })
                            : null,
            onStepCancel: _currentStep > 0
                ? () => setState(() => _currentStep -= 1)
                : null,
            steps: <Step>[
              Step(
                title: Text('Step1'),
                subtitle: Text('Terms'),
                content: Container(child: step1UI()),
                isActive: _currentStep >= 0,
                state:
                    _currentStep >= 0 ? StepState.complete : StepState.disabled,
              ),
              Step(
                title: Text('Step 2'),
                subtitle: Text('Profile'),
                content: Container(child: step2UI()),
                isActive: _currentStep >= 1,
                state:
                    _currentStep >= 1 ? StepState.complete : StepState.disabled,
              ),
              Step(
                title: Text('Step 3'),
                subtitle: Text('Photo'),
                content: step3UI(),
                isActive: _currentStep >= 2,
                state:
                    _currentStep >= 2 ? StepState.complete : StepState.disabled,
              ),
              Step(
                title: Text('Step 4'),
                subtitle: Text('Photo'),
                content: step4UI(),
                isActive: _currentStep >= 3,
                state:
                    _currentStep >= 3 ? StepState.complete : StepState.disabled,
              ),
            ]),
      ),
    );
  }

  step1() {
    if (accept == true) {
      _currentStep += 1;
    } else {
      Timer(
          Duration(milliseconds: 100),
          () => _scrollController
              .jumpTo(_scrollController.position.maxScrollExtent));

      snackbar(context, 'Need to accept all the terms & conditions');
    }
  }

  step2() async {
    if (_formkey.currentState.validate()) {
      _currentStep += 1;
    } else {
      snackbar(context, 'Fill all the fields');
    }
  }

  step3() {
    if (_adharfront != null && _adharback != null) {
      _currentStep += 1;
    } else {
      snackbar(context, 'Need to Upload Documents');
    }
  }

  step4() async {
    await imageUpload();

    // var od = ["pan", "voter"].toString();

    var legalDocs = {
      "otherDocs": ["pan", "voter"],
      "adharF": adharFrontpage,
      "adharB": adharBackpage
    };
    String docs = jsonEncode(legalDocs);
    print(jsonEncode(legalDocs));
    String lang = [lan1, lan2].toString();

    var body = {
      "docs": docs,
      "partnerPic": picture.toString(),
      "lang": lang.substring(1, lang.length - 1),
      "name": this.name.toString(),
      "phNum": 8019933883.toString(),
      "eMail": this.email.toString(),
      "job": 4.toString(),
      "pId": FirebaseAuth.instance.currentUser.uid.toString(),
      "join": DateTime.now().millisecondsSinceEpoch.toString(),
      "accountType": "student",
      "permission": 0.toString(),
      "lastLogin": DateTime.now().millisecondsSinceEpoch.toString(),
      "dob": "14-09-1997",
      // "dob": "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}",
      "businessName": this.businessName.toString(),
      "experience": this.experience.toString(),
      "acceptance": 100.toString(),
      "availability": false.toString(),
      "rate": 100.toString(),
      "perAdd": this.perAd.toString(),
      "tempAdd": this.tempAd.toString(),
    };
    await Server().postMethod(API.partnerRegister, body).catchError((e) {
      if (e == null) CircularProgressIndicator();
      print(e);
    });
    print(body);
    controller.postData();
    _profilepic != null
        ? Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => Home()), (route) => false)
        : snackbar(context, 'Need to Upload Profile Picture');
    _currentStep += 1;
  }

  Future<void> imageUpload() async {
    var postImageRef = FirebaseStorage.instance.ref().child('legalDoc');
    UploadTask pic = postImageRef
        .child(DateTime.now().toString() + ".jpg")
        .putFile(_profilepic);
    UploadTask adharF = postImageRef
        .child(DateTime.now().toString() + ".jpg")
        .putFile(_adharfront);
    UploadTask adharB = postImageRef
        .child(DateTime.now().toString() + ".jpg")
        .putFile(_adharback);
    var profilepic = await (await pic).ref.getDownloadURL();
    var adharFront = await (await adharF).ref.getDownloadURL();
    var adharBack = await (await adharB).ref.getDownloadURL();

    adharFrontpage = adharFront.toString();
    adharBackpage = adharBack.toString();
    picture = profilepic.toString();
  }

  //image pick
  Future<void> profilePic() async {
    var front = await ImagePicker().getImage(
      source: ImageSource.camera,
      imageQuality: 10,
      preferredCameraDevice: CameraDevice.rear,
    );
    setState(() {
      _profilepic = File(front.path);
    });
  }

  //image pick
  Future<void> adharfront() async {
    var front = await ImagePicker().getImage(
      source: ImageSource.camera,
      imageQuality: 10,
      preferredCameraDevice: CameraDevice.rear,
    );
    setState(() {
      _adharfront = File(front.path);
    });
  }

  Future<void> adharBack() async {
    var front = await ImagePicker().getImage(
      source: ImageSource.camera,
      imageQuality: 10,
      preferredCameraDevice: CameraDevice.rear,
    );
    setState(() {
      _adharback = File(front.path);
    });
  }

  _pickedDate() async {
    DateTime date = await showDatePicker(
        context: context,
        initialDate: pickedDate,
        firstDate: DateTime(DateTime.now().year - 80),
        lastDate: DateTime(
          DateTime.now().year + 0,
          DateTime.now().month + 0,
          DateTime.now().day + 0,
        ));
    if (date != null) {
      setState(() {
        pickedDate = date;
      });
    }
  }

  Widget step1UI() {
    var _hight = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          height: _hight * 0.66,
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('terms')
                  .doc('eXiU3vxjO7qeVObTqvmQ')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                var document = snapshot.data;
                return ListView(controller: _scrollController, children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '1. ' + document['1'],
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        '2.' + document['2'],
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        '3.' + document['3'],
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        '4.' + document['4'],
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        '5.' + document['5'],
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        '6.' + document['6'],
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        '7.' + document['7'],
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        '8.' + document['8'],
                        style: TextStyle(fontSize: 20),
                      ),
                      Row(
                        children: [
                          Checkbox(
                              activeColor: Colors.white,
                              checkColor: Colors.lightGreen,
                              value: accept,
                              onChanged: (bool value) {
                                setState(
                                  () {
                                    accept = value;
                                    if (accept == true) {
                                      tca = 'accepted';
                                    }
                                  },
                                );
                              }),
                          Text(
                            'I agree to accept the terms and Conditions',
                            style: TextStyle(fontSize: _width * 0.03),
                          ),
                        ],
                      ),
                    ],
                  ),
                ]);
              }),
        ),
      ],
    );
  }

//Step2

  Widget step2UI() {
    var _hight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.all(1),
      child: Form(
        key: _formkey,
        child: Container(
          height: _hight * 0.66,
          child: ListView(children: [
            Column(
              children: [
                Container(
                  height: 600,
                  width: 380,
                  child: ListView(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        height: 90,
                        width: 380,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: TextFormField(
                          keyboardType: TextInputType.name,
                          controller: nameTf,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(fontSize: 17),
                            hintText: 'Name',
                            suffixIcon: Icon(Icons.person),
                            //border: InputBorder.none,
                            contentPadding: EdgeInsets.all(20),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please Enter Your Name';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            this.name = value;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      InkWell(
                        onTap: () {
                          _pickedDate();
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          height: 90,
                          width: 380,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Date of Birth:',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                  '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}',
                                  style: TextStyle(fontSize: 15)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        height: 90,
                        width: 380,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(fontSize: 17),
                            hintText: 'Email',
                            suffixIcon: Icon(Icons.email),
                            //border: InputBorder.none,
                            contentPadding: EdgeInsets.all(20),
                          ),
                          validator: (value) {
                            if (value.isEmpty || !value.contains('@')) {
                              return 'Please Enter Valid Email';
                            }
                            return null;
                          },
                          controller: emailTf,
                          onChanged: (value) {
                            this.email = value;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        height: 90,
                        width: 380,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(fontSize: 17),
                            hintText: 'Alternative Mobile Number',
                            suffixIcon: Icon(Icons.dialpad),
                            //border: InputBorder.none,
                            contentPadding: EdgeInsets.all(20),
                          ),
                          validator: (value) {
                            if (value.isEmpty || value.length < 10) {
                              return 'Please Enter Valid Mobile Number';
                            }
                            return null;
                          },
                          controller: numberTf,
                          onChanged: (value) {
                            this.number = value;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        height: 90,
                        width: 380,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: TextFormField(
                          keyboardType: TextInputType.streetAddress,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(fontSize: 17),
                            hintText: 'Temparary Address',
                            suffixIcon: Icon(Icons.add_road),
                            //border: InputBorder.none,
                            contentPadding: EdgeInsets.all(20),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please Enter Address';
                            }
                            return null;
                          },
                          controller: tempadTf,
                          onChanged: (value) {
                            this.tempAd = value;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        height: 90,
                        width: 380,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: TextFormField(
                          keyboardType: TextInputType.streetAddress,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(fontSize: 17),
                            hintText: 'Perminent Address',
                            suffixIcon: Icon(Icons.add_road),
                            //border: InputBorder.none,
                            contentPadding: EdgeInsets.all(20),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please Enter Address';
                            }
                            return null;
                          },
                          controller: peradTf,
                          onChanged: (value) {
                            this.perAd = value;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        height: 250,
                        width: 380,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          children: [
                            CheckboxListTile(
                                title: Text('Telugu'),
                                value: telugu,
                                onChanged: (bool value) {
                                  setState(
                                    () {
                                      telugu = value;
                                      if (telugu == true) {
                                        this.lan1 = 'Telugu';
                                      }
                                    },
                                  );
                                  //Text('Telugu',style: TextStyle(color: Colors.amber),);
                                }),
                            CheckboxListTile(
                                title: Text('English'),
                                value: english,
                                onChanged: (bool value) {
                                  setState(
                                    () {
                                      english = value;
                                      if (english == true) {
                                        this.lan2 = 'English';
                                      }
                                    },
                                  );
                                  //Text('Telugu',style: TextStyle(color: Colors.amber),);
                                }),
                            CheckboxListTile(
                                title: Text('Hindi'),
                                value: hindi,
                                onChanged: (bool value) {
                                  setState(
                                    () {
                                      hindi = value;
                                      if (hindi == true) {
                                        this.lan3 = 'Hindi';
                                      }
                                    },
                                  );
                                  //Text('Telugu',style: TextStyle(color: Colors.amber),);
                                }),
                            TextFormField(
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(fontSize: 17),
                                hintText: 'others',
                                suffixIcon: Icon(Icons.add_road),
                                //border: InputBorder.none,
                                contentPadding: EdgeInsets.all(20),
                              ),
                              onChanged: (value) {
                                this.otherlan = value;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        height: 90,
                        width: 380,
                        // alignment: Alignment.centerRight,
                        decoration: BoxDecoration(
                            // border: Border.all(color: Colors.grey),

                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Select business type:',
                                style: TextStyle(fontSize: 17)),
                            SizedBox(
                              width: 15,
                            ),
                            // Text("data"),
                            DropdownButton(
                              // itemHeight: 0,
                              value: dropDownValue,

                              hint:
                                  //'$dropDownValue'==null?Text('select your job'):
                                  Text(
                                '$dropDownValue',
                                style: TextStyle(fontSize: 20),
                              ),
                              icon: Icon(Icons.arrow_downward_outlined),
                              items: [
                                DropdownMenuItem(
                                  value: 0,
                                  child: Text(
                                    'AC Service',
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 1,
                                  child: Text('Computer'),
                                ),
                                DropdownMenuItem(
                                  value: 2,
                                  child: Text('TV Repair'),
                                ),
                                DropdownMenuItem(
                                  value: 3,
                                  child: Text('Development'),
                                ),
                                DropdownMenuItem(
                                  value: 4,
                                  child: Text('Tutor'),
                                ),
                                DropdownMenuItem(
                                  value: 5,
                                  child: Text('Beauty'),
                                ),
                                DropdownMenuItem(
                                  value: 6,
                                  child: Text('Photography'),
                                ),
                                DropdownMenuItem(
                                  value: 7,
                                  child: Text('Drivers'),
                                ),
                                DropdownMenuItem(
                                  value: 8,
                                  child: Text('Events'),
                                ),
                              ],
                              onChanged: (newVal) {
                                setState(() {
                                  dropDownValue = newVal;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        height: 90,
                        width: 380,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: TextFormField(
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(fontSize: 17),
                            hintText: 'Business Name',
                            suffixIcon: Icon(Icons.add_road),
                            //border: InputBorder.none,
                            contentPadding: EdgeInsets.all(20),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please Enter Business Name';
                            }
                            return null;
                          },
                          controller: businessNameTf,
                          onChanged: (value) {
                            this.businessName = value;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        height: 90,
                        width: 380,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(fontSize: 17),
                            hintText: 'Experience',
                            suffixIcon: Icon(Icons.add_road),
                            //border: InputBorder.none,
                            contentPadding: EdgeInsets.all(20),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please Enter Years of Experience';
                            }
                            return null;
                          },
                          controller: experienceTf,
                          onChanged: (value) {
                            this.experience = value;
                          },
                        ),
                      ),
                      SizedBox(
                        height: _hight * 0.07,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  Widget step3UI() {
    var _hight = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Container(
      height: _hight * 0.66,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Card(
            child: Container(
              height: _hight * 0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      child: _adharfront == null
                          ? Icon(
                              Icons.image,
                              size: 100,
                              color: Colors.grey,
                            )
                          : Container(
                              height: _hight * 0.23,
                              width: _width * 0.70,
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: FileImage(_adharfront))),
                            ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30)),
                    ),
                    child: TextButton(
                        onPressed: () {
                          adharfront();
                        },
                        // icon: Icon(Icons.select_all),
                        child: Text(
                          'Aadhar Front',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        )),
                    // child: FlatButton(color:Colors.blue[700], onPressed: (){}, child: Text('Choose image')),
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Container(
              height: _hight * 0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      child: _adharback == null
                          ? Icon(
                              Icons.image,
                              size: 100,
                              color: Colors.grey,
                            )
                          : Container(
                              height: _hight * 0.23,
                              width: _width * 0.70,
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: FileImage(_adharback))),
                            ),
                    ),
                  ),
                  Container(
                    // height: 40,
                    // width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30)),
                      // border: Border.all()
                    ),
                    child: TextButton(
                        onPressed: () {
                          adharBack();
                        },
                        // icon: Icon(Icons.select_all),
                        child: Text(
                          'Aadhar Back',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        )),
                    // child: FlatButton(color:Colors.blue[700], onPressed: (){}, child: Text('Choose image')),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget step4UI() {
    var _hight = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          height: _hight * 0.66,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              'Profile Picture',
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                padding: EdgeInsets.all(10),
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  // border: Border.all()
                ),
                child: CircleAvatar(
                  child: Center(
                    child: _profilepic == null
                        ? Icon(
                            Icons.person,
                            color: Colors.blueGrey,
                            size: 200,
                          )
                        : Container(
                            height: _hight * 0.27,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: FileImage(_profilepic))),
                          ),
                  ),
                  radius: 30,
                  backgroundColor: Colors.grey[100],
                ),
              ),
            ),
            Container(
              height: 40,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
                // border: Border.all()
              ),
              child: TextButton(
                  onPressed: () {
                    profilePic();
                  },
                  // icon: Icon(Icons.select_all),
                  child: Text(
                    'Choose Image',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  )),
              // child: FlatButton(color:Colors.blue[700], onPressed: (){}, child: Text('Choose image')),
            ),
          ]),
        )
      ],
    );
  }
}
