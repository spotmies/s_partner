import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:spotmies_partner/apiCalls/apiCalling.dart';
import 'package:spotmies_partner/apiCalls/apiInterMediaCalls/partnerDetailsAPI.dart';
import 'package:spotmies_partner/apiCalls/apiUrl.dart';
import 'package:spotmies_partner/home/offline.dart';
import 'package:spotmies_partner/home/online.dart';
import 'package:spotmies_partner/localDB/localGet.dart';

TextEditingController isSwitched = TextEditingController();

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isSwitched = false;
  // var partner;

  // @override
  // void initState() {
  //   // partner = Provider.of<PartnerDetailsProvider>(context, listen: false);
  //   // partner.partnerDetails();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
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
          bool isSwitch = pr['availability'];

          isSwitched = isSwitch;

          return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.blue[900],
                title: Text(
                  pr['name'] == null ? 'User' : pr['name'],
                  overflow: TextOverflow.ellipsis,
                ),
                leading: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.menu,
                      size: 20,
                    )),
                actions: [
                  Container(
                      child: Transform.scale(
                    scale: 0.8,
                    child: Container(
                      child: Row(
                        children: [
                          FlutterSwitch(
                              activeColor: Colors.blue[900],
                              activeIcon: Icon(Icons.done),
                              inactiveIcon: Icon(Icons.gps_off_outlined),
                              inactiveColor: Colors.blue[900],
                              activeToggleColor: Colors.greenAccent[700],
                              inactiveToggleColor: Colors.redAccent[700],
                              activeText: 'Online',
                              inactiveText: 'Offline',
                              width: 130.0,
                              height: 40.0,
                              valueFontSize: 25.0,
                              toggleSize: 45.0,
                              borderRadius: 30.0,
                              padding: 5.0,
                              showOnOff: true,
                              value: isSwitched,
                              onToggle: (value) {
                                var body = {
                                  "availability": value.toString(),
                                };
                                setState(() {
                                  Server().editMethod(API.partnerStatus, body);
                                });
                                // Server().editMethod(API.partnerStatus, body);
                                // partner.updateLocal(value);
                                partner.partnerDetails();
                              }),
                        ],
                      ),
                    ),
                  ))
                ],
              ),
              body: isSwitch ? Online() : Offline());
        });
  }
}

// import 'dart:developer';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_switch/flutter_switch.dart';
// import 'package:provider/provider.dart';
// import 'package:spotmies_partner/apiCalls/apiCalling.dart';
// import 'package:spotmies_partner/apiCalls/apiInterMediaCalls/partnerDetailsAPI.dart';
// import 'package:spotmies_partner/apiCalls/apiUrl.dart';
// import 'package:spotmies_partner/home/offline.dart';
// import 'package:spotmies_partner/home/online.dart';
// import 'package:spotmies_partner/localDB/localGet.dart';
// import 'package:spotmies_partner/providers/partnerDetailsProvider.dart';

// TextEditingController isSwitched = TextEditingController();

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   // bool isSwitched = true;
//   // var partner;

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: localPartnerDetailsGet(),
//         builder: (context, snapshot) {
//           //partnerDetail();
//           var p = snapshot.data;
//           log(p.toString());
//           if (snapshot.data == null) {
//             CircularProgressIndicator();
//             log('message');
//             partnerDetail();
//           }
//           // log(p.toString());
//           bool isSwitch = p['availability'];
//           // bool isSwitch = true;
//           var isSwitched = isSwitch;
//           return Scaffold(
//               appBar: AppBar(
//                 backgroundColor: Colors.blue[900],
//                 title: Text(p['name'] == null ? 'User' : p['name']),
//                 // title: Text('User'),
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
//                                 // partner.partnerDetails();
//                               }),
//                         ],
//                       ),
//                     ),
//                   ))
//                 ],
//               ),
//               body: isSwitch ? Online() : Offline());
//         });
//   }
// }
