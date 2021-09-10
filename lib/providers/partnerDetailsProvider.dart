import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotmies_partner/apiCalls/apiCalling.dart';
import 'package:spotmies_partner/apiCalls/apiInterMediaCalls/orders.dart';
import 'package:spotmies_partner/apiCalls/apiUrl.dart';
import 'package:spotmies_partner/apiCalls/testController.dart';
// import 'package:spotmies_partner/localDB/localStore.dart';

class PartnerDetailsProvider extends ChangeNotifier {
  final controller = TestController();
  var partnerLocal;
  Map partnerDetailsFull;
  Map profileDetails;
  List inComingOrders;
  List orders;

  void setPartnerDetails(data){
    var dataTemp = data;
    partnerDetailsFull = dataTemp;
    inComingOrders = dataTemp['inComingOrders'];
    orders = dataTemp['orders'];
    dataTemp.removeWhere((key, value) => key == "inComingOrders" || key == "orders");
    profileDetails = dataTemp;
    notifyListeners();
  }

  Map get getProfileDetails => profileDetails;
  Map get getPartnerDetailsFull => partnerDetailsFull;
  List get getIncomingOrder => inComingOrders;
  List get getOrders => orders;

















  localDetailsGet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String pd = prefs.getString('partnerDetails');
    if (pd == null) {
      partnerDetails();
    }
    partnerLocal = jsonDecode(pd);
  }

  partnerDetails() async {
    var response = await Server().getMethod(API.partnerDetails);
    partnerLocal = jsonDecode(response);
    controller.getData();
    localPartnerDetailsStore(partnerLocal);
    notifyListeners();
  }

  localPartnerDetailsStore(partnerLocal) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('partnerDetails', jsonEncode(partnerLocal));
  }




}


