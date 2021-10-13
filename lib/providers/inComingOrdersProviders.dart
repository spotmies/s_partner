import 'dart:convert';
import 'package:flutter/cupertino.dart';
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
    // 'ordState': 'req'
    'orderState': "0"
  };

  localOrdersGet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String ico = prefs.getString('inComingOrders');
    if (ico == null) {
      incomingOrders();
    }
    local = jsonDecode(ico);
  }

  incomingOrders() async {
    dynamic response =
        await Server().getMethodParems(API.incomingorders, queryParameters);
    orders = jsonDecode(response);
    // controller.getData();
    localOrdersStore(orders);
    notifyListeners();
  }

  localOrdersStore(orders) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('inComingOrders', jsonEncode(orders));
  }
}
