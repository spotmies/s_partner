import 'package:firebase_auth/firebase_auth.dart';

var field1 = 'inComingOrders';
var field2 = true;
var field3 = 'req';

class API {
  static var pid = FirebaseAuth.instance.currentUser.uid; //user id
  static var host = 'spotmiesserver.herokuapp.com'; //server path
  static var localHost = "http://localhost:4000";
  static var partnerRegister = '/api/partner/newPartner'; //post
  static var partnerDetails = '/api/partner/partners/$pid'; //get with user id
  static var partnerStatus = "/api/partner/partners/$pid"; //put with user id
  static var incomingorders =
      "api/partner/partners/$pid"; //get with user id and parems
  static var acceptOrder = '/api/order/orders/';
  static var updateOrder = '/api/response/newResponse/';
}
// api/partner/partners/VTrVbZPiK5hbGW8tlnDAfAyaINV2?showOnly=inComingOrders&extractData=true
// "api/partner/partners” + ”?” + “showOnly=${field1}&extractData${field2}&ordState${field3}"