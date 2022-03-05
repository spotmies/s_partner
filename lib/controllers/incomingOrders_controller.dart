import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:spotmies_partner/apiCalls/apiCalling.dart';
import 'package:spotmies_partner/apiCalls/apiUrl.dart';
import 'package:spotmies_partner/providers/inComingOrdersProviders.dart';
import 'package:spotmies_partner/providers/partnerDetailsProvider.dart';
import 'package:spotmies_partner/utilities/snackbar.dart';

class IncomingOrdersController extends ControllerMVC {
  final GlobalKey incomingscaffoldkey = GlobalKey<ScaffoldState>();

  TextEditingController moneyController = TextEditingController();
  PartnerDetailsProvider? partnerProvider;

  GlobalKey<FormState> updateFormKey = GlobalKey<FormState>();

  // var path;
  // var userid;
  // var orderid;
  // var incoming;
  // var partner;
  // var localData;
  String pid = FirebaseAuth.instance.currentUser!.uid.toString(); //user id
  // var socketincomingorder;
  String? pmoney;
  DateTime? pickedDate;
  TimeOfDay? pickedTime;

  // StreamController socketIncomingOrders;
  IncomingOrdersProvider? incomingOrdersProvider;

  Stream? stream;
  var onlineOrd;
  var localOrd;
  IO.Socket? socket;
  List? jobs = [
    'AC Service',
    'Computer',
    'TV Repair',
    'Development',
    'Tutor',
    'Beauty',
    'Photography',
    'Drivers',
    'Events'
  ];

  // @override
  // void initState() {
  //   partnerProvider =
  //       Provider.of<PartnerDetailsProvider>(context, listen: false);
  //   //  fetchIncomingOrderPeriodic();
  //   super.initState();
  // }

  addDataToSocket(neworders, ld) {
    if (neworders != null) {
      if (ld.last['ordId'] != neworders['ordId']) {
        WidgetsBinding.instance?.addPostFrameCallback((_) async {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString(
              'inComingOrders', jsonEncode(List.from(ld)..addAll([neworders])));
          incomingOrdersProvider?.localOrdersGet();
          setState(() {});
        });
      }
    }
  }

  pickedDateandTime(BuildContext context, {setStatee}) async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: pickedDate!,
        firstDate: DateTime(DateTime.now().year - 0, DateTime.now().month - 0,
            DateTime.now().day - 0),
        lastDate: DateTime(DateTime.now().year + 1));
    if (date != null) {
      TimeOfDay? t = await showTimePicker(
        context: context,
        initialTime: pickedTime!,
      );
      if (t != null) {
        pickedTime = t;
      }
      pickedDate = date;

      if (setStatee != null)
        setStatee(() {});
      else
        setState(() {});
    }
  }

  respondToOrder(
      orderData, pDetailsId, responseType, BuildContext context) async {
    //enable loader
    // if (partnerProvider!.inComingLoader) return;
    if (orderData['orderState'] > 6) {
      if (responseType != "reject") {
        snackbar(
            context, "This order takeover by someone else your May Reject it");
        return;
      }
    }
    partnerProvider?.setInComingLoader(true);
    Map<String, dynamic> body = {
      //
      "responseType": responseType,
      "pId": API.pid.toString(),
      "orderDetails": orderData['_id'].toString(),
    };
    if (responseType == "accept" || responseType == "bid") {
      body["uId"] = orderData['uId'].toString();
      body["ordId"] = orderData['ordId'].toString();
      body["responseId"] = DateTime.now().millisecondsSinceEpoch.toString();
      body["join"] = DateTime.now().millisecondsSinceEpoch.toString();
      body["loc.0"] = 17.236.toString();
      body["loc.1"] = 83.697.toString();
      body["uDetails"] = orderData['uDetails']['_id'].toString();
      body["pDetails"] = pDetailsId.toString();
      body['deviceToken'] = orderData['uDetails']['userDeviceToken'].toString();
      body['notificationTitle'] = "New response";
    }
    if (responseType == "accept") {
      body["money"] = orderData['money'].toString();
      body['schedule'] = orderData['schedule'].toString();
      body['notificationBody'] =
          "Your request order accepted by ${partnerProvider?.getProfileDetails['name']}";
      partnerProvider =
          Provider.of<PartnerDetailsProvider>(context, listen: false);
      //partnerProvider?.orders.add();
      var elements = partnerProvider?.inComingOrders.where(
          (element) => element['ordId'].toString() == pDetailsId.toString());
      if (elements != null) {
        partnerProvider?.orders.addAll(elements);
        partnerProvider?.inComingOrders.removeWhere(
            (element) => element['ordId'].toString() == pDetailsId.toString());
      }
    } else if (responseType == "bid") {
      //below for bid order
      body["money"] = moneyController.text.toString();
      body['schedule'] = pickedDate?.millisecondsSinceEpoch.toString();
      body['notificationBody'] =
          "Your request order bid by ${partnerProvider?.getProfileDetails['name']}";
    }

    log("order $body");

    var response = await Server().postMethod(API.updateOrder, body);
    //disable loader here.
    partnerProvider?.setInComingLoader(false);
    if (response.statusCode == 200 || response.statusCode == 204) {
      if (responseType == "reject")
        snackbar(incomingscaffoldkey.currentContext!, "Deleted successfully");
      else {
        snackbar(
            incomingscaffoldkey.currentContext!, "Request send successfully");
        if (responseType == "accept") {
          dynamic getThatOrder = await Server()
              .getMethod(API.acceptOrder + orderData['ordId'].toString());
          if (response.statusCode == 200) {
            getThatOrder = jsonDecode(getThatOrder.body);
            partnerProvider?.pushOrder(getThatOrder);
          } else
            snackbar(
                incomingscaffoldkey.currentContext!, "something went wrong");
        }
      }

      partnerProvider?.removeIncomingOrderById(orderData['ordId']);
      moneyController.clear();
    } else {
      snackbar(context, "Something went wrong please try again later");
    }
  }
}
