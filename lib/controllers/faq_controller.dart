// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:mvc_pattern/mvc_pattern.dart';
// import 'package:spotmies_partner/apiCalls/apiCalling.dart';
// import 'package:spotmies_partner/apiCalls/apiUrl.dart';
// import 'package:spotmies_partner/utilities/snackbar.dart';

// class FAQController extends ControllerMVC {
//   // bool loader = false;

//   submitQuery(subject, pDID) async {
//     // log('$subject');
//     // loader = true;
//     // var body = {
//     //   "subject": subject.toString(),
//     //   "suggestionFor": "faq",
//     //   "suggestionFrom": "partnerApp",
//     //   "uId": API.pid.toString(),
//     //   "uDetails": pDID.toString(),
//     // };
//     log(pDID.toString());
//     // var response = await Server().postMethod(API.suggestions, body);
//     // // print("36 $responseponse");
//     // if (response.statusCode == 200 || response.statusCode == 204) {
//     //   log(response.body.toString());
//     //   snackbar(context, 'Done');
//     //   Navigator.pop(context);
//     //   // loader = false;
//     //   // refresh();
//     // } else if (response.statusCode == 404) {
//     //   log(response.body.toString());
//     //   snackbar(context, 'Something went wrong');
//     //   // loader = false;
//     //   // refresh();
//     // } else {
//     //   log(response.body.toString());
//     //   snackbar(context, 'server error');
//     //   // loader = false;
//     //   // refresh();
//     // }
//   }
// }
