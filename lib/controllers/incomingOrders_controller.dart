import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:spotmies_partner/apiCalls/apiCalling.dart';
import 'package:spotmies_partner/apiCalls/apiUrl.dart';
import 'package:spotmies_partner/providers/inComingOrdersProviders.dart';
import 'package:spotmies_partner/providers/partnerDetailsProvider.dart';
import 'package:spotmies_partner/utilities/snackbar.dart';

class IncomingOrdersController extends ControllerMVC {
  var incomingscaffoldkey = GlobalKey<ScaffoldState>();

  TextEditingController moneyController = TextEditingController();
  PartnerDetailsProvider partnerProvider;

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

  @override
  void initState() {
    partnerProvider =
        Provider.of<PartnerDetailsProvider>(context, listen: false);

    super.initState();
  }

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

  final incomingOrdersQuery = {
    'showOnly': 'inComingOrders',
    'extractData': 'true',
    'ordState': 'req'
  };

  Future incomingOrders() async {
    var response =
        await Server().getMethodParems(API.incomingorders, incomingOrdersQuery);
    log('api called');
    // log(response);
    var orders = jsonDecode(response);
    partnerProvider.setIncomingOrders(orders);
    snackbar(context, "Incoming orders fetched successfully");
  }


  
}
