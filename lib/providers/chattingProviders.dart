import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotmies_partner/apiCalls/apiCalling.dart';
import 'package:spotmies_partner/apiCalls/apiUrl.dart';

class ChattingProvider extends ChangeNotifier {
  // final controller = TestController();
  var chat;
  var chatLocal;

  chatInfo(status) async {
    if (status == false) {
      await localData();
    } else {
      await chattingList();
      await localStore();
      await localData();
    }
  }

  chattingList() async {
    var response = await Server().getMethod(API.partnerChat);
    chat = jsonDecode(response);
    // controller.getData();
    notifyListeners();
  }

  localStore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('chat', jsonEncode(chat));
  }

  localData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? partnerData = prefs.getString('chat');
    List<dynamic> details =
        chatLocal == null ? jsonDecode(partnerData!) : chatLocal;
    chatLocal = details;

    // print('print from provider');
    // print(local);
  }

  // updateLocal(value) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString(local['availability'], value);
  // }
}


// local == null ? jsonEncode(partner) : jsonEncode(local)