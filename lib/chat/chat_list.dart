import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import 'package:provider/provider.dart';
import 'package:spotmies_partner/chat/personal_chat.dart';
import 'package:spotmies_partner/controllers/chat_controller.dart';
import 'package:spotmies_partner/providers/chat_provider.dart';
import 'package:spotmies_partner/providers/theme_provider.dart';
import 'package:spotmies_partner/reusable_widgets/date_formates.dart';
import 'package:spotmies_partner/reusable_widgets/profile_pic.dart';
import 'package:spotmies_partner/reusable_widgets/progressIndicator.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';
import 'package:spotmies_partner/utilities/app_config.dart';

// bool isCountHigh = true;

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends StateMVC<ChatList> {
  ChatController? _chatController = ChatController();

  ChatProvider? chatProvider;
  @override
  void initState() {
    chatProvider = Provider.of<ChatProvider>(context, listen: false);

    // chatProvider.setMsgId("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    print('======render chatList screen =======');
    return Scaffold(
      backgroundColor: SpotmiesTheme.background,
      key: _chatController?.scaffoldkey,
      appBar: AppBar(
          backgroundColor: SpotmiesTheme.background,
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
                color: SpotmiesTheme.background,
              ),
              child: ClipRRect(
                child: Consumer<ChatProvider>(
                  builder: (context, data, child) {
                    List chatList = data.getChatList2();
                    return RefreshIndicator(
                        onRefresh: () async {
                          await _chatController?.fetchNewChatList(
                              context, chatProvider!);
                        },
                        child: chatList.length > 0
                            ? ListView.builder(
                                itemCount: chatList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  Map<dynamic, dynamic>? user =
                                      chatList[index]['uDetails'];
                                  log('$chatList');
                                  List messages = chatList[index]['msgs'];
                                  // log('$messages');
                                  int count = chatList[index]['pCount'];

                                  var lastMessage = jsonDecode(messages.last);
                                  // log(lastMessage['type'].toString());

                                  return ChatListCard(
                                    user?['pic'],
                                    user?['name'],
                                    lastMessage['msg'].toString(),
                                    getTime(lastMessage['time']),
                                    chatList[index]['msgId'],
                                    count,
                                    lastMessage['type'],
                                    chatList[index]['uId'],
                                    chatList[index]['pId'],
                                    callBack: _chatController!.cardOnClick,
                                  );
                                },
                              )
                            : NoDataPlaceHolder(
                                height: _height,
                                width: _width,
                                title: "No Chats Available",
                              ));
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
      case 'img':
        return 'Image File';

      case 'video':
        return 'Video File';
      case 'audio':
        return 'Audio File';
      default:
        return 'Unknown';
    }
  } else {
    switch (type) {
      case 'text':
        return Icons.textsms;
      case 'img':
        return Icons.image;
      case 'video':
        return Icons.slow_motion_video;
      case 'audio':
        return Icons.mic;
      default:
        return Icons.connect_without_contact;
    }
  }
}

class ChatListCard extends StatefulWidget {
  final String? profile;
  final String? name;
  final String? lastMessage;
  final String? time;
  final String? msgId;
  final int? count;
  final Function? callBack;
  final String? type;
  final String? uId;
  final String? pId;
  const ChatListCard(this.profile, this.name, this.lastMessage, this.time,
      this.msgId, this.count, this.type, this.uId, this.pId,
      {this.callBack});

  @override
  _ChatListCardState createState() => _ChatListCardState();
}

class _ChatListCardState extends State<ChatListCard> {
  ChatProvider? chatProvider;
  @override
  void initState() {
    chatProvider = Provider.of<ChatProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log("173" + widget.name.toString());
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
          widget.callBack!(
              widget.msgId, widget.msgId, readReceiptobject, chatProvider);
          //navigate strore msg count value

          final count = await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PersonalChat(widget.msgId.toString())));
          log("fback $count");

          widget.callBack!(widget.msgId, "", "", chatProvider);
        },
        title: TextWid(
            text: widget.name != null
                ? toBeginningOfSentenceCase(widget.name).toString()
                : 'Unkown',
            size: _width * 0.045,
            weight: FontWeight.w600,
            color: widget.count! > 0
                ? SpotmiesTheme.onBackground
                : SpotmiesTheme.secondary),
        subtitle: Row(
          children: [
            Icon(
              typeofLastMessage(widget.type, widget.lastMessage, 'icon'),
              size: 12,
              color: widget.count! > 0
                  ? SpotmiesTheme.onBackground
                  : Colors.grey[500],
            ),
            SizedBox(
              width: 3,
            ),
            Container(
              width: _width * 0.47,
              child: TextWid(
                  text: toBeginningOfSentenceCase(
                    typeofLastMessage(widget.type, widget.lastMessage, 'text'),
                  ).toString(),
                  size: _width * 0.035,
                  flow: TextOverflow.ellipsis,
                  weight: widget.count! > 0 ? FontWeight.w600 : FontWeight.w500,
                  color: widget.count! > 0
                      ? SpotmiesTheme.title
                      : Colors.grey[500]!),
            ),
          ],
        ),
        leading: widget.name != null
            ? ProfilePic(
                badge: true,
                profile: widget.profile,
                name: widget.name,
              )
            : CircleAvatar(
                radius: width(context) * 0.07, child: Icon(Icons.person)),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextWid(
                text: widget.time!,
                size: _width * 0.035,
                weight: FontWeight.w600,
                color: widget.count! > 0
                    ? SpotmiesTheme.onBackground
                    : SpotmiesTheme.secondary),
            SizedBox(
              height: 10,
            ),
            widget.count! > 0
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
                          color: SpotmiesTheme.title),
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
