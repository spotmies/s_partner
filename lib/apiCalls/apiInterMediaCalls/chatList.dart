import 'dart:convert';
import 'dart:developer';


import 'package:spotmies_partner/apiCalls/apiCalling.dart';
import 'package:spotmies_partner/apiCalls/apiUrl.dart';
import 'package:spotmies_partner/home/navBar.dart';
import 'package:spotmies_partner/localDB/localStore.dart';

// final controller = TestController();
var chat;
chattingList() async {
  dynamic response = await Server().getMethod(API.partnerChat + pId);
  if (response.statusCode == 200) {
    chat = jsonDecode(response.body);
    localChatListStore(chat);
    log(chat.toString());
    // controller.getData();
  }
}

getChatListFromDb(String currentPid) async {
  var response = await Server().getMethod(API.partnerChat + currentPid);
  if (response.statusCode == 200) {
    chat = jsonDecode(response.body);
    return chat;
  }
  return null;
}

getChatByIdFromDB(id) async {
  print("getting new chat from db");
  var query = {"cBuild": "1"};
  var response =
      await Server().getMethodParems(API.chatById + "/${id.toString()}", query);
  if (response.statusCode == 200) {
    chat = jsonDecode(response.body);
    return chat;
  }
  return null;
}
