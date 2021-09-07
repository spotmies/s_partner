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
  // log(ico);
   if (ico == null) {
    incomingOrders();
  }
  //  Map<String,dynamic> inComings = jsonDecode(ico) as Map<String,dynamic>;
  
  
  // log(inComings.toString());
  // // log('message');
  // if (inComings == null) {
  //   incomingOrders();
  //   log('orders api called');
  // }
  return jsonDecode(ico);
}

//get partner details from local db

localPartnerDetailsGet() async {
  
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String pd = prefs.getString('localPartnerDetails');
  if (pd == null) {
   return partnerDetail();
  }
  Map<String, dynamic> parData = jsonDecode(pd) as Map<String, dynamic>;
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
