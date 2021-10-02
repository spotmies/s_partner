import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';

onPending(double hight, double width) {
  return Scaffold(
      body: Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Container(
        height: hight * 0.3,
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.app_registration,
              size: width * 0.15,
              color: Colors.green[500],
            ),
            SizedBox(
              height: hight * 0.02,
            ),
            TextWid(
              text: 'Do not press back button',
              size: width * 0.05,
              color: Colors.grey[900],
              weight: FontWeight.w600,
            ),
            SizedBox(
              height: hight * 0.005,
            ),
            TextWid(
              text: 'Finalizing your registration process',
              size: width * 0.05,
              color: Colors.grey[900],
              weight: FontWeight.w600,
            ),
          ],
        ),
      ),
      Container(
        height: hight * 0.55,
        width: width,
        child: Lottie.asset('assets/registor.json'),
      ),
      TextWid(
        text: 'Please Wait...',
        size: width * 0.05,
        color: Colors.grey[900],
        weight: FontWeight.w600,
      ),
    ],
  ));
}
