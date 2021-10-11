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
  if (response.statusCode == 200) {
    partner = jsonDecode(response.body);
    // log(partner.toString());
    // log(response.statusCode.toString());
    localPartnerDetailsStore(partner);

    controller.getData();
    return partner;
  }
  return null;
}

partnerDetailsFull() async {
  Map<String, String> query = {
    'extractData': 'true',
  };

  var response = await Server().getMethodParems(API.partnerDetails, query);
  if (response.statusCode == 200) {
    var partnerDetails = jsonDecode(response.body);
    return partnerDetails;
  }
  return null;
}

partnerAllOrders() async {
  var response = await Server().getMethod(API.allOrder);
  if(response.statusCode == 200){
  var responseDecode = jsonDecode(response.body);
  return responseDecode;
  }
  return null;
}
