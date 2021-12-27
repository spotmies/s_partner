import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';

import 'package:spotmies_partner/controllers/login_controller.dart';

import 'package:spotmies_partner/providers/partnerDetailsProvider.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends StateMVC<SplashScreen> {
  LoginPageController thisController;

  _SplashScreenState() : super(LoginPageController()) {
    this.thisController = controller;
  }
  PartnerDetailsProvider partnerProvider;

  @override
  void initState() {
    super.initState();
    partnerProvider =
        Provider.of<PartnerDetailsProvider>(context, listen: false);
    Timer(Duration(milliseconds: 100), () {
      partnerProvider.getConstants(alwaysHit: false);
      partnerProvider.fetchServiceList(alwaysHit: false);
      thisController.splashScreenNavigation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final _hight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
        key: thisController.scaffoldkey,
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SizedBox(
              //   height: _hight * 0.1,
              // ),
              Container(
                  height: _hight * 0.23,
                  // width: 150,
                  child: Lottie.asset('assets/spotmies_logo.json')),
              SizedBox(
                height: _hight * 0.15,
              ),
              Column(
                children: [
                  TextWid(
                      text: 'SPOTMIES PARTNER',
                      size: _width * 0.06,
                      color: Colors.indigo[900],
                      flow: TextOverflow.visible,
                      lSpace: 3.0,
                      weight: FontWeight.w600),
                  TextWid(
                      text: 'BECOME A BOSE TO YOUR WORLD',
                      weight: FontWeight.w600,
                      size: _width * 0.02,
                      color: Colors.grey[900],
                      lSpace: 5.0),
                  // SizedBox(
                  //   height: _hight * 0.15,
                  // ),
                  // CircularProgressIndicator()
                ],
              ),
            ],
          ),
        ));
  }
}

//Second Splash Screen

// class SplashScreen2 extends StatefulWidget {
//   @override
//   _SplashScreen2State createState() => _SplashScreen2State();
// }

// class _SplashScreen2State extends State<SplashScreen2> {
//   var path = FirebaseFirestore.instance
//       .collection('partner')
//       .doc(FirebaseAuth.instance.currentUser.uid)
//       .get();
//   @override
//   void initState() {
//     super.initState();

//     Timer(Duration(seconds: 4), () {
//       (path == null)
//           ? Navigator.pushAndRemoveUntil(context,
//               MaterialPageRoute(builder: (_) => Terms()), (route) => false)
//           : Navigator.pushAndRemoveUntil(context,
//               MaterialPageRoute(builder: (_) => Terms()), (route) => false);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final _hight = MediaQuery.of(context).size.height -
//         MediaQuery.of(context).padding.top -
//         kToolbarHeight;
//     final _width = MediaQuery.of(context).size.width;
//     return Scaffold(
//         backgroundColor: Colors.white,
//         body: Column(
//           children: [
//             Container(
//               height: _hight * 0.85,
//               width: _width * 1,
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     CircleAvatar(
//                       backgroundColor: Colors.blue[900],
//                       radius: 50,
//                       child: Center(
//                           child: Icon(
//                         Icons.location_on,
//                         color: Colors.white,
//                         size: 40,
//                       )),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           'Spot',
//                           style: TextStyle(
//                               fontSize: 30,
//                               color: Colors.blue[900],
//                               fontWeight: FontWeight.bold),
//                         ),
//                         Text(
//                           'mies',
//                           style: TextStyle(
//                               fontSize: 30,
//                               color: Colors.orange,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Container(
//               height: _hight * 0.15,
//               width: _width * 1,
//               child: Column(
//                 children: [
//                   CircularProgressIndicator(),
//                   SizedBox(
//                     height: _hight * 0.02,
//                   ),
//                   Text('Please wait fetching data'),
//                 ],
//               ),
//             )
//           ],
//         ));
//   }
// }
