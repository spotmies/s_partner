import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';

graphIndicator(
    double hight, double width, Color color, String title, IconData icon, pdo) {
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextWid(
              text: title == 'Orders'
                  ? pdo.length.toString()
                  : "₹ ${pdo.toString()}",
              weight: FontWeight.w600,
              size: width * 0.25,
              color: Colors.white,
            ),
            TextWid(
                text: title == 'Orders' ? 'Completed' : 'Rupees',
                size: width * 0.065,
                weight: FontWeight.w600,
                color: Colors.white),
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
                // child: title == 'Orders' ? multiBarGraph() : lineGraph()),
                // child: lineGraph()
                child: Icon(icon,
                    size: width * 0.5,
                    color: title == 'Orders'
                        ? Colors.amber[300]
                        : Colors.red[300]),
              ),
              Container(
                padding: EdgeInsets.only(top: 5),
                child: Text(
                    title == 'Orders' ? 'Total Orders' : 'Total Earnings',
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



// if (title == 'Orders')
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Row(
//                       children: [
//                         CircleAvatar(
//                           radius: width * 0.03,
//                           backgroundColor: Colors.white,
//                         ),
//                         SizedBox(
//                           width: width * 0.01,
//                         ),
//                         Text('Recieved',
//                             style: GoogleFonts.josefinSans(
//                                 fontSize: width * 0.05,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.white)),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         CircleAvatar(
//                           radius: width * 0.03,
//                           backgroundColor: Colors.green,
//                         ),
//                         SizedBox(
//                           width: width * 0.01,
//                         ),
//                         Text('Completed',
//                             style: GoogleFonts.josefinSans(
//                                 fontSize: width * 0.05,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.white)),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         CircleAvatar(
//                           radius: width * 0.03,
//                           backgroundColor: Colors.red[400],
//                         ),
//                         SizedBox(
//                           width: width * 0.01,
//                         ),
//                         Text('Cancelled',
//                             style: GoogleFonts.josefinSans(
//                                 fontSize: width * 0.05,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.white)),
//                       ],
//                     )
//                   ],
//                 ),
