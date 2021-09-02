import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  List<dynamic> chatList = [];
  List<dynamic> sendMessageQueue = [];
  List<dynamic> readReceipts = [];
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

  getChatDetailsByMsgId(msgId) {
    int index = chatList.indexWhere((element) => element['msgId'] == msgId);
    return chatList[index];
  }

  newMessagetemp() => sendMessageQueue;

  addnewMessage(value) {
    String msgId = value['target']['msgId'];
    var sender = jsonDecode(value['object']);
    sender = sender['sender'];
    log("$msgId $currentMsgId $sender");
    List<dynamic> allChats = chatList;
    for (int i = 0; i < allChats.length; i++) {
      if (allChats[i]['msgId'] == msgId) {
        allChats[i]['lastModified'] =
            int.parse(DateTime.now().millisecondsSinceEpoch.toString());

        allChats[i]['msgs'].add(value['object']);
        if (sender == "partner") {
          allChats[i]['pState'] = 0;
        } else {
          //read receipt code
          log("read receipt provider");
          if (currentMsgId == msgId) {
            Map object = {
              "uId": allChats[i]['uId'],
              "pId": allChats[i]['pId'],
              "msgId": allChats[i]['msgId'],
              "sender": "partner"
            };
            setReadReceipt(object);
          }
        }
        if (msgId != currentMsgId) {
          allChats[i]['pCount'] = allChats[i]['pCount'] + 1;
        }
        allChats.sort((a, b) {
          return b['lastModified'].compareTo(a['lastModified']);
        });
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

  readReceipt(msgId, status) {
    chatList[chatList.indexWhere((element) => element['msgId'] == msgId)]
        ['pState'] = status;
  }

  chatReadReceipt(msgId) {
    readReceipt(msgId, 2);
    notifyListeners();
  }

  clearMessageQueue(msgId) {
    sendMessageQueue.clear();
    readyToSend = true;
    readReceipt(msgId, 1);

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

  setReadReceipt(payload) {
    if (payload == "clear")
      readReceipts.clear();
    else
      readReceipts.add(payload);
    notifyListeners();
  }

  getReadReceipt() => readReceipts;
}
