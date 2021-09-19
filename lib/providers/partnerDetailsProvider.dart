


import 'package:flutter/material.dart';
import 'package:spotmies_partner/apiCalls/testController.dart';
// import 'package:spotmies_partner/localDB/localStore.dart';

class PartnerDetailsProvider extends ChangeNotifier {
  final controller = TestController();
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


}
