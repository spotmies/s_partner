// import 'dart:convert';
// import 'dart:developer';

// import 'package:flutter/cupertino.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:spotmies_partner/apiCalls/apiCalling.dart';
// import 'package:spotmies_partner/apiCalls/apiUrl.dart';
// import 'package:spotmies_partner/apiCalls/testController.dart';
// import 'package:spotmies_partner/localDB/localStore.dart';

// class IncomingOrdersProvider extends ChangeNotifier {
//   final controller = TestController();
//   var orders;
//   // var local;

//   final queryParameters = {
//     'showOnly': 'inComingOrders',
//     'extractData': 'true',
//     'ordState': 'req'
//   };

//   // incomingordersinfo(status) async {
//   //   status == false ? print('null') : print('not null');
//   //   if (status == false) {
//   //     if (local == null) {
//   //       incomingOrders();
//   //       localStore();
//   //       localGet();
//   //     }
//   //     localGet();
//   //   }
//   //   if (status == true) {
//   //     await incomingOrders();
//   //     await localStore();
//   //     await localGet();
//   //   }
//   // }

//   // incomingOrders() async {
//   //   var response =
//   //       await Server().getMethodParems(API.incomingorders, queryParameters);
//   //   orders = jsonDecode(response);
//   //   controller.getData();
//   //   localOrdersStore(orders);
//   //   notifyListeners();
//   // }

//   // localStore() async {
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   prefs.setString('details', jsonEncode(orders));
//   // }

//   // localGet() async {
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   String partnerData = prefs.getString('details');
//   //   List<dynamic> details = local == null ? jsonDecode(partnerData) : local;
//   //   local = details;
//   // }
// }
