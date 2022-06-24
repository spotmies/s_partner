import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spotmies_partner/apiCalls/apiCalling.dart';
import 'package:spotmies_partner/apiCalls/apiUrl.dart';
import 'package:spotmies_partner/controllers/login_controller.dart';
import 'package:spotmies_partner/utilities/shared_preference.dart';
// import 'package:spotmies_partner/localDB/localStore.dart';

class PartnerDetailsProvider extends ChangeNotifier {
  // final controller = TestController();
  bool registrationInProgress = false;
  Map? partnerDetailsFull = {};
  Map? profileDetails = {};
  List inComingOrders = [];
  List orders = [];
  bool ordsLoader = false;
  bool orderViewLoader = false;
  bool inComingOrdersLoader = false;
  bool editProfileLoader = false;
  bool catelogListLoader = false;
  String editProfileLoaderName = "";
  bool offlineScreenLoader = true;
  bool reloadIncomingOrders = false;
  String currentPid = "123456";
  List servicesList = [];
  dynamic freqAskQue;
  bool? statNote = true;
  bool? msgNote = true;
  String helperText = "";
  Color helperColor = Colors.grey;
  String isFabVisible = "2";

/* ------------------------- constant variables here ------------------------ */

  Map<dynamic, dynamic> allConstants = {};
  String currentScreen = "";
  dynamic currentConstants;

  void setFabVisible(String? val) {
    isFabVisible = val ?? "2";
    notifyListeners();
  }

  void setCatelogListLoader(bool? loading) {
    catelogListLoader = loading ?? false;
    notifyListeners();
  }

  void setAllConstants(dynamic constants) {
    allConstants = constants;
  }

  getAllConstants() {
    return allConstants;
  }

  void setCurrentConstants(String screenName) {
    currentScreen = screenName;
    currentConstants = allConstants[currentScreen];
  }

  getText(String objId) {
    if (currentConstants == null) return "loading..";
    // log('50' + currentConstants.toString());
    int index = currentConstants?.indexWhere(
        (element) => element['objId'].toString() == objId.toString());

    if (index == -1) return "null";
    return currentConstants[index]['label'];
  }

  getValue(String objId) {
    if (currentConstants == null) return null;
    int index = currentConstants?.indexWhere(
        (element) => element['objId'].toString() == objId.toString());
    if (index == -1) return null;
    dynamic retrive = jsonDecode(currentConstants[index]['value']);
    return retrive;
  }

  getConstants({bool alwaysHit = false}) async {
    if (alwaysHit == false) {
      dynamic constantsFromSf = await getAppConstants();
      if (constantsFromSf != null) {
        allConstants = constantsFromSf;

        log("constants already in sf");
        return;
      }
    }

    dynamic appConstants = await constantsAPI();
    if (appConstants != null) {
      log("new constatns downloaded");
      allConstants = appConstants;
    }
    return;
  }

  /* ---------------------------------- xxxxx --------------------------------- */

  bool get inComingLoader => inComingOrdersLoader;
  bool get ordersLoader => ordsLoader;
  bool get editLoader => editProfileLoader;
  Map get getProfileDetails => profileDetails!;
  Map get getPartnerDetailsFull => partnerDetailsFull!;
  List get getIncomingOrder => inComingOrders;
  List get getOrders => orders;
  List get getServiceList => servicesList;

  void setHelperText(String text,
      {Color color = Colors.grey, bool notify = true}) {
    helperText = text;
    helperColor = color;
    if (notify) notifyListeners();
  }

  void setRegistrationInProgress(bool state) {
    registrationInProgress = state;
    print("RIP STATUS - $state $registrationInProgress");
    notifyListeners();
  }

  getServiceListFromServer() async {
    dynamic resp = await Server().getMethod(API.servicesList);
    if (resp.statusCode == 200) {
      dynamic list = jsonDecode(resp.body);
      log(list.toString());
      log("confirming all serviceslist are downloaded....");
      servicesList = list;
      sortServiceList();
      setListOfServices(list);
      return true;
    } else {
      return false;
    }
  }

  fetchServiceList({bool alwaysHit = false}) async {
    if (!alwaysHit) {
      dynamic servicesListFromSf = await getListOfServices();
      if (servicesListFromSf != null) {
        servicesList = servicesListFromSf;

        log("service list already in sf");
        return;
      }
    }

    getServiceListFromServer();
  }

  void sortServiceList() {
    servicesList.sort((a, b) {
      return a['sort'].compareTo(b['sort']);
    });
  }

  getServiceNameById(int id) {
    int index = servicesList.indexWhere(
        (element) => element['serviceId'].toString() == id.toString());
    if (index < 0) return "null";
    return servicesList[index]['nameOfService'];
  }

  setCurrentPid(dynamic pid) {
    currentPid = pid.toString();
    notifyListeners();
  }

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
    print("RIP STT - $editProfileLoader");
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

  void setPartnerDetails(data, {bool ignoreOrders = false}) {
    dynamic dataTemp = data;

    profileDetails = dataTemp;
    partnerDetailsFull = dataTemp;
    inComingOrders = dataTemp['inComingOrders'];
    offlineScreenLoader = false;
    sortListByTime();
    if (!ignoreOrders) {
      orders = dataTemp['orders'];
    }

    //setPartnerDetailsOnly(dataTemp);
    notifyListeners();
    saveMyProfile(dataTemp);
  }

  Future<void> getOnlyIncomingOrders() async {
    final Map<String, String> incomingOrdersQuery = {
      'showOnly': 'inComingOrders',
      'extractData': 'true',
      'orderState': "0"
    };

    dynamic response = await Server()
        .getMethodParems(API.incomingorders + currentPid, incomingOrdersQuery);
    if (response.statusCode == 200) {
      dynamic orders = jsonDecode(response.body);
      setIncomingOrders(orders);
    }
  }

  void setFAQ(faq) {
    dynamic frequently = faq;
    freqAskQue = frequently;
    notifyListeners();
  }

  void setPartnerDetailsOnly(data) {
    dynamic dataTemp = data;
    dataTemp.removeWhere((key, value) =>
        key == "inComingOrders" ||
        key == "orders" ||
        key == "catelogs" ||
        key == "rate" ||
        key == "ref" ||
        key == "feedBack" ||
        key == "complaints" ||
        key == "reports");
    profileDetails = dataTemp;
    partnerDetailsFull = {...partnerDetailsFull!, ...dataTemp};
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

  void refressIncomingOrder(state) {
    reloadIncomingOrders = state;
    notifyListeners();
  }

  void removeIncomingOrderById(ordId) {
    log("removing order $ordId");
    inComingOrders.removeWhere(
        (element) => element['ordId'].toString() == ordId.toString());
    notifyListeners();
  }

  void setAvailability(state) {
    partnerDetailsFull!['availability'] = state;
    profileDetails!['availability'] = state;
    notifyListeners();
  }

  void setCategoryItemState(state, index) {
    partnerDetailsFull!['catelogs'][index]['isActive'] = state;
    notifyListeners();
  }

  void setCategoryItem(body) {
    partnerDetailsFull!['catelogs'].add(body);
    notifyListeners();
  }

  void updateCategoryItem(body, index) {
    partnerDetailsFull!['catelogs'][index] = body;
    // partnerDetailsFull!['catelogs'][index]['name'] = body['name'];
    // partnerDetailsFull!['catelogs'][index]['description'] = body['description'];
    // partnerDetailsFull!['catelogs'][index]['price'] = body['price'];
    // partnerDetailsFull!['catelogs'][index]['media'] = body['media'];

//     final List media =     body['media'] as List;
//     for (int i = 0; i < media.length; i++) {
// partnerDetailsFull!['catelogs'][index]['media'][i]['url'] = media[i]

//     }
    notifyListeners();
  }

  void removeCategoryItem(cat) {
    partnerDetailsFull!['catelogs']
        .removeWhere((element) => element['_id'].toString() == cat.toString());
    notifyListeners();
  }

  void setOrder(allOrders) {
    orders = allOrders;
    notifyListeners();
    saveOrders(allOrders);
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
    offlineScreenLoader = state ?? true;
    notifyListeners();
  }

  void mergePartnerDetails(data) {
    // partnerDetailsFull = {...partnerDetailsFull!, ...data};
    partnerDetailsFull = data;
    notifyListeners();
  }

  void updateOrderBy_id(String _id, Map payload) {
    int i = orders.indexWhere(
        (order) => order['_id'] == _id || order['ordId'].toString() == _id);
    orders[i] = {...orders[i], ...payload};
    notifyListeners();
  }

  void deleteOrderByOrdId(String ordId) {
    orders.removeWhere((order) => order['ordId'].toString() == ordId);
    notifyListeners();
  }
}
