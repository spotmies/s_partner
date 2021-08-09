import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spotmies_partner/home/offlinePage/lineGraph.dart';
import 'package:spotmies_partner/home/offlinePage/multibarGraph.dart';

graphIndicator(
    double hight, double width, Color color, String title, IconData icon) {
  return Container(
    height: hight,
    width: width,
    decoration:
        BoxDecoration(color: color, borderRadius: BorderRadius.circular(30)),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.only(left: 15, top: 15),
              child: Text('$title',
                  style: GoogleFonts.josefinSans(
                      fontSize: width * 0.11,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
            ),
            Container(
                padding: EdgeInsets.only(right: 15, top: 15),
                child: Icon(
                  icon,
                  color: Colors.white,
                ))
          ],
        ),
        Column(
          children: [
            Text('24',
                style: GoogleFonts.josefinSans(
                    fontSize: width * 0.25,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
            Text('Completed',
                style: GoogleFonts.josefinSans(
                    fontSize: width * 0.065,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
          ],
        ),
        Container(
          // padding: EdgeInsets.only(bottom: 1),
          height: hight * 0.55,
          width: width,
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.all(7),
                  height: hight * 0.4,
                  width: width,
                  child: title == 'Orders' ? multiBarGraph() : lineGraph()),
              if (title == 'Orders')
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: width * 0.03,
                          backgroundColor: Colors.white,
                        ),
                        SizedBox(
                          width: width * 0.01,
                        ),
                        Text('Recieved',
                            style: GoogleFonts.josefinSans(
                                fontSize: width * 0.05,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                      ],
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: width * 0.03,
                          backgroundColor: Colors.green,
                        ),
                        SizedBox(
                          width: width * 0.01,
                        ),
                        Text('Completed',
                            style: GoogleFonts.josefinSans(
                                fontSize: width * 0.05,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                      ],
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: width * 0.03,
                          backgroundColor: Colors.red[400],
                        ),
                        SizedBox(
                          width: width * 0.01,
                        ),
                        Text('Cancelled',
                            style: GoogleFonts.josefinSans(
                                fontSize: width * 0.05,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                      ],
                    )
                  ],
                ),
              Container(
                padding: EdgeInsets.only(top: 5),
                child: Text(
                    title == 'Orders' ? 'Last Five Months' : 'Total References',
                    style: GoogleFonts.josefinSans(
                        fontSize: width * 0.11,
                        fontWeight: FontWeight.w500,
                        color: Colors.white)),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
