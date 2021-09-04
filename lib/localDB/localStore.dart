import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

//local orders storing

localOrdersStore(orders) async {
  log('message');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('inComingOrders', jsonEncode(orders));
}

//local partner details storing

localPartnerDetailsStore(partner) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('localPartnerDetails', jsonEncode(partner));
}

//local chat list store

localChatListStore(chat) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('chatListStore', jsonEncode(chat));
 
}
