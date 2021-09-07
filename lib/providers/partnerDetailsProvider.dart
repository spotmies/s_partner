import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotmies_partner/apiCalls/apiCalling.dart';
import 'package:spotmies_partner/apiCalls/apiUrl.dart';
import 'package:spotmies_partner/apiCalls/testController.dart';
// import 'package:spotmies_partner/localDB/localStore.dart';

class PartnerDetailsProvider extends ChangeNotifier {
  final controller = TestController();
  var partnerLocal;
  // var local;

  partnerDetails() async {
    var response = await Server().getMethod(API.partnerDetails);
    partnerLocal = jsonDecode(response);
    controller.getData();
    localPartnerDetailsStore(partnerLocal);
    notifyListeners();
  }

  localPartnerDetailsStore(partnerLocal) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('details', jsonEncode(partnerLocal));
  }

  // localData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String partnerData = prefs.getString('details');
  //   Map<String, dynamic> details =
  //       jsonDecode(partnerData) as Map<String, dynamic>;
  //   local = details;

  //   // print('print from provider');
  //   // print(local);
  // }

  // updateLocal(value) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString(local['availability'], value);
  // }
}


// local == null ? jsonEncode(partner) : jsonEncode(local)