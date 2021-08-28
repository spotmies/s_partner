import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spotmies_partner/reusable_widgets/chat_input_field.dart';
import 'package:provider/provider.dart';
import 'package:spotmies_partner/providers/chat_provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

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
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    chatProvider = Provider.of<ChatProvider>(context, listen: false);
    log("new change");
    Timer(
        Duration(milliseconds: 600),
        () => _scrollController
            .jumpTo(_scrollController.position.maxScrollExtent));
    super.didChangeDependencies();
  }

  getTargetChat(list, msgId) {
    // print(list.length);
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
      'pId': FirebaseAuth.instance.currentUser.uid,
      'msgId': widget.msgId,
      'ordId': targetChat['ordId'],
    };
    Map<String, Object> sendPayload = {
      "object": jsonEncode(msgData),
      "target": target
    };

    chatProvider.setSendMessage(sendPayload);
  }

  @override
  Widget build(BuildContext context) {
    chatList = Provider.of<ChatProvider>(context).getChatList;
    targetChat = getTargetChat(chatList, widget.msgId);
    user = targetChat['uDetails'];
    List messages = targetChat['msgs'];
    // print(messages);
    return Scaffold(
        appBar: _buildAppBar(context, user['pic'], user['name']),
        body: Container(
          child: Column(children: [
            Expanded(
              child: Container(
                child: ListView.builder(
                    controller: _scrollController,
                    itemCount: messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      Map rawMsgData = jsonDecode(messages[index]);
                      String message = rawMsgData['msg'];
                      String sender = rawMsgData['sender'];

                      String time = DateFormat.jm().format(
                          DateTime.fromMillisecondsSinceEpoch(
                              (int.parse(rawMsgData['time'].toString()))));

                      return Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: sender == "user"
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.end,
                          children: [
                            Container(
                              constraints: new BoxConstraints(
                                  minHeight: 30, minWidth: 90, maxWidth: 130),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.amber,
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  message,
                                  softWrap: true,
                                  maxLines: 100,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            ),
            chatInputField(sendMessageHandler)
          ]),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {
            _scrollController
                .jumpTo(_scrollController.position.maxScrollExtent);
          },
          child: Icon(
            Icons.arrow_downward,
            color: Colors.blue[900],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop);
  }

  Widget _buildAppBar(BuildContext context, profile, name) {
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
      title: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(profile ?? ""),
                radius: 20,
              ),
              Positioned(
                bottom: 2,
                right: 0,
                child: CircleAvatar(
                  radius: 4,
                  backgroundColor: true ? Colors.green : Colors.transparent,
                ),
              )
            ],
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: Text(
              name ?? "Unknown",
              maxLines: 1,
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
