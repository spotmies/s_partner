import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spotmies_partner/home/drawer%20and%20appBar/appbar.dart';
import 'package:spotmies_partner/home/drawer%20and%20appBar/configuration.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [DrawerScreen(), HomeScreen()],
      ),
    );
  }
}

class DrawerScreen extends StatefulWidget {
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    final _hight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;
    return Container(
      color: primaryGreen,
      padding: EdgeInsets.only(top: 60, bottom: 30, left: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: _hight * 0.03,
                child: ClipOval(
                  child: Image.network(
                      "https://pbs.twimg.com/media/Ey0G0DYU8AEr1D5.jpg",
                      width: _width * 0.4,
                      fit: BoxFit.fill),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Prabhas Uppalapati',
                      style: GoogleFonts.josefinSans(
                        color: Colors.grey[900],
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      )),
                  Text('Active Now',
                      style: GoogleFonts.josefinSans(
                        color: Colors.grey[900],
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ))
                ],
              )
            ],
          ),
          SizedBox(
            height: _hight * 0.05,
          ),
          Column(
            children: drawerItems
                .map((element) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
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
        ],
      ),
    );
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