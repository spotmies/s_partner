import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spotmies_partner/home/home.dart';

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
  @override
  _StepperPersonalInfoState createState() => _StepperPersonalInfoState();
}

class _StepperPersonalInfoState extends State<StepperPersonalInfo> {
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
  String imageLink3 = "";
  File _adharfront;
  String imageLink = "";
  File _adharback;
  String imageLink2 = "";

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
                                //await uploadimage();
                                _profilepic != null
                                    ? Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => Home()),
                                        (route) => false)
                                    : ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                        content: Text(
                                            'Need to Upload Profile Picture'),
                                        action: SnackBarAction(
                                          label: 'Close',
                                          onPressed: () {
                                            // Some code to undo the change.
                                          },
                                        ),
                                      ));

                                // Find the ScaffoldMessenger in the widget tree
                                // and use it to show a SnackBar.);;
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
                              //color: Colors.green,
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
                content: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      height: _hight * 0.75,
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
                            return ListView(
                                controller: _scrollController,
                                children: [
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              'I agree to accept the terms and Conditions'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ]);
                          }),
                    ),
                  ],
                ),
                isActive: _currentStep >= 0,
                state:
                    _currentStep >= 0 ? StepState.complete : StepState.disabled,
              ),
              Step(
                title: Text('Step 2'),
                subtitle: Text('Profile'),
                content: Padding(
                  padding: EdgeInsets.all(1),
                  // height: _hight * 0.75,
                  child: Form(
                    key: _formkey,
                    child: Container(
                      height: _hight * 0.75,
                      // padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: ListView(children: [
                        Column(
                          children: [
                            Container(
                              height: 600,
                              width: 380,
                              //color: Colors.amber,
                              child: ListView(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    height: 90,
                                    width: 380,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(15)),
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
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Date of Birth:',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
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
                                        borderRadius:
                                            BorderRadius.circular(15)),
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
                                        if (value.isEmpty ||
                                            !value.contains('@')) {
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
                                        borderRadius:
                                            BorderRadius.circular(15)),
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
                                        if (value.isEmpty ||
                                            value.length < 10) {
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
                                        borderRadius:
                                            BorderRadius.circular(15)),
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
                                        borderRadius:
                                            BorderRadius.circular(15)),
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
                                        borderRadius:
                                            BorderRadius.circular(15)),
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
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                          icon: Icon(
                                              Icons.arrow_downward_outlined),
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
                                        borderRadius:
                                            BorderRadius.circular(15)),
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
                                        borderRadius:
                                            BorderRadius.circular(15)),
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
                ),
                isActive: _currentStep >= 1,
                state:
                    _currentStep >= 1 ? StepState.complete : StepState.disabled,
              ),
              Step(
                title: Text('Step 3'),
                subtitle: Text('Photo'),
                content: Container(
                  height: _hight * 0.75,
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
                                                  image:
                                                      FileImage(_adharfront))),
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
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.grey),
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
                                                  image:
                                                      FileImage(_adharback))),
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
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.grey),
                                    )),
                                // child: FlatButton(color:Colors.blue[700], onPressed: (){}, child: Text('Choose image')),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                isActive: _currentStep >= 2,
                state:
                    _currentStep >= 2 ? StepState.complete : StepState.disabled,
              ),
              Step(
                title: Text('Step 4'),
                subtitle: Text('Photo'),
                content: Column(
                  children: [
                    Container(
                      height: _hight * 0.75,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                                                    image: FileImage(
                                                        _profilepic))),
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
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.grey),
                                  )),
                              // child: FlatButton(color:Colors.blue[700], onPressed: (){}, child: Text('Choose image')),
                            ),
                          ]),
                    )
                  ],
                ),
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

      FirebaseFirestore.instance
          .collection('partner')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .set({
        'joindate': DateTime.now(),
        'name': null,
        'email': null,
        'profilepic': null,
        // 'phone': '+91$value',
        'altNum': null,
        'terms&Conditions': tca,
        'orders': 0,
        'reference': 0,
        'acceptance': 0,
        'uid': FirebaseAuth.instance.currentUser.uid,
        'availability': false
      });
    } else {
      Timer(
          Duration(milliseconds: 100),
          () => _scrollController
              .jumpTo(_scrollController.position.maxScrollExtent));
      final snackBar = SnackBar(
        content: Text('Need to accept all the terms & conditions'),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );

      // Find the ScaffoldMessenger in the widget tree
      // and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  step2() {
    if (_formkey.currentState.validate()) {
      _currentStep += 1;
      FirebaseFirestore.instance
          .collection('partner')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .update({
        'name': this.name,
        'dob': '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}',
        'perAd': this.perAd,
        'altnum': this.number,
        'email': this.email,
        'tempAd': this.tempAd,
        'job': this.dropDownValue,
        'partnerid': FirebaseAuth.instance.currentUser.uid,
        'lan': ({'lan1': lan1, 'lan2': lan2, 'lan3': lan3, 'others': otherlan}),
        'businessname': businessName,
        'experience': experience,
        'reference': FieldValue.arrayUnion([100]),
        'orders': 0,
        'rate': 100,
        'acceptance': 100,
        'uid': FirebaseAuth.instance.currentUser.uid,
        'availability': false,
        'profilepic': null
      }).catchError((e) {
        print(e);
      });
    } else {
      final snackBar = SnackBar(
        content: Text('Fill all the fields'),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );

      // Find the ScaffoldMessenger in the widget tree
      // and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  step3() {
    if (_adharfront != null && _adharback != null) {
      adharimagefront();
      adharimageback();
      _currentStep += 1;
    } else {
      final snackBar = SnackBar(
        content: Text('Need to Upload Documents'),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );

      // Find the ScaffoldMessenger in the widget tree
      // and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  step4() {
    uploadProfileimage();
    _currentStep += 1;
  }

  //image pick
  Future<void> profilePic() async {
    var front = await ImagePicker().getImage(
      source: ImageSource.camera,
      imageQuality: 40,
      preferredCameraDevice: CameraDevice.rear,
    );
    setState(() {
      _profilepic = File(front.path);
    });
  }

//image upload function
  Future<void> uploadProfileimage() async {
    var postImageRef = FirebaseStorage.instance.ref().child('legalDoc');
    UploadTask uploadTask = postImageRef
        .child(DateTime.now().toString() + ".jpg")
        .putFile(_profilepic);
    print(uploadTask);
    var imageUrl = await (await uploadTask).ref.getDownloadURL();
    imageLink3 = imageUrl.toString();
    print(imageUrl);
    FirebaseFirestore.instance
        .collection('partner')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({'profilepic': imageLink3});
  }

  //image pick
  Future<void> adharfront() async {
    var front = await ImagePicker().getImage(
      source: ImageSource.camera,
      imageQuality: 40,
      preferredCameraDevice: CameraDevice.rear,
    );
    setState(() {
      _adharfront = File(front.path);
    });
  }

  Future<void> adharBack() async {
    var front = await ImagePicker().getImage(
      source: ImageSource.camera,
      imageQuality: 40,
      preferredCameraDevice: CameraDevice.rear,
    );
    setState(() {
      _adharback = File(front.path);
    });
  }

//image upload function
  Future<void> adharimagefront() async {
    var postImageRef = FirebaseStorage.instance.ref().child('legalDoc');
    UploadTask uploadTask = postImageRef
        .child(DateTime.now().toString() + ".jpg")
        .putFile(_adharback);
    print(uploadTask);
    var imageUrl = await (await uploadTask).ref.getDownloadURL();
    imageLink2 = imageUrl.toString();
    print(imageLink2);
    FirebaseFirestore.instance
        .collection('partner')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({'adhar.front': imageLink2});
  }

//image upload function
  Future<void> adharimageback() async {
    var postImageRef = FirebaseStorage.instance.ref().child('legalDoc');
    UploadTask uploadTask = postImageRef
        .child(DateTime.now().toString() + ".jpg")
        .putFile(_adharfront);
    var imageUrl = await (await uploadTask).ref.getDownloadURL();
    imageLink = imageUrl.toString();
    print(imageLink);

    FirebaseFirestore.instance
        .collection('partner')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({'adhar.back': imageLink});
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
}

//step1

// Row(
//   mainAxisAlignment: MainAxisAlignment.end,
//   children: [
//     (accept == true)
//         ? ElevatedButton(
//             child: Text(
//               'accept',
//               style: TextStyle(
//                   color: Colors.white),
//             ),
//             //color: Colors.blue,
//             onPressed: () {
//               // print(value);
//               FirebaseFirestore.instance
//                   .collection('users')
//                   .doc(FirebaseAuth
//                       .instance.currentUser.uid)
//                   .set({
//                 'joinedat': DateTime.now(),
//                 'name': null,
//                 'email': null,
//                 'profilepic': null,
//                 // 'phone': '+91$value',
//                 'altNum': null,
//                 'terms&Conditions': tca,
//                 'reference': 0,
//                 'uid': FirebaseAuth
//                     .instance.currentUser.uid
//               });

//               if (accept == true) {
//                 Navigator.pushAndRemoveUntil(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) =>
//                             PersonalInfo()),
//                     (route) => false);
//               }
//             })
//         : Container(
//             height: 10, color: Colors.white)
//   ],
// )

//step2
//  Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               ElevatedButton(
//                                   child: Text(
//                                     'Submit',
//                                     style: TextStyle(color: Colors.white),
//                                   ),
//                                   onPressed: () async {
//                                     if (_formkey.currentState.validate()) {
//                                       Navigator.pushAndRemoveUntil(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (_) => ProfilePic()),
//                                           (route) => false);
//                                     }

//                                     FirebaseFirestore.instance
//                                         .collection('users')
//                                         .doc(FirebaseAuth
//                                             .instance.currentUser.uid)
//                                         .update({
//                                       'name': this.name,
//                                       'altNum': this.number,
//                                       'email': this.email,
//                                       'uid':
//                                           FirebaseAuth.instance.currentUser.uid,
//                                       'reference': 0,
//                                       'profilepic': null
//                                     }).catchError((e) {
//                                       print(e);
//                                     });
//                                     val = true;
//                                   }),
//                             ],
//                           )
// class PersonalInfo extends StatefulWidget {
//   @override
//   _PersonalInfoState createState() => _PersonalInfoState();
// }

// class _PersonalInfoState extends State<PersonalInfo> {
//   String name;
//   String email;
//   String number;

//   // var format = DateFormat.yMd('ar').format(DateTime.now());
//   DateTime now = DateTime.now();

//   // CrudMethods adPost = new CrudMethods();

//   final _formkey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: Colors.black),
//         title: Text(
//           'Create account',
//           style: TextStyle(color: Colors.black),
//         ),
//         backgroundColor: Colors.grey[100],
//         elevation: 0,
//       ),
//       backgroundColor: Colors.grey[100],
//       body: Form(
//         key: _formkey,
//         child: ListView(children: [
//           Column(
//             children: [
//               Container(
//                 height: 600,
//                 width: 380,
//                 //color: Colors.amber,
//                 child: ListView(
//                   children: [
//                     Container(
//                       padding: EdgeInsets.all(10),
//                       height: 90,
//                       width: 380,
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(15)),
//                       child: TextFormField(
//                         keyboardType: TextInputType.name,
//                         controller: nameTf,
//                         decoration: InputDecoration(
//                           hintStyle: TextStyle(fontSize: 17),
//                           hintText: 'Name',
//                           suffixIcon: Icon(Icons.person),
//                           //border: InputBorder.none,
//                           contentPadding: EdgeInsets.all(20),
//                         ),
//                         validator: (value) {
//                           if (value.isEmpty) {
//                             return 'Please Enter Your Name';
//                           }
//                           return null;
//                         },
//                         onChanged: (value) {
//                           this.name = value;
//                         },
//                       ),
//                     ),
//                     SizedBox(
//                       height: 7,
//                     ),
//                     Container(
//                       padding: EdgeInsets.all(10),
//                       height: 90,
//                       width: 380,
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
//                           contentPadding: EdgeInsets.all(20),
//                         ),
//                         validator: (value) {
//                           if (value.isEmpty || !value.contains('@')) {
//                             return 'Please Enter Valid Email';
//                           }
//                           return null;
//                         },
//                         controller: emailTf,
//                         onChanged: (value) {
//                           this.email = value;
//                         },
//                       ),
//                     ),
//                     SizedBox(
//                       height: 7,
//                     ),
//                     Container(
//                       padding: EdgeInsets.all(10),
//                       height: 90,
//                       width: 380,
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(15)),
//                       child: TextFormField(
//                         keyboardType: TextInputType.phone,
//                         decoration: InputDecoration(
//                           hintStyle: TextStyle(fontSize: 17),
//                           hintText: 'Alternative Mobile Number',
//                           suffixIcon: Icon(Icons.dialpad),
//                           //border: InputBorder.none,
//                           contentPadding: EdgeInsets.all(20),
//                         ),
//                         validator: (value) {
//                           if (value.isEmpty || value.length < 10) {
//                             return 'Please Enter Valid Mobile Number';
//                           }
//                           return null;
//                         },
//                         controller: numberTf,
//                         onChanged: (value) {
//                           this.number = value;
//                         },
//                       ),
//                     ),
//                     SizedBox(
//                       height: 7,
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton(
//                       child: Text(
//                         'Submit',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                       // color: Colors.blue[900],
//                       // splashColor: Colors.blue,
//                       // shape: RoundedRectangleBorder(
//                       //     borderRadius:
//                       //         BorderRadius.all(Radius.circular(10.0))),
//                       onPressed: () async {
//                         if (_formkey.currentState.validate()) {
//                           Navigator.pushAndRemoveUntil(
//                               context,
//                               MaterialPageRoute(builder: (_) => ProfilePic()),
//                               (route) => false);
//                         }
//                         //print(now);

//                         // Map<String, dynamic> postData = {
//                         //   'name': this.name,
//                         //   'altNum': this.number,
//                         //   'email': this.email,
//                         //   'uid': FirebaseAuth.instance.currentUser.uid,
//                         //   'reference': 0,
//                         //   'profilepic': null
//                         // };
//                         // adPost.addData(postData).then((result) {
//                         //   // dialogTrrigger(context);
//                         // }).catchError((e) {
//                         //   print(e);
//                         // });
//                       }),
//                 ],
//               )
//             ],
//           ),
//         ]),
//       ),
//     );
//   }
// }

// class CrudMethods {
//   bool isLoggedIn() {
//     if (FirebaseAuth.instance.currentUser != null) {
//       return true;
//     } else {
//       return false;
//     }
//   }

//   Future<void> addData(postData) async {
//     if (isLoggedIn()) {
//       FirebaseFirestore.instance
//           .collection('users')
//           .doc(FirebaseAuth.instance.currentUser.uid)
//           .update(postData)
//           .catchError((e) {
//         print(e);
//       });
//     } else {
//       print('You need to login');
//     }
//   }
// }
