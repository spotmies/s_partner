import 'dart:async';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:spotmies_partner/controllers/login_controller.dart';
import 'package:spotmies_partner/home/navBar.dart';
import 'package:spotmies_partner/login/onboard.dart';
import 'package:spotmies_partner/providers/partnerDetailsProvider.dart';
import 'package:spotmies_partner/utilities/snackbar.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
   PartnerDetailsProvider partnerProvider;
  @override
  void initState() {
    super.initState();
    partnerProvider =
        Provider.of<PartnerDetailsProvider>(context, listen: false);
    Timer(Duration(seconds: 1), () async {
      if (FirebaseAuth.instance.currentUser != null) {
        String resp =
            await checkPartnerRegistered(FirebaseAuth.instance.currentUser.uid);
        if (resp == "true") {
          partnerProvider.setCurrentPid(FirebaseAuth.instance.currentUser.uid);
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (_) => NavBar()), (route) => false);
        } else if (resp == "false") {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => OnboardingScreen()),
              (route) => false);
        } else
          snackbar(context, "something went wrong");

        // var doc = FirebaseFirestore.instance
        //     .collection('partner')
        //     .doc(FirebaseAuth.instance.currentUser.uid);
        // doc.get().then((document) {
        //   if (document.exists) {
        //     print("doc exits");
        //     Navigator.pushAndRemoveUntil(context,
        //         MaterialPageRoute(builder: (_) => NavBar()), (route) => false);
        //   } else if (!document.exists) {
        //     print("doc not exits");
        //     Navigator.pushAndRemoveUntil(
        //         context,
        //         MaterialPageRoute(builder: (_) => OnboardingScreen()),
        //         (route) => false);
        //   }
        //   print("doc is $document");
        // });

      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => OnboardingScreen()),
            (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _hight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                  child: Container(
                      height: _hight * 0.35,
                      width: _width * 0.30,
                      child: Image.asset("assets/spotmies.png"))),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Spotmies ',
                    style: TextStyle(
                        fontSize: _width * 0.09,
                        color: Colors.blue[900],
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Partner',
                    style: TextStyle(
                        fontSize: _width * 0.09,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text('Experience the Exellence')
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
