// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:spotmies_partner/home/location.dart';

// TextEditingController nameTf = TextEditingController();
// TextEditingController dobTf = TextEditingController();
// TextEditingController emailTf = TextEditingController();
// TextEditingController numberTf = TextEditingController();
// TextEditingController peradTf = TextEditingController();
// TextEditingController tempadTf = TextEditingController();
// TextEditingController experienceTf = TextEditingController();
// TextEditingController businessNameTf = TextEditingController();

// class PersonalInfo extends StatefulWidget {
//   const PersonalInfo ({Key? key}) : super(key: key);
//   @override
//   _PersonalInfoState createState() => _PersonalInfoState();
// }

// class _PersonalInfoState extends State<PersonalInfo> {
//   String? name;
//   String? dob;
//   String? email;
//   String? number;
//   String? perAd;
//   String? tempAd;
//   String? job;
//   String? businessName;
//   String? experience;
//   DateTime? pickedDate;
//   TimeOfDay? pickedTime;

//   //langueges
//   String? otherlan;
//   String? lan1;
//   String? lan2;
//   String? lan3;
//   bool? telugu = false;
//   bool? english = false;
//   bool? hindi = false;

//   //drop down value for service type;
//   int? dropDownValue = 0;
//   // var format = DateFormat.yMd('ar').format(DateTime.now());
//   DateTime? now = DateTime.now();

//   CrudMethods? adPost = new CrudMethods();

//   GlobalKey<FormState> _formkey = GlobalKey<FormState>();

//   @override
//   void initState() {
//     super.initState();
//     pickedDate = DateTime.now();
//     pickedTime = TimeOfDay.now();
//   }

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
//                           if (value!.isEmpty) {
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
//                     InkWell(
//                       onTap: () {
//                         _pickedDate();
//                       },
//                       child: Container(
//                         padding: EdgeInsets.all(10),
//                         height: 90,
//                         width: 380,
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
//                                 '${pickedDate!.day}/${pickedDate!.month}/${pickedDate!.year}',
//                                 style: TextStyle(fontSize: 15)),
//                           ],
//                         ),
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
//                           if (value!.isEmpty || !value.contains('@')) {
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
//                           if (value!.isEmpty || value.length < 10) {
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
//                     Container(
//                       padding: EdgeInsets.all(10),
//                       height: 90,
//                       width: 380,
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
//                           contentPadding: EdgeInsets.all(20),
//                         ),
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Please Enter Address';
//                           }
//                           return null;
//                         },
//                         controller: tempadTf,
//                         onChanged: (value) {
//                           this.tempAd = value;
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
//                         keyboardType: TextInputType.streetAddress,
//                         decoration: InputDecoration(
//                           hintStyle: TextStyle(fontSize: 17),
//                           hintText: 'Perminent Address',
//                           suffixIcon: Icon(Icons.add_road),
//                           //border: InputBorder.none,
//                           contentPadding: EdgeInsets.all(20),
//                         ),
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Please Enter Address';
//                           }
//                           return null;
//                         },
//                         controller: peradTf,
//                         onChanged: (value) {
//                           this.perAd = value;
//                         },
//                       ),
//                     ),
//                     SizedBox(
//                       height: 7,
//                     ),
//                     Container(
//                       padding: EdgeInsets.all(10),
//                       height: 250,
//                       width: 380,
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(15)),
//                       child: Column(
//                         children: [
//                           CheckboxListTile(
//                               title: Text('Telugu'),
//                               value: telugu,
//                               onChanged: (bool? value) {
//                                 setState(
//                                   () {
//                                     telugu = value;
//                                     if (telugu == true) {
//                                       this.lan1 = 'Telugu';
//                                     }
//                                   },
//                                 );
//                                 //Text('Telugu',style: TextStyle(color: Colors.amber),);
//                               }),
//                           CheckboxListTile(
//                               title: Text('English'),
//                               value: english,
//                               onChanged: (bool? value) {
//                                 setState(
//                                   () {
//                                     english = value;
//                                     if (english == true) {
//                                       this.lan2 = 'English';
//                                     }
//                                   },
//                                 );
//                                 //Text('Telugu',style: TextStyle(color: Colors.amber),);
//                               }),
//                           CheckboxListTile(
//                               title: Text('Hindi'),
//                               value: hindi,
//                               onChanged: (bool? value) {
//                                 setState(
//                                   () {
//                                     hindi = value;
//                                     if (hindi == true) {
//                                       this.lan3 = 'Hindi';
//                                     }
//                                   },
//                                 );
//                                 //Text('Telugu',style: TextStyle(color: Colors.amber),);
//                               }),
//                           TextFormField(
//                             keyboardType: TextInputType.name,
//                             decoration: InputDecoration(
//                               hintStyle: TextStyle(fontSize: 17),
//                               hintText: 'others',
//                               suffixIcon: Icon(Icons.add_road),
//                               //border: InputBorder.none,
//                               contentPadding: EdgeInsets.all(20),
//                               //     validator: (value) {
//                               // if (value.isEmpty || value.length < 10) {
//                               //   return 'Please Enter Valid Mobile Number';
//                               // }
//                               // return null;
//                             ),
//                             onChanged: (value) {
//                               this.otherlan = value;
//                             },
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
//                       width: 380,
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
//                             value: dropDownValue,

//                             hint:
//                                 //'$dropDownValue'==null?Text('select your job'):
//                                 Text(
//                               '$dropDownValue',
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
//                               print(dropDownValue);
//                               setState(() {
//                                 dropDownValue = newVal as int;
//                               });
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
//                       width: 380,
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
//                           contentPadding: EdgeInsets.all(20),
//                         ),
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Please Enter Business Name';
//                           }
//                           return null;
//                         },
//                         controller: businessNameTf,
//                         onChanged: (value) {
//                           this.businessName = value;
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
//                           hintText: 'Experience',
//                           suffixIcon: Icon(Icons.add_road),
//                           //border: InputBorder.none,
//                           contentPadding: EdgeInsets.all(20),
//                         ),
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Please Enter Years of Experience';
//                           }
//                           return null;
//                         },
//                         controller: experienceTf,
//                         onChanged: (value) {
//                           this.experience = value;
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
//                         if (_formkey.currentState!.validate()) {
//                           Navigator.pushAndRemoveUntil(
//                               context,
//                               MaterialPageRoute(builder: (_) => Location()),
//                               (route) => false);
//                         }
//                         //print(now);

//                         Map<String, dynamic> postData = {
//                           'name': this.name,
//                           'dob':
//                               '${pickedDate!.day}/${pickedDate!.month}/${pickedDate!.year}',
//                           'perAd': this.perAd,
//                           'altnum': this.number,
//                           'email': this.email,
//                           'tempAd': this.tempAd,
//                           'job': this.dropDownValue,
//                           'partnerid': FirebaseAuth.instance.currentUser!.uid,
//                           'lan': ({
//                             'lan1': lan1,
//                             'lan2': lan2,
//                             'lan3': lan3,
//                             'others': otherlan
//                           }),
//                           'businessname': businessName,
//                           'experience': experience,
//                         };
//                         adPost!.addData(postData).then((result) {
//                           // dialogTrrigger(context);
//                         }).catchError((e) {
//                           print(e);
//                         });
//                       }),
//                 ],
//               )
//             ],
//           ),
//         ]),
//       ),
//     );
//   }

//   _pickedDate() async {
//     DateTime? date = await showDatePicker(
//         context: context,
//         initialDate: pickedDate!,
//         firstDate: DateTime(DateTime.now().year - 80),
//         lastDate: DateTime(
//           DateTime.now().year + 0,
//           DateTime.now().month + 0,
//           DateTime.now().day + 0,
//         ));
//     if (date != null) {
//       setState(() {
//         pickedDate = date;
//       });
//     }
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
//           .collection('partner')
//           .doc(FirebaseAuth.instance.currentUser!.uid)
//           .update(postData)
//           .catchError((e) {
//         print(e);
//       });
//     } else {
//       print('You need to login');
//     }
//   }
// }
