import 'dart:developer';

import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  List<dynamic> chatList = [];
  var sendMessageQueue = [];
  bool readyToSend = true;
  String currentMsgId = "";
  bool scrollEvent = false;
  int msgCount = 20;
  bool enableFoat = true;
  setChatList(var list) {
    print("loading chats ..........>>>>>>>>> $list");
    chatList = list;
    notifyListeners();
  }

  getChatList2() => chatList;

  newMessagetemp() => sendMessageQueue;

  addnewMessage(value) {
    String msgId = value['target']['msgId'];
    log("$msgId $currentMsgId");
    List<dynamic> allChats = chatList;
    for (int i = 0; i < allChats.length; i++) {
      if (allChats[i]['msgId'] == msgId) {
        allChats[i]['msgs'].add(value['object']);
        if (msgId != currentMsgId) {
          allChats[i]['pCount'] = allChats[i]['pCount'] + 1;
        }

        // log(allChats[0]['msgs'].toString());
        // allChats.insert(0, allChats[i]);
        // allChats.removeAt(i + 1);
        chatList = allChats;
        break;
      }
    }
    scrollEvent = !scrollEvent;
    notifyListeners();
  }

  resetMessageCount(msgId) {
    int index =
        chatList.indexWhere((element) => element['msgId'].toString() == msgId);
    log(chatList[index]['pCount'].toString());
    chatList[index]['pCount'] = 0;
    log(chatList[index]['pCount'].toString());

    notifyListeners();
  }

  setSendMessage(payload) {
    sendMessageQueue.add(payload);
    log(sendMessageQueue.toString());
    notifyListeners();
  }

  clearMessageQueue() {
    sendMessageQueue.clear();
    readyToSend = true;
    notifyListeners();
  }

  setScroll() {
    scrollEvent = !scrollEvent;
    notifyListeners();
  }

  getScroll() => scrollEvent;

  getMsgId() => currentMsgId;

  setMsgId(msgId) {
    currentMsgId = msgId;
    readyToSend = true;
    notifyListeners();
  }

  getMsgCount() => msgCount;
  setMsgCount(count) {
    msgCount = count;
    notifyListeners();
  }

  getFloat() => enableFoat;
  setFloat(state) {
    enableFoat = state;
    notifyListeners();
  }

  getReadyToSend() => readyToSend;
  setReadyToSend(state) {
    readyToSend = state;
  }
}
