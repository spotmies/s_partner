import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import 'package:provider/provider.dart';
import 'package:spotmies_partner/chat/personal_chat.dart';
import 'package:spotmies_partner/controllers/chat_controller.dart';
import 'package:spotmies_partner/providers/chat_provider.dart';
import 'package:spotmies_partner/reusable_widgets/date_formates.dart';
import 'package:spotmies_partner/reusable_widgets/profile_pic.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';

// bool isCountHigh = true;

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends StateMVC<ChatList> {
  ChatController _chatController;
  _ChatListState() : super(ChatController()) {
    this._chatController = controller;
  }
  ChatProvider chatProvider;
  @override
  void initState() {
    chatProvider = Provider.of<ChatProvider>(context, listen: false);

    // chatProvider.setMsgId("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    print('======render chatList screen =======');
    return Scaffold(
      key: _chatController.scaffoldkey,
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: TextWid(
            text: 'My Conversations',
            size: _width * 0.045,
            weight: FontWeight.w600,
          )),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: ClipRRect(
                child: Consumer<ChatProvider>(
                  builder: (context, data, child) {
                    List chatList = data.getChatList2();

                    // log(chatList[0].toString());
                    if (chatList.length < 1) {
                      return Center(
                          child: TextWid(
                        text: "No Chats Available",
                        size: 18,
                      ));
                    }
                    return RefreshIndicator(
                      onRefresh: _chatController.fetchNewChatList,
                      child: ListView.builder(
                        itemCount: chatList?.length,
                        itemBuilder: (BuildContext context, int index) {
                          Map user = chatList[index]['uDetails'];
                          List messages = chatList[index]['msgs'];
                          int count = chatList[index]['pCount'];

                          // log("count $count");

                          var lastMessage = jsonDecode(messages.last);
                          // log(lastMessage['type'].toString());

                          return ChatListCard(
                            user['pic'],
                            user['name'],
                            lastMessage['msg'].toString(),
                            getTime(lastMessage['time']),
                            chatList[index]['msgId'],
                            count,
                            lastMessage['type'],
                            chatList[index]['uId'],
                            chatList[index]['pId'],
                            callBack: _chatController.cardOnClick,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

typeofLastMessage(type, lastMessage, data) {
  if (data != 'icon') {
    switch (type) {
      case 'text':
        return lastMessage;
        break;
      case 'img':
        return 'Image File';
        break;
      case 'video':
        return 'Video File';
        break;
      case 'audio':
        return 'Audio File';
        break;
      default:
        return 'Unknown';
    }
  } else {
    switch (type) {
      case 'text':
        return Icons.textsms;
        break;
      case 'img':
        return Icons.image;
        break;
      case 'video':
        return Icons.slow_motion_video;
        break;
      case 'audio':
        return Icons.mic;
        break;
      default:
        return Icons.connect_without_contact;
    }
  }
}

class ChatListCard extends StatefulWidget {
  final String profile;
  final String name;
  final String lastMessage;
  final String time;
  final String msgId;
  final int count;
  final Function callBack;
  final String type;
  final String uId;
  final String pId;
  const ChatListCard(this.profile, this.name, this.lastMessage, this.time,
      this.msgId, this.count, this.type, this.uId, this.pId,
      {this.callBack});

  @override
  _ChatListCardState createState() => _ChatListCardState();
}

class _ChatListCardState extends State<ChatListCard> {
  @override
  Widget build(BuildContext context) {
    // final _hight = MediaQuery.of(context).size.height -
    //     MediaQuery.of(context).padding.top -
    //     kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;
    return ListTile(
        onTap: () async {
          Map readReceiptobject = {
            "uId": widget.uId,
            "pId": widget.pId,
            "msgId": widget.msgId,
            "sender": "partner",
            "status": 3
          };
          widget.callBack(widget.msgId, widget.msgId, readReceiptobject);
          //navigate strore msg count value

          final count = await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PersonalChat(widget.msgId.toString())));
          log("fback $count");

          widget.callBack(widget.msgId, "", "");
        },
        title: TextWid(
            text: toBeginningOfSentenceCase(widget.name),
            size: _width * 0.045,
            weight: FontWeight.w600,
            color: widget.count > 0 ? Colors.black : Colors.grey[700]),
        subtitle: Row(
          children: [
            Icon(
              typeofLastMessage(widget.type, widget.lastMessage, 'icon'),
              size: 12,
              color: widget.count > 0 ? Colors.black : Colors.grey[500],
            ),
            SizedBox(
              width: 3,
            ),
            Container(
              width: _width * 0.47,
              child: TextWid(
                  text: toBeginningOfSentenceCase(
                    typeofLastMessage(widget.type, widget.lastMessage, 'text'),
                  ),
                  size: _width * 0.035,
                  flow: TextOverflow.ellipsis,
                  weight: widget.count > 0 ? FontWeight.w600 : FontWeight.w500,
                  color: widget.count > 0
                      ? Colors.blueGrey[600]
                      : Colors.grey[500]),
            ),
          ],
        ),
        leading: ProfilePic(
          badge: true,
          profile: widget.profile,
          name: widget.name,
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextWid(
                text: widget.time,
                size: _width * 0.035,
                weight: FontWeight.w600,
                color: widget.count > 0 ? Colors.black : Colors.grey[700]),
            SizedBox(
              height: 10,
            ),
            widget.count > 0
                ? Container(
                    width: _width * 0.1,
                    height: _width * 0.055,
                    margin: EdgeInsets.only(right: _width * 0.035),
                    decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        borderRadius: BorderRadius.circular(30.0)),
                    alignment: Alignment.center,
                    child: Center(
                      child: TextWid(
                          text: widget.count.toString(),
                          size: _width * 0.03,
                          weight: FontWeight.w900,
                          color: Colors.blueGrey[700]),
                    ),
                  )
                : Container(
                    width: 40.0,
                    height: 20.0,
                  ),
          ],
        ));
  }
}
