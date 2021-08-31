import 'dart:async';
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
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';

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
    Timer(
        Duration(milliseconds: 200),
        () => _scrollController
            .jumpTo(_scrollController.position.minScrollExtent));
  }

  @override
  void initState() {
    super.initState();
    chatProvider = Provider.of<ChatProvider>(context, listen: false);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // log("at top >>>");
        chatProvider.setMsgCount(chatProvider.getMsgCount() + 20);
      }
      if (_scrollController.position.pixels < 40) {
        // log('disable float >>>>>>>>>>>>');
        if (chatProvider.getFloat()) chatProvider.setFloat(false);
      } else if (_scrollController.position.pixels > 40) {
        if (!chatProvider.getFloat()) {
          chatProvider.setFloat(true);
          // log('en float >>>>>>>>>>>>');
        }
      }
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
    chatProvider.addnewMessage(sendPayload);
    chatProvider.setSendMessage(sendPayload);
    // scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    log("======== render chat screen =============");
    final _hight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: _buildAppBar(context, _hight, _width),
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
                          String type = rawMsgData['type'];

                          return Container(
                            padding: EdgeInsets.only(
                                left: sender == "user" ? 10 : 0,
                                bottom: 5,
                                right: sender == "user" ? 0 : 10),
                            child: Row(
                              mainAxisAlignment: sender == "user"
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      constraints: BoxConstraints(
                                          minHeight: _hight * 0.05,
                                          minWidth: 30,
                                          maxWidth: _width * 0.55),
                                      decoration: BoxDecoration(
                                          color: sender == "user"
                                              ? Colors.white
                                              : Colors.blueGrey[500],
                                          border: Border.all(
                                              color: Colors.blueGrey[500],
                                              width: 0.3),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15),
                                              bottomRight: Radius.circular(
                                                  sender == "user" ? 15 : 0),
                                              bottomLeft: Radius.circular(
                                                  sender != "user" ? 15 : 0))),
                                      child: Column(
                                        children: [
                                          Container(
                                              padding: EdgeInsets.only(
                                                  left: 10, top: 10, right: 10),
                                              alignment: Alignment.centerLeft,
                                              child: type == "text"
                                                  ? TextWid(
                                                      text:
                                                          toBeginningOfSentenceCase(
                                                              message),
                                                      maxlines: 200,
                                                      lSpace: 1.5,
                                                      color: sender != "user"
                                                          ? Colors.white
                                                          : Colors.grey[900],
                                                    )
                                                  : type != "audio"
                                                      ? Image.network(message)
                                                      : type != "video"
                                                          ? Text('audio')
                                                          : Text('video')),
                                          Container(
                                            padding: EdgeInsets.only(
                                                right: 10, top: 5),
                                            alignment: Alignment.centerRight,
                                            child: TextWid(
                                              text: getTime(rawMsgData['time']),
                                              size: _width * 0.03,
                                              color: sender != "user"
                                                  ? Colors.grey[50]
                                                  : Colors.grey[500],
                                              weight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Visibility(
                                      visible:
                                          index == 0 && sender == "partner",
                                      child: readReciept(
                                          _width, targetChat['pState']),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          );
                        });
                  },
                ),
              ),
            ),
            chatInputField(sendMessageHandler, context, _hight, _width)
          ]),
        ),
        floatingActionButton: Container(
          height: _hight * 0.2,
          padding: EdgeInsets.only(bottom: _hight * 0.1),
          child: Consumer<ChatProvider>(
            builder: (context, data, child) {
              return data.getFloat()
                  ? FloatingActionButton(
                      elevation: 0,
                      mini: true,
                      backgroundColor: Colors.white,
                      onPressed: () {
                        scrollToBottom();

                        // _scrollController
                        //     .jumpTo(_scrollController.position.maxScrollExtent);
                      },
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.blue[900],
                        size: _width * 0.07,
                      ),
                    )
                  : Container();
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat);
  }

  Container readReciept(double _width, status) {
    getIcon() {
      switch (status) {
        case 0:
          return Icons.watch_later;
        case 1:
          return Icons.done;
        case 2:
          return Icons.watch_later;

          break;
        default:
          return Icons.done;
      }
    }

    return Container(
        padding: EdgeInsets.only(right: 5),
        alignment: Alignment.centerRight,
        child: Icon(
          getIcon(),
          // Icons.done,
          // Icons.done_all,
          // Icons.watch_later,
          color: Colors.grey[400],
          size: _width * 0.05,
        ));
  }

  Widget _buildAppBar(BuildContext context, double hight, double width) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.grey[50],
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          )),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.read_more,
            color: Colors.grey[900],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.phone,
            color: Colors.grey[900],
          ),
        ),
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
                bgColor: Colors.blueGrey[600],
                size: width * 0.045,
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                  child: TextWid(
                text: user['name'] ?? "Spotmies User",
                size: width * 0.058,
                weight: FontWeight.w600,
              )
                  // Text(
                  //   user['name'] ?? "Unknown",
                  //   maxLines: 1,
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.w600,
                  //   ),
                  // ),
                  ),
            ],
          );
        },
      ),
    );
  }
}
