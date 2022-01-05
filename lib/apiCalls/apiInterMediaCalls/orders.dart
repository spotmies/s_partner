import 'dart:convert';
import 'dart:developer';
import 'package:spotmies_partner/apiCalls/apiCalling.dart';
import 'package:spotmies_partner/apiCalls/apiUrl.dart';
import 'package:spotmies_partner/home/navBar.dart';
import 'package:spotmies_partner/localDB/localStore.dart';

// final controller = TestController();
var orders;
final queryParameters = {
  'showOnly': 'inComingOrders',
  'extractData': 'true',
  // 'ordState': 'req'
  'orderState': "0"
};

incomingOrders() async {
  var response =
      await Server().getMethodParems(API.incomingorders + pId, queryParameters);
  log('api called');
  // log(response);
  if (response.statusCode == 200) {
    orders = jsonDecode(response.body);
    log(orders.toString());
    // controller.getData();
    localOrdersStore(orders);
  }
}
