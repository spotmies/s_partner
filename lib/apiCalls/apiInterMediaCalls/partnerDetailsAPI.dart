import 'dart:convert';
import 'package:spotmies_partner/apiCalls/apiCalling.dart';
import 'package:spotmies_partner/apiCalls/apiUrl.dart';
import 'package:spotmies_partner/apiCalls/testController.dart';
import 'package:spotmies_partner/localDB/localStore.dart';

final controller = TestController();
var partner;
// var local;

partnerDetail() async {
  var response = await Server().getMethod(API.partnerDetails);
  partner = jsonDecode(response);
  // log(partner.toString());
  // log(response.statusCode.toString());
  localPartnerDetailsStore(partner);

  controller.getData();
  return partner;
}
