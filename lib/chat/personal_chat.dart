import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:spotmies_partner/reusable_widgets/chat_input_field.dart';
import 'package:provider/provider.dart';
import 'package:spotmies_partner/providers/chat_provider.dart';
import 'package:spotmies_partner/reusable_widgets/date_formates.dart';
import 'package:spotmies_partner/reusable_widgets/profile_pic.dart';

class PersonalChat extends StatefulWidget {
  final String msgId;
  PersonalChat(this.msgId);
  @override
  _PersonalChatState createState() => _PersonalChatState();
}

class _PersonalChatState extends State<PersonalChat> {
  ChatProvider chatProvider;
  ScrollController _scrollController = ScrollController();
  List chatList = [];
  Map targetChat = {};
  Map user = {};
  int msgCount = 20;
  void scrollToBottom() {
    log("scroll");
    _scrollController?.jumpTo(_scrollController.position?.maxScrollExtent);
  }

  @override
  void initState() {
    super.initState();
    chatProvider = Provider.of<ChatProvider>(context, listen: false);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        log("at top >>>");
        chatProvider.setMsgCount(chatProvider.getMsgCount() + 20);
      }
      // if (_scrollController.position.pixels ==
      //     _scrollController.position.minScrollExtent) {
      //   chatProvider.resetMessageCount(widget.msgId);
      //   log('at Bottom >>>>>>>>>>>>');
      // }
    });
  }

  getTargetChat(list, msgId) {
    List currentChatData = list.where((i) => i['msgId'] == msgId).toList();

    return currentChatData[0];
  }

  sendMessageHandler(value) {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    Map<String, String> msgData = {
      'msg': value.toString(),
      'time': timestamp,
      'sender': 'partner',
      'type': 'text'
    };
    Map<String, dynamic> target = {
      'uId': user['uId'],
      // 'uId': "FtaZm2dasvN7cL9UumTG98ksk6I3",
      'pId': FirebaseAuth.instance.currentUser.uid,
      'msgId': widget.msgId,
      'ordId': targetChat['ordId'],
      // 'ordId': "2"
    };
    Map<String, Object> sendPayload = {
      "object": jsonEncode(msgData),
      "target": target
    };

    chatProvider.setSendMessage(sendPayload);
    // scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    log("======== render chat screen =============");
    return Scaffold(
        appBar: _buildAppBar(context),
        body: Container(
          child: Column(children: [
            Expanded(
              child: Container(
                child: Consumer<ChatProvider>(
                  builder: (context, data, child) {
                    chatList = data.getChatList2();
                    targetChat = getTargetChat(chatList, widget.msgId);
                    user = targetChat['uDetails'];
                    List messages = targetChat['msgs'];
                    // if (data.getScroll() || !data.getScroll()) scrollToBottom();
                    return ListView.builder(
                        reverse: true,
                        controller: _scrollController,
                        itemCount: data.getMsgCount() < messages.length
                            ? data.getMsgCount()
                            : messages.length,
                        itemBuilder: (BuildContext context, int index) {
                          Map rawMsgData = jsonDecode(
                              messages[(messages.length - 1) - index]);
                          String message = rawMsgData['msg'];
                          String sender = rawMsgData['sender'];

                          return Container(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: sender == "user"
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.end,
                              children: [
                                Container(
                                  constraints: new BoxConstraints(
                                      minHeight: 30,
                                      minWidth: 90,
                                      maxWidth: 130),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: sender == "user"
                                        ? Colors.grey[400]
                                        : Colors.blue,
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          message,
                                          softWrap: true,
                                          maxLines: 100,
                                        ),
                                      ),
                                      Container(
                                          alignment: Alignment.centerRight,
                                          child:
                                              Text(getTime(rawMsgData['time'])))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  },
                ),
              ),
            ),
            chatInputField(sendMessageHandler)
          ]),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {
            scrollToBottom();
            // _scrollController
            //     .jumpTo(_scrollController.position.maxScrollExtent);
          },
          child: Icon(
            Icons.arrow_downward,
            color: Colors.blue[900],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop);
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 3,
      actions: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Icon(
            Icons.phone,
            color: Colors.white,
          ),
        )
      ],
      title: Consumer<ChatProvider>(
        builder: (context, data, child) {
          chatList = data.getChatList2();
          targetChat = getTargetChat(chatList, widget.msgId);
          user = targetChat['uDetails'];
          return Row(
            children: [
              ProfilePic(
                name: user['name'],
                profile: user['pic'],
                status: false,
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: Text(
                  user['name'] ?? "Unknown",
                  maxLines: 1,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
