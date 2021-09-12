import 'dart:convert';
import 'dart:developer';

import 'package:spotmies_partner/apiCalls/apiCalling.dart';
import 'package:spotmies_partner/apiCalls/apiUrl.dart';
import 'package:spotmies_partner/apiCalls/testController.dart';
import 'package:spotmies_partner/localDB/localStore.dart';

final controller = TestController();
var chat;

chattingList() async {
  var response = await Server().getMethod(API.partnerChat);
  chat = jsonDecode(response);
  localChatListStore(chat);
  log(chat.toString());
  controller.getData();
}

getChatListFromDb() async {
  var response = await Server().getMethod(API.partnerChat);
  chat = jsonDecode(response);
  return chat;
}

getChatByIdFromDB(id) async {
  print("getting new chat from db");
  var query = {"cBuild": "1"};
  var response =
      await Server().getMethodParems(API.chatById + "/${id.toString()}", query);
  chat = jsonDecode(response);
  return chat;
}
