import 'dart:convert';
import 'dart:developer';
import 'package:spotmies_partner/apiCalls/apiCalling.dart';
import 'package:spotmies_partner/apiCalls/apiUrl.dart';
import 'package:spotmies_partner/home/navBar.dart';
import 'package:spotmies_partner/localDB/localStore.dart';

// final controller = TestController();
var partner;
// var local;

partnerDetail() async {
  log("uid >>>>>>> $pId");
  var response = await Server().getMethod(API.partnerDetails + pId);
  if (response.statusCode == 200) {
    partner = jsonDecode(response.body);
    // log(partner.toString());
    // log(response.statusCode.toString());
    localPartnerDetailsStore(partner);

    // controller.getData();
    return partner;
  }
  return null;
}

partnerDetailsFull(String currentPid) async {
  Map<String, String> query = {
    'extractData': 'true',
  };
  log("uid $pId");
  var response = await Server().getMethodParems(API.partnerDetails + currentPid, query);
  if (response.statusCode == 200) {
    var partnerDetails = jsonDecode(response.body);
    return partnerDetails;
  }
  return null;
}

partnerAllOrders(String currentPid) async {
  var response = await Server().getMethod(API.allOrder + currentPid);
  if(response.statusCode == 200){
  var responseDecode = jsonDecode(response.body);
  return responseDecode;
  }
  return null;
}
