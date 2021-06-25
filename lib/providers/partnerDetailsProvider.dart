import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotmies_partner/apiCalls/apiCalling.dart';
import 'package:spotmies_partner/apiCalls/apiUrl.dart';
import 'package:spotmies_partner/apiCalls/testController.dart';

class PartnerDetailsProvider extends ChangeNotifier {
  final controller = TestController();
  var partner;
  var status;

  partnerDetails() async {
    var response = await Server().getMethod(API.partnerDetails);
    partner = jsonDecode(response);

    //local data
    final prefs = await SharedPreferences.getInstance();
    status = (prefs.getBool(partner["availability"]));
    prefs.setInt('status', status);
    controller.getData();
    notifyListeners();
  }
}
