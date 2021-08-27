import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  var chatList;
  setChatList(var list) {
    print("loading chats ..........>>>>>>>>> $list");
    chatList = list;
    notifyListeners();
  }

  List get getChatList {
    return chatList;
  }

  addnewMessage(value) {
    var msgId = value['target']['msgId'];
    var allChats = chatList;
    // log(allChats[0]['msgs'].toString());
    // log(jsonEncode(value['object']));
    for (int i = 0; i < allChats.length; i++) {
      if (allChats[i]['msgId'] == msgId) {
        allChats[i]['msgs'].add(value['object']);
        // log(allChats[0]['msgs'].toString());
        allChats.insert(0, allChats[i]);
        allChats.removeAt(i + 1);
        chatList = allChats;
        break;
      }
    }
    notifyListeners();
  }
}
