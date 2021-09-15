import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
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
  List inComingOrders = [];
  List orders = [];
  bool ordsLoader = false;
  bool inComingOrdersLoader = false;

  bool get inComingLoader => inComingOrdersLoader;
  bool get ordersLoader => ordsLoader;
  void setOrdersLoader(loaderState) {
    ordsLoader = loaderState;
    notifyListeners();
  }

  void setInComingLoader(loaderState) {
    inComingOrdersLoader = loaderState;
    notifyListeners();
  }

  void sortListByTime() {
    inComingOrders.sort((a, b) {
      return a['join'].compareTo(b['join']);
    });
  }

  void setPartnerDetails(data) {
    var dataTemp = data;
    partnerDetailsFull = dataTemp;
    inComingOrders = dataTemp['inComingOrders'];
    sortListByTime();
    orders = dataTemp['orders'];
    dataTemp.removeWhere(
        (key, value) => key == "inComingOrders" || key == "orders");
    profileDetails = dataTemp;
    notifyListeners();
  }

  Map get getProfileDetails => profileDetails;
  Map get getPartnerDetailsFull => partnerDetailsFull;
  List get getIncomingOrder => inComingOrders;
  void setIncomingOrders(ordersList) {
    inComingOrders = ordersList;
    sortListByTime();
    notifyListeners();
  }

  List get getOrders => orders;

  void addNewIncomingOrder(order) {
    inComingOrders.add(order);

    sortListByTime();
    notifyListeners();
  }

  void removeIncomingOrderById(ordId) {
    inComingOrders.removeWhere(
        (element) => element['ordId'].toString() == ordId.toString());
    notifyListeners();
  }

  void setOrder(allOrders) {
    orders = allOrders;
    notifyListeners();
  }

//old methods
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
