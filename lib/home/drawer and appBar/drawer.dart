import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';
import 'package:spotmies_partner/controllers/drawerAndAppbar_controller.dart';
import 'package:spotmies_partner/home/drawer%20and%20appBar/configuration.dart';
import 'package:spotmies_partner/home/drawer%20and%20appBar/editDetailsBS.dart';
import 'package:spotmies_partner/home/drawer%20and%20appBar/help&supportBS.dart';
import 'package:spotmies_partner/home/drawer%20and%20appBar/inviteBS.dart';
import 'package:spotmies_partner/home/drawer%20and%20appBar/serviceHistoryBS.dart';
import 'package:spotmies_partner/home/drawer%20and%20appBar/settingsBS.dart';
import 'package:spotmies_partner/home/drawer%20and%20appBar/signoutBS.dart';
import 'package:spotmies_partner/profile/profile.dart';
import 'package:spotmies_partner/providers/partnerDetailsProvider.dart';
import 'package:spotmies_partner/reusable_widgets/profile_pic.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';
import 'package:spotmies_partner/utilities/constants.dart';

class DrawerScreen extends StatefulWidget {
  final drawerController;
  DrawerScreen(this.drawerController);

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends StateMVC<DrawerScreen> {
  DrawerandAppBarController _drawerController;
  _DrawerScreenState() : super(DrawerandAppBarController()) {
    this._drawerController = controller;
  }

  PartnerDetailsProvider partnerDetailsProvider;
  var isLoading = false;

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
    return Consumer<PartnerDetailsProvider>(builder: (context, data, child) {
      var pd = data.getProfileDetails;
      if (pd == null) {
        return Center(child: CircularProgressIndicator());
      }
      // log(pr.toString());
      return Container(
        color: primaryGreen,
        padding: EdgeInsets.only(top: 60, bottom: 30, left: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                ProfilePic(
                  badge: false,
                  profile: pd['partnerPic'],
                  name: pd['name'],
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWid(
                      text: toBeginningOfSentenceCase(
                        pd['name'],
                      ),
                      size: _width * 0.045,
                      weight: FontWeight.w600,
                    ),
                    Row(
                      children: [
                        TextWid(
                          text: toBeginningOfSentenceCase(
                            pd['availability'] == false
                                ? 'Inactive Now'
                                : 'Active Now',
                          ),
                          size: _width * 0.03,
                          weight: FontWeight.w500,
                        ),
                        Text('  |  '),
                        TextWid(
                          text: Constants.jobCategories[pd['job']],
                          size: _width * 0.03,
                          weight: FontWeight.w500,
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: _hight * 0.05,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: drawerItems
                    .map((element) => Container(
                          child: InkWell(
                            onTap: () {
                              widget.drawerController.toggle();
                              drawerItemsFunction(
                                  element['title'],
                                  context,
                                  _hight,
                                  _width,
                                  pd,
                                  partnerDetailsProvider,
                                  _drawerController);
                              log(element['title']);
                            },
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    element['icon'],
                                    color: Colors.grey[900],
                                    size: _width * 0.05,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(element['title'],
                                    style: GoogleFonts.josefinSans(
                                      color: Colors.grey[900],
                                      fontSize: _width * 0.045,
                                      fontWeight: FontWeight.w600,
                                    ))
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      );
    });
  }
}

drawerItemsFunction(
    element,
    BuildContext context,
    double hight,
    double width,
    pr,
    PartnerDetailsProvider partnerDetailsProvider,
    DrawerandAppBarController drawerController) {
  switch (element) {
    case 'Sign Out':
      return signOut(context, hight, width);
      break;
    case 'Settings':
      return settings(context, hight, width);
      break;
    case 'Edit Details':
      // return editDetails(context, hight, width, pr,partnerDetailsProvider,drawerController);
      return Navigator.push(
          context, MaterialPageRoute(builder: (_) => EditProfile(pr)));
      break;
    case 'Service History':
      return history(context, hight, width);
      break;
    case 'Help & Support':
      return helpAndSupport(context, hight, width);
      break;
    case 'Privacy Policies':
      return Navigator.push(
          context, MaterialPageRoute(builder: (_) => PrivacyPolicyWebView()));
      break;
    case 'Invite':
      return invites(context, hight, width, pr);
      break;
    default:
      return '';
  }
}






// import 'package:flutter_switch/flutter_switch.dart';
// import 'package:spotmies_partner/apiCalls/apiCalling.dart';
// import 'package:spotmies_partner/apiCalls/apiInterMediaCalls/partnerDetailsAPI.dart';
// import 'package:spotmies_partner/apiCalls/apiUrl.dart';
// import 'package:spotmies_partner/home/offline.dart';
// import 'package:spotmies_partner/home/online.dart';
// import 'package:spotmies_partner/localDB/localGet.dart';

// TextEditingController isSwitched = TextEditingController();

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   bool isSwitched = false;
//   // var partner;

//   // @override
//   // void initState() {
//   //   // partner = Provider.of<PartnerDetailsProvider>(context, listen: false);
//   //   // partner.partnerDetails();
//   //   super.initState();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: localPartnerDetailsGet(),
//         builder: (context, snapshot) {
//           var pr = snapshot.data;
//           if (pr == null) {
//             partnerDetail();
//           }
//           if (pr == null) {
//             return Center(child: CircularProgressIndicator());
//           }
//           bool isSwitch = pr['availability'];

//           isSwitched = isSwitch;

//           return Scaffold(
//               drawer: Drawer(
//                 child: ListView(
//                   padding: EdgeInsets.zero,
//                   children: <Widget>[
//                     createHeader(),
//                     createDrawerItem(
//                         icon: Icons.contacts,
//                         text: 'Contacts',
//                         onTap: () {
//                           log('Contact');
//                           Navigator.pop(context);
//                         }),
//                     createDrawerItem(
//                       icon: Icons.event,
//                       text: 'Events',
//                     ),
//                     createDrawerItem(
//                       icon: Icons.note,
//                       text: 'Notes',
//                     ),
//                     Divider(),
//                     createDrawerItem(
//                         icon: Icons.collections_bookmark, text: 'Steps'),
//                     createDrawerItem(icon: Icons.face, text: 'Authors'),
//                     createDrawerItem(
//                         icon: Icons.account_box, text: 'Flutter Documentation'),
//                     createDrawerItem(icon: Icons.stars, text: 'Useful Links'),
//                     Divider(),
//                     createDrawerItem(
//                         icon: Icons.bug_report, text: 'Report an issue'),
//                     ListTile(
//                       title: Text('0.0.1'),
//                       onTap: () {},
//                     ),
//                   ],
//                 ),
//               ),
//               appBar: AppBar(
//                 backgroundColor: Colors.blue[900],
//                 title: Container(
//                     padding: EdgeInsets.only(top: 2),
//                     child: Align(
//                         alignment: Alignment.center,
//                         child: Text(pr['name'] == null ? 'User' : pr['name']))),
//                 actions: [
//                   Container(
//                       child: Transform.scale(
//                     scale: 0.8,
//                     child: Container(
//                       child: Row(
//                         children: [
//                           FlutterSwitch(
//                               activeColor: Colors.blue[900],
//                               activeIcon: Icon(Icons.done),
//                               inactiveIcon: Icon(Icons.gps_off_outlined),
//                               inactiveColor: Colors.blue[900],
//                               activeToggleColor: Colors.greenAccent[700],
//                               inactiveToggleColor: Colors.redAccent[700],
//                               activeText: 'Online',
//                               inactiveText: 'Offline',
//                               width: 130.0,
//                               height: 40.0,
//                               valueFontSize: 25.0,
//                               toggleSize: 45.0,
//                               borderRadius: 30.0,
//                               padding: 5.0,
//                               showOnOff: true,
//                               value: isSwitched,
//                               onToggle: (value) {
//                                 var body = {
//                                   "availability": value.toString(),
//                                 };
//                                 setState(() {
//                                   Server().editMethod(API.partnerStatus, body);
//                                 });
//                                 // Server().editMethod(API.partnerStatus, body);
//                                 // partner.updateLocal(value);
//                                 partner.partnerDetails();
//                               }),
//                         ],
//                       ),
//                     ),
//                   ))
//                 ],
//               ),
//               body: isSwitch ? Online() : Offline()
//               //
//               );
//         });
//   }
// }

// Widget createHeader() {
//   return DrawerHeader(
//       margin: EdgeInsets.zero,
//       padding: EdgeInsets.zero,
//       decoration: BoxDecoration(color: Colors.black),
//       child: Stack(children: <Widget>[
//         Positioned(
//             bottom: 12.0,
//             left: 16.0,
//             child: Text("Flutter Step-by-Step",
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 20.0,
//                     fontWeight: FontWeight.w500))),
//       ]));
// }

// Widget createDrawerItem(
//     {IconData icon, String text, GestureTapCallback onTap}) {
//   return ListTile(
//     title: Row(
//       children: <Widget>[
//         Icon(icon),
//         Padding(
//           padding: EdgeInsets.only(left: 8.0),
//           child: Text(text),
//         )
//       ],
//     ),
//     onTap: onTap,
//   );
// }