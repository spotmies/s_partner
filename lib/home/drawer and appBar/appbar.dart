import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:spotmies_partner/apiCalls/apiInterMediaCalls/partnerDetailsAPI.dart';
import 'package:spotmies_partner/home/offline.dart';
import 'package:spotmies_partner/home/online.dart';
import 'package:spotmies_partner/localDB/localGet.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;

  bool isDrawerOpen = false;
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
            partnerDetail();
          }
          if (pr == null) {
            return Center(child: CircularProgressIndicator());
          }
          // bool isSwitch = pr['availability'];

          // isSwitched = isSwitch;
          return AnimatedContainer(
            transform: Matrix4.translationValues(xOffset, yOffset, 0)
              ..scale(scaleFactor)
              ..rotateY(isDrawerOpen ? -0.5 : 0),
            duration: Duration(milliseconds: 250),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(isDrawerOpen ? 40 : 0.0)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: _hight * 0.05,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            isDrawerOpen
                                ? IconButton(
                                    icon: Icon(Icons.arrow_back_ios),
                                    onPressed: () {
                                      setState(() {
                                        xOffset = 0;
                                        yOffset = 0;
                                        scaleFactor = 1;
                                        isDrawerOpen = false;
                                      });
                                    },
                                  )
                                : IconButton(
                                    icon: Icon(Icons.menu),
                                    onPressed: () {
                                      setState(() {
                                        xOffset = 230;
                                        yOffset = 150;
                                        scaleFactor = 0.6;
                                        isDrawerOpen = true;
                                      });
                                    }),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    pr['name'] == null
                                        ? 'User'
                                        : toBeginningOfSentenceCase(pr['name']),
                                    style: GoogleFonts.josefinSans(
                                      color: Colors.grey[900],
                                      fontSize: _width * 0.045,
                                      fontWeight: FontWeight.w600,
                                    )),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 2,
                                    spreadRadius: 2,
                                    color: Colors.grey[300]),
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
                              inactiveColor: Colors.grey[50],
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
                                //   Server().editMethod(API.partnerStatus, body);
                                // });
                                // Server().editMethod(API.partnerStatus, body);
                                // partner.updateLocal(value);
                                //partner.partnerDetails();
                              }),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: _hight * 0.923,
                    width: _width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15))),
                    child: isSwitched == true ? Online() : Offline(),
                  )
                ],
              ),
            ),
          );
        });
  }
}
