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
  bool orderViewLoader = false;
  bool inComingOrdersLoader = false;
  bool editProfileLoader = false;
  String editProfileLoaderName = "";
  bool offlineScreenLoader = false;

  bool get inComingLoader => inComingOrdersLoader;
  bool get ordersLoader => ordsLoader;
  bool get editLoader => editProfileLoader;
  Map get getProfileDetails => profileDetails;
  Map get getPartnerDetailsFull => partnerDetailsFull;
  List get getIncomingOrder => inComingOrders;
  List get getOrders => orders;

  getOrderById(ordId) {
    int index;
    index = inComingOrders.indexWhere(
        (element) => element['ordId'].toString() == ordId.toString());
    if (index < 0) {
      index = orders.indexWhere(
          (element) => element['ordId'].toString() == ordId.toString());
      if (index < 0) return null;
      return orders[index];
    }
    return inComingOrders[index];
  }

  void setOrderViewLoader(state) {
    orderViewLoader = state;
    notifyListeners();
  }

  void setEditLoader(value, {loaderName = "Please wait..."}) {
    editProfileLoader = value;
    editProfileLoaderName = loaderName;
    notifyListeners();
  }

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
    setPartnerDetailsOnly(dataTemp);
    notifyListeners();
  }

  void setPartnerDetailsOnly(data) {
    var dataTemp = data;
    dataTemp.removeWhere(
        (key, value) => key == "inComingOrders" || key == "orders");
    profileDetails = dataTemp;
    notifyListeners();
  }

  void setIncomingOrders(ordersList) {
    inComingOrders = ordersList;
    sortListByTime();
    notifyListeners();
  }

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

  void setAvailability(state) {
    partnerDetailsFull['availability'] = state;
    profileDetails['availability'] = state;
    notifyListeners();
  }

  void setOrder(allOrders) {
    orders = allOrders;
    notifyListeners();
  }

  void pushOrder(orderData) {
    int index = orders.indexWhere((element) =>
        element['ordId'].toString() == orderData['ordId'].toString());
    if (index < 0) {
      orders.add(orderData);
      notifyListeners();
    } else {
      orders[index] = orderData;
      notifyListeners();
    }
  }

  void setOffileLoader(state) {
    offlineScreenLoader = state;
    notifyListeners();
  }
}
