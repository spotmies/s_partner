import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotmies_partner/home/drawer%20and%20appBar/catalog_list.dart';
import 'package:spotmies_partner/home/drawer%20and%20appBar/help&supportBS.dart';
import 'package:spotmies_partner/home/offlinePage/circularIndicator.dart';
import 'package:spotmies_partner/home/offlinePage/graphIndicator.dart';
import 'package:spotmies_partner/home/rating_screen.dart';
import 'package:spotmies_partner/providers/partnerDetailsProvider.dart';
import 'package:spotmies_partner/reusable_widgets/elevatedButtonWidget.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';
import 'package:spotmies_partner/utilities/app_config.dart';

verifyText(value) {
  switch (value) {
    case 0:
      return 'Your business profile successfully sumbitted to spotmies, shortly your profile sent to verification team, till then please keep checking your app';
    case 1:
      return 'your account is under verification. It might take upto 24 to 48 hours, till then please keep checking your app every 6 hours.';
    case 2:
      return 'Your application rejected due to inappropriate profile picture.\nGo to side menu > edit profile > change profile picture';
    case 3:
      return 'Your application rejected due to invalid mail id.\nGo to side menu > edit profile > change Email id';
    case 4:
      return 'Your application rejected due to inappropriate aadhar front image.\nGo to side menu > edit profile > change aadhar front image';
    case 5:
      return 'Your application rejected due to inappropriate aadhar back image.\nGo to side menu > edit profile > change aadhar back image';
    case 6:
      return 'Your application rejected due to invalid alternate mobile number.\nGo to side menu > edit profile > change alternate mobile number';
    case 7:
      return 'Oops';
    case 8:
      return 'Oops';
    case 9:
      return 'Oops';
    case 10:
      return 'Your document verication process completed successfully';
    default:
  }
}

class Offline extends StatefulWidget {
  const Offline({Key? key}) : super(key: key);
  @override
  _OfflineState createState() => _OfflineState();
}

PartnerDetailsProvider? partnerDetailsProvider;

class _OfflineState extends State<Offline> {
  @override
  void initState() {
    partnerDetailsProvider =
        Provider.of<PartnerDetailsProvider>(context, listen: false);
    partnerDetailsProvider?.setCurrentConstants('home');

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
        dynamic alert = data.getText('home_screen_message');
        dynamic pd = data.getPartnerDetailsFull;

        dynamic dash = data.orders;
        log('---------------------------------46------------');
        // log(dash[0].toString());

        var cat = pd['catelogs'];

        return ListView(children: [
          if (pd['permission'] < 10 || alert != 'loading..' || alert != 'null')
            Container(
              height: height(context) * 0.3,
              // width: width(context) * 0.9,
              margin: EdgeInsets.only(left: 15, right: 15, top: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    alert != 'loading..'
                        ? Icons.message
                        : Icons.pending_actions,
                    size: width(context) * 0.07,
                  ),
                  SizedBox(
                    height: height(context) * 0.02,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextWid(
                      text: (alert != 'loading..' && alert != 'null')
                          ? alert.toString()
                          : verifyText(pd['permission']),
                      flow: TextOverflow.visible,
                      size: width(context) * 0.04,
                      align: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: height(context) * 0.02,
                  ),
                  ElevatedButtonWidget(
                    buttonName: 'Need Help',
                    height: height(context) * 0.047,
                    minWidth: width(context) * 0.38,
                    bgColor: Colors.white,
                    textColor: Colors.grey[900]!,
                    allRadius: true,
                    textSize: width(context) * 0.04,
                    trailingIcon: Icon(
                      Icons.help,
                      color: Colors.grey[900],
                      size: width(context) * 0.05,
                    ),
                    borderRadius: 15.0,
                    borderSideColor: Colors.grey[900]!,
                    onClick: () {
                      helpAndSupport(
                          context, height(context), width(context), pd);
                    },
                  ),
                ],
              ),
            ),
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
                        Colors.blue[900]!,
                        'Rating',
                        Icons.star_rate,
                        dash?.isEmpty ? 100 : avg(dash, 'rate')),
                    SizedBox(
                      height: _hight * 0.02,
                    ),
                    graphIndicator(
                        _hight * 0.45,
                        _width * 0.44,
                        Colors.red[400]!,
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
                        Colors.lightBlue[700]!,
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
                  rateFilter(dash!),
                ),
          SizedBox(
            height: _width * 0.25,
          ),
        ]);
      }),
    )));
  }
}

rateFilter(orders) {
  List outputList = orders.where((o) => o['feedBackDetails'] != null).toList();
  return outputList;
}

avg(List<dynamic>? args, String? type) {
  int sum = 0;
  List avg = args!;

  for (var i = 0; i < avg.length; i++) {
    if (type == 'rate') {
      if (avg[i]['feedBackDetails']?['rating'] != null) {
        sum += avg[i]['feedBackDetails']?['rating'] as int;
      } else {
        sum += 100;
      }
    } else {
      if (avg[i] != null) {
        sum += avg[i] as int;
      } else {
        sum += 100;
      }
    }
  }

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
    // sum += avg[i]['moneyTakenByPartner'] ?? 0;
    if (avg[i]['moneyTakenByPartner'] != null) {
      sum += avg[i]['moneyTakenByPartner'] as int;
    } else {
      sum += 0;
    }
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