import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';
import 'package:spotmies_partner/apiCalls/apiCalling.dart';
import 'package:spotmies_partner/apiCalls/apiUrl.dart';
import 'package:spotmies_partner/controllers/drawerAndAppbar_controller.dart';
import 'package:spotmies_partner/home/offline.dart';
import 'package:spotmies_partner/home/online.dart';
import 'package:spotmies_partner/providers/partnerDetailsProvider.dart';
import 'package:spotmies_partner/providers/theme_provider.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';
import 'package:spotmies_partner/utilities/snackbar.dart';

import '../navBar.dart';

class AppBarScreen extends StatefulWidget {
  final drawerController;
  AppBarScreen(
    this.drawerController,
  );

  @override
  _AppBarScreenState createState() => _AppBarScreenState();
}

class _AppBarScreenState extends StateMVC<AppBarScreen> {
  DrawerandAppBarController? _appBarController = DrawerandAppBarController();
  // _AppBarScreenState() : super(DrawerandAppBarController()) {
  //   this._appBarController = controller;
  // }
  PartnerDetailsProvider? partnerDetailsProvider;
  dynamic pd;

  updatePartnerData(body) async {
    var response = await Server().editMethod(API.partnerStatus + pId, body);
    if (response.statusCode == 200) {
      Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      partnerDetailsProvider!.setPartnerDetailsOnly(data);
    } else {
      partnerDetailsProvider!.setAvailability(!pd['availability']);
    }
    partnerDetailsProvider!.setOffileLoader(false);
  }

  @override
  void initState() {
    partnerDetailsProvider =
        Provider.of<PartnerDetailsProvider>(context, listen: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _hight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;

    return Consumer<ThemeProvider>(builder: (context, data, child) {
      return Consumer<PartnerDetailsProvider>(builder: (context, data, child) {
        pd = data.getProfileDetails.isEmpty
            ? {'name': 'Fetching...', 'availability': false}
            : data.getProfileDetails;
        return Scaffold(
          key: _appBarController?.drawerAppbarScoffoldKey,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: SpotmiesTheme.onSurface,
            leading: InkWell(
              onTap: () {
                widget.drawerController.toggle();
              },
              child: Icon(
                Icons.menu,
                color: SpotmiesTheme.secondaryVariant,
              ),
            ),
            title: TextWid(
              text: pd['name'] == 'Fetching...'
                  ? 'User'
                  : toBeginningOfSentenceCase(pd['name']).toString(),
              color: SpotmiesTheme.secondaryVariant,
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
                          color: SpotmiesTheme.onSurface),
                    ]),
                child: FlutterSwitch(
                    activeColor: SpotmiesTheme.surfaceVariant2,
                    activeIcon: Icon(
                      Icons.done,
                      color: SpotmiesTheme.background,
                    ),
                    inactiveIcon: Icon(
                      Icons.work_off,
                      color: SpotmiesTheme.background,
                    ),
                    inactiveColor: SpotmiesTheme.surfaceVariant2,
                    activeToggleColor: Colors.greenAccent[700],
                    inactiveToggleColor: Colors.redAccent[700],
                    activeText: 'Online',
                    activeTextColor: SpotmiesTheme.secondaryVariant,
                    inactiveTextColor: SpotmiesTheme.secondaryVariant,
                    inactiveText: 'Offline',
                    width: _width * 0.2,
                    height: _hight * 0.04,
                    valueFontSize: _width * 0.03,
                    toggleSize: _width * 0.05,
                    borderRadius: 30.0,
                    padding: 5.0,
                    showOnOff: true,
                    value: pd['availability'],
                    onToggle: (value) {
                      //  displayAwesomeNotification(context);
                      if (value && pd['permission'] < 10) {
                        return snackbar(context,
                            "Your account In verfication please Try again later");
                      }
                      if (data.offlineScreenLoader) return;
                      data.setOffileLoader(true);
                      data.setAvailability(value);

                      Map<String, String> body = {
                        "availability": value.toString(),
                      };
                      updatePartnerData(body);
                    }),
              ),
            ],
          ),
          body: GestureDetector(
            onPanUpdate: (details) {
              //   Swiping in right direction.
              if (details.delta.dx > 0) {
                // print("right");
                widget.drawerController.open();
              } else if (details.delta.dx < 0) {
                // print("left");
                widget.drawerController.close();
              }
            },
            child: Container(
              child: pd['availability'] == true ? Online(pd) : Offline(),
            ),
          ),
        );
      });
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