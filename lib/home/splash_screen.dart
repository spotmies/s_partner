import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spotmies_partner/home/home.dart';
import 'package:spotmies_partner/login/login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    
    super.initState();
    
    Timer(Duration(seconds: 5), () {
      if (FirebaseAuth.instance.currentUser != null) {
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (_) => Home()), (route) => false);
    } else {
        Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (_) => LoginScreen()), (route) => false);
    }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RichText(
            text: TextSpan(
                text: 'spot',
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
              TextSpan(
                  text: 'mies',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue[900])),
              //TextSpan(text: ' world!')
            ])),
      ),
    );
  }
}
