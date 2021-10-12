import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotmies_partner/apiCalls/apiCalling.dart';
import 'package:spotmies_partner/apiCalls/apiUrl.dart';
import 'package:spotmies_partner/apiCalls/testController.dart';
import 'package:spotmies_partner/utilities/snackbar.dart';
// import 'package:spotmies_partner/localDB/localStore.dart';

class IncomingOrdersProvider extends ChangeNotifier {
  final controller = TestController();
  var orders;
  var local;
  String pid = FirebaseAuth.instance.currentUser.uid.toString(); //user id

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
        await Server().getMethodParems(API.incomingorders + pid, queryParameters);
    if (response.statusCode == 200) {
      orders = jsonDecode(response.body);
      // controller.getData();
      localOrdersStore(orders);
      notifyListeners();
    }
  }

  localOrdersStore(orders) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('inComingOrders', jsonEncode(orders));
  }
}
