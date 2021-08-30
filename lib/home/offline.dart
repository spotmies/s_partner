import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spotmies_partner/home/offlinePage/circularIndicator.dart';
import 'package:spotmies_partner/home/offlinePage/graphIndicator.dart';
import 'package:spotmies_partner/home/offlinePage/lineGraphBig.dart';
import 'package:spotmies_partner/home/offlinePage/singleBarGraph.dart';
import 'package:spotmies_partner/localDB/localGet.dart';

class Offline extends StatefulWidget {
  @override
  _OfflineState createState() => _OfflineState();
}

class _OfflineState extends State<Offline> {
  @override
  Widget build(BuildContext context) {
    final _hight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: FutureBuilder(
          future: localPartnerDetailsGet(),
          builder: (context, localPartner) {
            var p = localPartner.data;
            return Center(
                child: Container(
              height: _hight,
              width: _width,
              decoration: BoxDecoration(color: Colors.grey[200]),
              child: ListView(children: [
                Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          circularIndicator(_hight * 0.35, _width * 0.44,
                              Colors.blue[900], 'Rating', Icons.reviews, 69),
                          SizedBox(
                            height: _hight * 0.02,
                          ),
                          graphIndicator(
                            _hight * 0.45,
                            _width * 0.44,
                            Colors.red[400],
                            'References',
                            Icons.link,
                          )
                        ],
                      ),
                      SizedBox(
                        width: _width * 0.035,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          graphIndicator(
                            _hight * 0.45,
                            _width * 0.44,
                            Colors.amber,
                            'Orders',
                            Icons.all_inbox,
                          ),
                          SizedBox(
                            height: _hight * 0.02,
                          ),
                          circularIndicator(
                              _hight * 0.35,
                              _width * 0.44,
                              Colors.lightBlue[700],
                              'Acceptance',
                              Icons.done_rounded,
                              48),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: _width * 0.05,
                ),
                Container(
                  padding: EdgeInsets.only(top: 15.0, right: 10),
                  margin: EdgeInsets.only(bottom: 15, right: 10, left: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey[300],
                            blurRadius: 5,
                            spreadRadius: 2)
                      ]),
                  child: Column(
                    children: [
                      Text(
                        'Active Time',
                        style: GoogleFonts.josefinSans(
                          color: Colors.grey[900],
                          fontSize: _width * 0.05,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 20.0),
                        child: Text(
                          '(Last Seven Days)',
                          style: GoogleFonts.josefinSans(
                            color: Colors.grey[900],
                            fontSize: _width * 0.03,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        height: _hight * 0.3,
                        width: _width,
                        padding: EdgeInsets.only(left: 0, right: _width * 0.02),
                        child: singleBarChart(_hight, _width),
                      ),
                      SizedBox(
                        height: _width * 0.03,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 15.0, right: 10),
                  margin: EdgeInsets.only(bottom: 15, right: 10, left: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey[300],
                            blurRadius: 5,
                            spreadRadius: 2)
                      ]),
                  child: Column(
                    children: [
                      Text(
                        'Orders Progress',
                        style: GoogleFonts.josefinSans(
                          color: Colors.grey[900],
                          fontSize: _width * 0.05,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 20.0),
                        child: Text(
                          '(Last Seven Days)',
                          style: GoogleFonts.josefinSans(
                            color: Colors.grey[900],
                            fontSize: _width * 0.03,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      indicator(_width),
                      Container(
                        height: _hight * 0.3,
                        width: _width,
                        padding: EdgeInsets.only(left: 0, right: _width * 0.04),
                        child: lineGraphBig(_hight, _width),
                      ),
                      SizedBox(
                        height: _width * 0.03,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: _width * 0.25,
                ),
              ]),
            ));
          }),
    );
  }
}

avg(List<dynamic> args) {
  var sum = 0;
  var avg = args;

  for (var i = 0; i < avg.length; i++) {
    sum += avg[i];
  }

  return sum;
}

indicator(_width) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Row(
        children: [
          CircleAvatar(
            radius: _width * 0.015,
            backgroundColor: Colors.blue[900],
          ),
          SizedBox(
            width: _width * 0.01,
          ),
          Text(
            'Recieved',
            style: GoogleFonts.josefinSans(
              color: Colors.grey[900],
              fontSize: _width * 0.03,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      Row(
        children: [
          CircleAvatar(
            radius: _width * 0.015,
            backgroundColor: Colors.greenAccent,
          ),
          SizedBox(
            width: _width * 0.01,
          ),
          Text(
            'Completed',
            style: GoogleFonts.josefinSans(
              color: Colors.grey[900],
              fontSize: _width * 0.03,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      Row(
        children: [
          CircleAvatar(
            radius: _width * 0.015,
            backgroundColor: Colors.red[400],
          ),
          SizedBox(
            width: _width * 0.01,
          ),
          Text(
            'Cancelled',
            style: GoogleFonts.josefinSans(
              color: Colors.grey[900],
              fontSize: _width * 0.03,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      )
    ],
  );
}

//   Widget progressIndicator(indicatorValue, String field) {
//     final _width = MediaQuery.of(context).size.width;
//     return Column(
//       children: [
//         Container(
//           height: _width * 0.20,
//           width: _width * 0.20,
//           // padding: EdgeInsets.all(30),
//           decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(25),
//               boxShadow: [
//                 new BoxShadow(
//                     color: Colors.grey[200],
//                     blurRadius: 5.0,
//                     spreadRadius: 5.0),
//               ]),
//           child: CircularPercentIndicator(
//             radius: _width * 0.14,
//             lineWidth: 2,
//             animation: true,
//             animationDuration: 1000,
//             percent: avg(indicatorValue) / 100,
//             backgroundColor: Colors.grey[200],
//             progressColor: Colors.amber,
//             circularStrokeCap: CircularStrokeCap.round,
//             center: Text(
//               (field == 'Rating'
//                       ? (avg(indicatorValue) / 20)
//                       : avg(indicatorValue))
//                   .toString(),
//               style: TextStyle(
//                   fontWeight: FontWeight.w500, fontSize: _width * 0.03),
//             ),
//           ),
//         ),
//         Container(
//           padding: EdgeInsets.only(top: _width * 0.015),
//           child: Text(
//             field,
//             style: TextStyle(fontSize: _width * 0.02),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget count(value, String field) {
//     final _width = MediaQuery.of(context).size.width;
//     return Column(
//       children: [
//         Container(
//           height: _width * 0.20,
//           width: _width * 0.20,
//           decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(25),
//               boxShadow: [
//                 new BoxShadow(
//                   color: Colors.grey[200],
//                   blurRadius: 1.0,
//                 ),
//               ]),
//           child: Container(
//             height: _width * 0.09,
//             width: _width * 0.09,
//             child: Stack(
//               children: [
//                 Center(
//                   child: Text((value.length.toString()),
//                       style: TextStyle(
//                         fontSize: _width * 0.07,
//                         fontWeight: FontWeight.w500,
//                       )),
//                 ),
//                 Positioned(
//                   right: _width * 0.05,
//                   top: _width * 0.06,
//                   child: Icon(
//                     field == 'References' ? Icons.link : Icons.done_all,
//                     size: _width * 0.03,
//                     color: Colors.blue[900],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         Container(
//           padding: EdgeInsets.only(top: _width * 0.015),
//           child: Text(
//             field,
//             style: TextStyle(fontSize: _width * 0.02),
//           ),
//         ),
//       ],
//     );
//   }
// }



//  Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       width: double.infinity,
//                       height: _hight * 0.35,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           // progressIndicator(p['rate'], 'Rating'),
//                           // count(p['orders'], 'Completed orders'),
//                           // count(p['ref'], 'References'),
//                           // progressIndicator(p['acceptance'], 'Acceptance'),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
