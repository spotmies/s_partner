import 'package:firebase_auth/firebase_auth.dart';

var field1 = 'inComingOrders';
var field2 = true;
var field3 = 'req';

class API {
  static var pid = FirebaseAuth.instance.currentUser?.uid; //user id
  // static var host = 'spotmies.herokuapp.com'; //server path
  static var host = 'server.spotmies.com';
  static var testingHost = 'spotmiesserver.herokuapp.com';
  static var localHost = "http://localhost:4000";
  static var partnerRegister = '/api/partner/newPartner'; //post
  static var partnerDetails = '/api/partner/partners/'; //get with user id
  static var partnerStatus = "/api/partner/partners/"; //put with user id
  static var incomingorders =
      "api/partner/partners/"; //get with user id and parems
  static var acceptOrder = '/api/order/orders/';
  static var updateOrder = '/api/response/newResponse/';
  static var updateResponse = "/api/response/responses/";
  static var partnerChat = '/api/chat/partner/';
  static var chatById = "/api/chat/chats";
  static var specificChat = "/api/chat/chats/";
  static var allOrder = "api/order/partner/";
  static var createNewChat = '/api/chat/createNewChatRoom';
  static var loginApi = '/api/partner/login';
  static var logoutApi = '/api/partner/logout';
  static var catelog = '/api/catelog/newCatelog/'; //catelogPost
  static var updateCatelog = '/api/catelog/catelogs/';
  static var deleteCatlog = '/api/catelog/catelogs/';

  static var servicesList = "/api/services/all-service-list";
  static var cloudConstants = "/api/constant/doc-id/partner_app_constants";

  static var faq = "/api/support/faq/all-faqs";
  static var suggestions = "/api/suggestion/new-suggestion";
  static var accessToken = "/api/public/access-token";
  static var storeAvailabilityCheck = "/api/store/check-store-availability";
}
// api/partner/partners/VTrVbZPiK5hbGW8tlnDAfAyaINV2?showOnly=inComingOrders&extractData=true
// "api/partner/partners” + ”?” + “showOnly=${field1}&extractData${field2}&ordState${field3}"