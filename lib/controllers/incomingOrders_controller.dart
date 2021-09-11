import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:spotmies_partner/providers/inComingOrdersProviders.dart';

class IncomingOrdersController extends ControllerMVC {
  var incomingscaffoldkey = GlobalKey<ScaffoldState>();

  TextEditingController moneyController = TextEditingController();

  var updateFormKey = GlobalKey<FormState>();

  var path;
  var userid;
  var orderid;
  var incoming;
  var partner;
  var localData;
  // var socketincomingorder;
  String pmoney;
  DateTime pickedDate;
  TimeOfDay pickedTime;

  StreamController socketIncomingOrders;
  IncomingOrdersProvider incomingOrdersProvider;

  Stream stream;
  var onlineOrd;
  var localOrd;
  IO.Socket socket;
  List jobs = [
    'AC Service',
    'Computer',
    'TV Repair',
    'Development',
    'Tutor',
    'Beauty',
    'Photography',
    'Drivers',
    'Events'
  ];

  // void socketOrders() {
  //   socket = IO.io("https://spotmiesserver.herokuapp.com", <String, dynamic>{
  //     "transports": ["websocket", "polling", "flashsocket"],
  //     "autoConnect": false,
  //   });
  //   socket.onConnect((data) {
  //     print("Connected");
  //     socket.on("message", (msg) {
  //       print(msg);
  //     });
  //   });
  //   socket.connect();
  //   socket.emit('join-partner', FirebaseAuth.instance.currentUser.uid);
  //   socket.on('inComingOrders', (socket) async {
  //     socketIncomingOrders.add(socket);
  //   });
  // }

  addDataToSocket(neworders, ld) {
    if (neworders != null) {
      if (ld.last['ordId'] != neworders['ordId']) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString(
              'inComingOrders', jsonEncode(List.from(ld)..addAll([neworders])));
          incomingOrdersProvider.localOrdersGet();
          setState(() {});
        });
      }
    }
  }

  pickedDateandTime() async {
    DateTime date = await showDatePicker(
        context: context,
        initialDate: pickedDate,
        firstDate: DateTime(DateTime.now().year - 0, DateTime.now().month - 0,
            DateTime.now().day - 0),
        lastDate: DateTime(DateTime.now().year + 1));
    if (date != null) {
      setState(() async {
        TimeOfDay t = await showTimePicker(
          context: context,
          initialTime: pickedTime,
        );
        if (t != null) {
          setState(() {
            pickedTime = t;
          });
        }
        pickedDate = date;
      });
    }
  }
}
