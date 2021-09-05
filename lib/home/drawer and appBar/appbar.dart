import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';
import 'package:spotmies_partner/apiCalls/apiCalling.dart';
import 'package:spotmies_partner/apiCalls/apiInterMediaCalls/partnerDetailsAPI.dart';
import 'package:spotmies_partner/apiCalls/apiUrl.dart';
import 'package:spotmies_partner/home/drawer%20and%20appBar/drawer.dart';
import 'package:spotmies_partner/home/offline.dart';
import 'package:spotmies_partner/home/online.dart';
import 'package:spotmies_partner/internet_calling/calling.dart';
import 'package:spotmies_partner/localDB/localGet.dart';
import 'package:spotmies_partner/reusable_widgets/progressIndicator.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';

class AppBarScreen extends StatefulWidget {
  final drawerController;
  AppBarScreen(
    this.drawerController,
  );

  @override
  _AppBarScreenState createState() => _AppBarScreenState();
}

class _AppBarScreenState extends State<AppBarScreen> {
  // final drawerController = ZoomDrawerController();
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    final _hight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;
    return FutureBuilder(
        future: localPartnerDetailsGet(),
        builder: (context, snapshot) {
          var pr = snapshot.data;
          if (pr == null) {
            return circleProgress();
          }
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.grey[100],
              leading: InkWell(
                onTap: (){
                 widget.drawerController.toggle();
                },
                child:  Icon(
                    Icons.menu,
                    color: Colors.grey[900],
                  ),),
              title: TextWid(
                text: pr['name'] == null
                    ? 'User'
                    : toBeginningOfSentenceCase(pr['name']),
                color: Colors.grey[900],
                size: _width * 0.045,
                weight: FontWeight.w600,
              ),
              actions: [
                Container(
                  padding: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 2,
                            spreadRadius: 2,
                            color: Colors.grey[100]),
                      ]),
                  child: FlutterSwitch(
                      activeColor: Colors.grey[200],
                      activeIcon: Icon(
                        Icons.done,
                        color: Colors.white,
                      ),
                      inactiveIcon: Icon(
                        Icons.work_off,
                        color: Colors.white,
                      ),
                      inactiveColor: Colors.grey[200],
                      activeToggleColor: Colors.greenAccent[700],
                      inactiveToggleColor: Colors.redAccent[700],
                      activeText: 'Online',
                      activeTextColor: Colors.grey[900],
                      inactiveTextColor: Colors.grey[900],
                      inactiveText: 'Offline',
                      width: _width * 0.2,
                      height: _hight * 0.04,
                      valueFontSize: _width * 0.03,
                      toggleSize: _width * 0.05,
                      borderRadius: 30.0,
                      padding: 5.0,
                      showOnOff: true,
                      value: isSwitched,
                      onToggle: (value) {
                        setState(() {
                          isSwitched = !isSwitched;
                        });
                        // var body = {
                        //   "availability": value.toString(),
                        // };
                        // setState(() {
                        //   var res= Server().editMethod(API.partnerStatus, body);
                        //   log(res.toString());
                        // });
                      //  var response = Server().editMethod(API.partnerStatus, body);
                      //  log(response.toString());
                      //   partner.updateLocal(value);
                      //   partner.partnerDetails();
                      }),
                ),
              ],
            ),
            body: Container(
              child: isSwitched == true ? Online(pr) : Offline(pr),
            ),
          );
        });
  }
}






 // Container(
                //   margin: EdgeInsets.only(left: 10, right: 10),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Row(
                //         children: [
                        
                //           Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Text(
                //                   pr['name'] == null
                //                       ? 'User'
                //                       : toBeginningOfSentenceCase(pr['name']),
                //                   style: GoogleFonts.josefinSans(
                //                     color: Colors.grey[900],
                //                     fontSize: _width * 0.045,
                //                     fontWeight: FontWeight.w600,
                //                   )),
                //             ],
                //           ),
                //         ],
                //       ),
                     
                //     ],
                //   ),
                // ),