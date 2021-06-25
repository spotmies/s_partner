import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotmies_partner/apiCalls/apiCalling.dart';
import 'package:spotmies_partner/apiCalls/apiUrl.dart';
import 'package:spotmies_partner/apiCalls/testController.dart';

class PartnerDetailsProvider extends ChangeNotifier {
  final controller = TestController();
  var partner;
  var local;

  partnerDetails() async {
    var response = await Server().getMethod(API.partnerDetails);
    partner = jsonDecode(response);
    controller.getData();
    notifyListeners();
  }

  localStore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('details', jsonEncode(partner));
  }

  localData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String partnerData = prefs.getString('details');
    Map<String, dynamic> details =
        jsonDecode(partnerData) as Map<String, dynamic>;
    local = details;
    // print('print from provider');
    print(local);
  }

  // updateLocal(value) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString(local['availability'], value);
  // }
}
