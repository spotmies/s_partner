import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotmies_partner/apiCalls/apiCalling.dart';
import 'package:spotmies_partner/apiCalls/apiUrl.dart';
import 'package:spotmies_partner/apiCalls/testController.dart';

class IncomingOrdersProvider extends ChangeNotifier {
  final controller = TestController();
  var orders;
  var local;

  final queryParameters = {
    'showOnly': 'inComingOrders',
    'extractData': 'true',
    'ordState': 'req'
  };

  incomingOrders() async {
    var response =
        await Server().getMethodParems(API.incomingorders, queryParameters);
    orders = jsonDecode(response);
    controller.getData();
    notifyListeners();
  }

  localStore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('details', jsonEncode(orders));
  }

  localGet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String partnerData = prefs.getString('details');
    Map<String, dynamic> details =
        jsonDecode(partnerData) as Map<String, dynamic>;
    local = details;
  }
}
