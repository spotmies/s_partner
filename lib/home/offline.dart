import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotmies_partner/home/drawer%20and%20appBar/catalog_list.dart';
import 'package:spotmies_partner/home/offlinePage/circularIndicator.dart';
import 'package:spotmies_partner/home/offlinePage/graphIndicator.dart';
import 'package:spotmies_partner/home/rating_screen.dart';
import 'package:spotmies_partner/providers/partnerDetailsProvider.dart';
import 'package:spotmies_partner/reusable_widgets/progressIndicator.dart';

class Offline extends StatefulWidget {
  @override
  _OfflineState createState() => _OfflineState();
}

PartnerDetailsProvider partnerDetailsProvider;

class _OfflineState extends State<Offline> {
  @override
  void initState() {
    partnerDetailsProvider =
        Provider.of<PartnerDetailsProvider>(context, listen: false);

    super.initState();
  }

  // var update = true;

  @override
  Widget build(BuildContext context) {
    final _hight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Center(
            child: Container(
      height: _hight,
      width: _width,
      decoration: BoxDecoration(color: Colors.grey[200]),
      child: Consumer<PartnerDetailsProvider>(builder: (context, data, child) {
        var pd = data.getPartnerDetailsFull;
        var dash = data.orders;
        log(pd.toString());

        var cat = pd['catelogs'];

        return ListView(children: [
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 20),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    circularIndicator(
                        _hight * 0.35,
                        _width * 0.44,
                        Colors.blue[900],
                        'Rating',
                        Icons.star_rate,
                        dash.isEmpty ? 100 : avg(dash, 'rate')),
                    SizedBox(
                      height: _hight * 0.02,
                    ),
                    graphIndicator(
                        _hight * 0.45,
                        _width * 0.44,
                        Colors.red[400],
                        'Earnings',
                        Icons.account_balance_wallet,
                        earnSum(dash))
                  ],
                ),
                SizedBox(
                  width: _width * 0.035,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    graphIndicator(_hight * 0.45, _width * 0.44, Colors.amber,
                        'Orders', Icons.work, data.orders),
                    SizedBox(
                      height: _hight * 0.02,
                    ),
                    circularIndicator(
                        _hight * 0.35,
                        _width * 0.44,
                        Colors.lightBlue[700],
                        'Acceptance',
                        Icons.done_rounded,
                        avg(pd['acceptance'], 'acce')),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: _width * 0.05,
          ),
          cat.isEmpty ? Container() : catelogCard(context, cat),
          SizedBox(
            height: _width * 0.02,
          ),
          dash.isEmpty
              ? Container()
              : reviewMsgs(
                  context,
                  dash,
                ),
          SizedBox(
            height: _width * 0.25,
          ),
        ]);
      }),
    )));
  }
}

avg(List<dynamic> args, String type) {
  int sum = 0;
  List avg = args;

  for (var i = 0; i < avg.length; i++) {
    sum += type == 'rate' ? avg[i]['feedBackDetails'] ?? 100 : avg[i] ?? 100;
  }

  // log((sum / avg.length).toString());

  int rate = (sum / avg.length).round();

  return rate;
}

earnSum(
  List<dynamic> args,
) {
  int sum = 0;
  List avg = args;

  // log(args[0]['moneyTakenByPartner'].toString());

  for (var i = 0; i < avg.length; i++) {
    sum += avg[i]['moneyTakenByPartner'] ?? 0;
  }

  return sum;
}










// indicator(_width) {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//     crossAxisAlignment: CrossAxisAlignment.center,
//     children: [
//       Row(
//         children: [
//           CircleAvatar(
//             radius: _width * 0.015,
//             backgroundColor: Colors.blue[900],
//           ),
//           SizedBox(
//             width: _width * 0.01,
//           ),
//           Text(
//             'Recieved',
//             style: GoogleFonts.josefinSans(
//               color: Colors.grey[900],
//               fontSize: _width * 0.03,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//       Row(
//         children: [
//           CircleAvatar(
//             radius: _width * 0.015,
//             backgroundColor: Colors.greenAccent,
//           ),
//           SizedBox(
//             width: _width * 0.01,
//           ),
//           Text(
//             'Completed',
//             style: GoogleFonts.josefinSans(
//               color: Colors.grey[900],
//               fontSize: _width * 0.03,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//       Row(
//         children: [
//           CircleAvatar(
//             radius: _width * 0.015,
//             backgroundColor: Colors.red[400],
//           ),
//           SizedBox(
//             width: _width * 0.01,
//           ),
//           Text(
//             'Cancelled',
//             style: GoogleFonts.josefinSans(
//               color: Colors.grey[900],
//               fontSize: _width * 0.03,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       )
//     ],
//   );
// }




// SizedBox(
          //   height: _width * 0.05,
          // ),
          // Container(
          //   padding: EdgeInsets.only(top: 15.0, right: 10),
          //   margin: EdgeInsets.only(bottom: 15, right: 10, left: 10),
          //   decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.circular(15),
          //       boxShadow: [
          //         BoxShadow(
          //             color: Colors.grey[300], blurRadius: 5, spreadRadius: 2)
          //       ]),
          //   child: Column(
          //     children: [
          //       Text(
          //         'Active Time',
          //         style: GoogleFonts.josefinSans(
          //           color: Colors.grey[900],
          //           fontSize: _width * 0.05,
          //           fontWeight: FontWeight.w600,
          //         ),
          //         textAlign: TextAlign.center,
          //       ),
          //       Container(
          //         padding: EdgeInsets.only(bottom: 20.0),
          //         child: Text(
          //           '(Last Seven Days)',
          //           style: GoogleFonts.josefinSans(
          //             color: Colors.grey[900],
          //             fontSize: _width * 0.03,
          //             fontWeight: FontWeight.w500,
          //           ),
          //           textAlign: TextAlign.center,
          //         ),
          //       ),
          //       Container(
          //         height: _hight * 0.3,
          //         width: _width,
          //         padding: EdgeInsets.only(left: 0, right: _width * 0.02),
          //         child: singleBarChart(_hight, _width),
          //       ),
          //       SizedBox(
          //         height: _width * 0.03,
          //       ),
          //     ],
          //   ),
          // ),
          // Container(
          //   padding: EdgeInsets.only(top: 15.0, right: 10),
          //   margin: EdgeInsets.only(bottom: 15, right: 10, left: 10),
          //   decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.circular(15),
          //       boxShadow: [
          //         BoxShadow(
          //             color: Colors.grey[300], blurRadius: 5, spreadRadius: 2)
          //       ]),
          //   child: Column(
          //     children: [
          //       Text(
          //         'Orders Progress',
          //         style: GoogleFonts.josefinSans(
          //           color: Colors.grey[900],
          //           fontSize: _width * 0.05,
          //           fontWeight: FontWeight.w600,
          //         ),
          //         textAlign: TextAlign.center,
          //       ),
          //       Container(
          //         padding: EdgeInsets.only(bottom: 20.0),
          //         child: Text(
          //           '(Last Seven Days)',
          //           style: GoogleFonts.josefinSans(
          //             color: Colors.grey[900],
          //             fontSize: _width * 0.03,
          //             fontWeight: FontWeight.w500,
          //           ),
          //           textAlign: TextAlign.center,
          //         ),
          //       ),
          //       indicator(_width),
          //       Container(
          //         height: _hight * 0.3,
          //         width: _width,
          //         padding: EdgeInsets.only(left: 0, right: _width * 0.04),
          //         child: lineGraphBig(_hight, _width),
          //       ),
          //       SizedBox(
          //         height: _width * 0.03,
          //       ),
          //     ],
          //   ),
          // ),