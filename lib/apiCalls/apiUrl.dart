import 'package:firebase_auth/firebase_auth.dart';

class API {
  static var pid = FirebaseAuth.instance.currentUser.uid; //user id
  static var host = 'spotmiesserver.herokuapp.com'; //server path
  static var partnerRegister = '/api/partner/newPartner'; //post
  static var partnerDetails = '/api/partner/partners/$pid'; //get with user id
  static var partnerStatus = "/api/partner/partners/$pid";
}
