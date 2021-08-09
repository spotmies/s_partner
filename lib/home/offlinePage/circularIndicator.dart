import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

circularIndicator(double hight, double width, Color color, String title,
    IconData icon, int value) {
  return Container(
    height: hight,
    width: width,
    decoration:
        BoxDecoration(color: color, borderRadius: BorderRadius.circular(30)),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.only(left: 15, top: 15),
              child: Text(
                '$title',
                style: GoogleFonts.josefinSans(
                  fontSize: width * 0.11,
                  fontWeight:  FontWeight.w500,
                  color: Colors.white
                )
                
              ),
            ),
            Container(
                padding: EdgeInsets.only(right: 15, top: 15),
                child: Icon(
                  icon,
                  color: Colors.white,
                ))
          ],
        ),
        SizedBox(
          height: hight * 0.2,
        ),
        Container(
          child: CircularPercentIndicator(
              radius: width * 0.7,
              lineWidth: 5,
              animation: true,
              animationDuration: 500,
              progressColor: Colors.white,
              percent: value / 100,
              backgroundColor: color,
              center: Text(
                '$value',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Colors.white),
              )),
        ),
      ],
    ),
  );
}