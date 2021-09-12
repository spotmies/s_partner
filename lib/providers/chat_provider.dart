import 'dart:async';
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

  //calling variables
  bool acceptCalls = true;
  int callDuration = 0;
  int callInitTimeOut = 15;
  bool stopTimer = false;

  int callStatus = 0; // 0- connecting or new connection 1-calling 2- ringing
  //3- connected 4- rejected 5- not lifted 6- call failed or disconnected

  setChatList(var list) {
    print("loading chats ..........>>>>>>>>> $list");
    chatList = list;
    confirmReceiveAllMessages();
    notifyListeners();
  }
   void setChatList2(var list) {
    print("loading chats ..........>>>>>>>>> $list");
    chatList = list;
    notifyListeners();
  }

  void sortChatListByTime(){
            chatList.sort((a, b) {
      return b['lastModified'].compareTo(a['lastModified']);
    });
  }
   void addNewChat(chatObject){
     chatList.add(chatObject);
     sortChatListByTime();
     notifyListeners();

   }

  getChatList2() => chatList;

  getChatDetailsByMsgId(msgId) {
    int index = chatList.indexWhere((element) => element['msgId'] == msgId);
    return chatList[index];
  }

  newMessagetemp() => sendMessageQueue;

  getUdetailsByMsgId(msgId) {
    int index = chatList.indexWhere(
        (element) => element['msgId'].toString() == msgId.toString());
    return chatList[index]['uDetails'];
  }

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
          callStatus = 0;
        } else {
          //read receipt code
          log("read receipt provider");

          Map object = {
            "uId": allChats[i]['uId'],
            "pId": allChats[i]['pId'],
            "msgId": allChats[i]['msgId'],
            "sender": "partner",
            "status": currentMsgId == msgId ? 3 : 2
          };
          setReadReceipt(object);
        }
        if (msgId != currentMsgId) {
          allChats[i]['pCount'] = allChats[i]['pCount'] + 1;
        }
        chatList = allChats;
        sortChatListByTime();
        break;
      }
    }
    scrollEvent = !scrollEvent;
    notifyListeners();
  }

  confirmReceiveAllMessages() {
    log("confirmall messages ${chatList.length}");
    for (int i = 0; i < chatList.length; i++) {
      if (chatList[i]['pCount'] > 0 && chatList[i]['uState'] < 2) {
        log("confirmed");
        Map object = {
          "uId": chatList[i]['uId'],
          "pId": chatList[i]['pId'],
          "msgId": chatList[i]['msgId'],
          "sender": "partner",
          "status": 2
        };

        readReceipts.add(object);
      }
    }
  }

  resetMessageCount(msgId) {
    int index =
        chatList.indexWhere((element) => element['msgId'].toString() == msgId);
    //log(chatList[index]['pCount'].toString());
    chatList[index]['pCount'] = 0;
    //log(chatList[index]['pCount'].toString());

    notifyListeners();
  }

  setSendMessage(payload) {
    sendMessageQueue.add(payload);
    //log(sendMessageQueue.toString());
    notifyListeners();
  }

  readReceipt(msgId, status) {
    chatList[chatList.indexWhere((element) => element['msgId'] == msgId)]
        ['pState'] = status;
  }

  chatReadReceipt(msgId, status) {
    readReceipt(msgId, status ?? 2);
    callStatus = status == 3 ? 2 : status;
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

  bool get getAcceptCall => acceptCalls;
  void setAcceptCall(state) {
    acceptCalls = state;
    notifyListeners();
  }

  int get duration => callDuration;

  void startCallDuration() {
    Timer.periodic(Duration(seconds: 1), (timer) {
        callDuration++;
        notifyListeners();
      if (callStatus != 3){
        // callDuration = 0;
 timer.cancel();
      }
    });
  }

  void resetDuration() {
    callDuration = 0;
  }

  int get getCallStatus => callStatus;

  void setCallStatus(state) {
    callStatus = state ?? 0;
    notifyListeners();
  }

  void resetCallInitTimeout() {
    callInitTimeOut = 15;
  }

  void setStopTimer() {
    stopTimer = true;
    notifyListeners();
  }

  void startCallTimeout() {
    log("timer started");
    Timer.periodic(Duration(seconds: 1), (timer) {
      callInitTimeOut--;
      if (callInitTimeOut < 1) notifyListeners();
      if (!acceptCalls || stopTimer) {
        timer.cancel();
        stopTimer = false;
        log("timer stopped");
      }
    });
  }

  int get callTimeout => callInitTimeOut;

  void resetAllCallingVariables(){
      acceptCalls = true;
     callDuration = 0;
     callInitTimeOut = 15;
     stopTimer = false;
     callStatus = 0;
     notifyListeners();
  }
}
