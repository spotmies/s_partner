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


partnerDetailsFull() async{
  Map<String, String> query = {
    'extractData': 'true',
  };

  var response = await Server().getMethodParems(API.partnerDetails, query);
  var partnerDetails = jsonDecode(response);
  return partnerDetails;
}

partnerAllOrders() async{
  var response   =await Server().getMethod(API.allOrder);
  var responseDecode = jsonDecode(response);
  return responseDecode;
}