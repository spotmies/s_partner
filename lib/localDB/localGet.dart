import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotmies_partner/apiCalls/apiInterMediaCalls/Orders.dart';
import 'package:spotmies_partner/apiCalls/apiInterMediaCalls/chatList.dart';
import 'package:spotmies_partner/apiCalls/apiInterMediaCalls/partnerDetailsAPI.dart';

//get orders from local db

localOrdersGet() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String ico = prefs.getString('inComingOrders');
  List<dynamic> inComing = jsonDecode(ico);
  if (inComing == null) {
    incomingOrders();
    log('orders api called');
  }
  return inComing;
}

//get partner details from local db

localPartnerDetailsGet() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String pd = prefs.getString('localPartnerDetails');
  Map<String, dynamic> parData = jsonDecode(pd) as Map<String, dynamic>;
  if (parData == null) {
    partnerDetail();
  }
  return parData;
}

// get chatting list from db

localChatListGet() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String lc = prefs.getString('chatListStore');
  List<dynamic> localChat = jsonDecode(lc);
  // log(localChat.toString());
  if (localChat == null) {
    chattingList();
  }
  return localChat;
}
