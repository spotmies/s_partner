import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:spotmies_partner/apiCalls/apiCalling.dart';
import 'package:spotmies_partner/apiCalls/apiUrl.dart';
import 'package:spotmies_partner/home/offline.dart';
import 'package:spotmies_partner/home/online.dart';
import 'package:spotmies_partner/providers/partnerDetailsProvider.dart';

TextEditingController isSwitched = TextEditingController();

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isSwitched = false;
  var partner;

  @override
  void initState() {
    partner = Provider.of<PartnerDetailsProvider>(context, listen: false);
    partner.localStore();
    partner.localData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PartnerDetailsProvider>(builder: (context, data, child) {
      // if (data.local == null) return Center(child: CircularProgressIndicator());
      var p = data.local;
      bool isSwitch = p['availability'];
      isSwitched = isSwitch;
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue[900],
            title: Text(p['name'] == null ? 'User' : p['name']),
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
