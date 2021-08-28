import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:spotmies_partner/chat/chat_screen.dart';

import 'package:spotmies_partner/chat/personal_chat.dart';
import 'package:spotmies_partner/providers/chat_provider.dart';
import 'package:spotmies_partner/reusable_widgets/date_formates.dart';
import 'package:spotmies_partner/reusable_widgets/profile_pic.dart';

import 'package:spotmies_partner/reusable_widgets/text_wid.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  void initState() {
    super.initState();
    log("chatlist inti>>>>>>");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("appbar")),
      body: Container(child: RecentChats()),
    );
  }
}

class RecentChats extends StatefulWidget {
  @override
  _RecentChatsState createState() => _RecentChatsState();
}

class _RecentChatsState extends State<RecentChats> {
  ChatProvider chatProvider;
  @override
  void initState() {
    chatProvider = Provider.of<ChatProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('======render chatList screen =======');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5.0),
                topRight: Radius.circular(30.0),
              ),
              child: Consumer<ChatProvider>(
                builder: (context, data, child) {
                  List chatList = data.getChatList2();
                  // log(chatList[0].toString());
                  if (chatList.length < 1) {
                    return Center(
                        child: TextWid(
                      text: "No Chats Available",
                      size: 30,
                    ));
                  }
                  return ListView.builder(
                    itemCount: chatList?.length,
                    itemBuilder: (BuildContext context, int index) {
                      Map user = chatList[index]['uDetails'];
                      List messages = chatList[index]['msgs'];
                      int count = chatList[index]['pCount'];
                      log("count $count");

                      var lastMessage = jsonDecode(messages.last);

                      return ChatListCard(
                          user['pic'],
                          user['name'],
                          lastMessage['msg'].toString(),
                          getTime(lastMessage['time']),
                          chatList[index]['msgId'],
                          count);
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ChatListCard extends StatelessWidget {
  final String profile;
  final String name;
  final String lastMessage;
  final String time;
  final String msgId;
  final int count;
  const ChatListCard(this.profile, this.name, this.lastMessage, this.time,
      this.msgId, this.count);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        log(msgId);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PersonalChat(msgId.toString())));
        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) => ChatScreen(msgid: msgId.toString())));
      },
      child: Container(
        margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
        padding: EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: <Widget>[
                ProfilePic(profile: profile, name: name),
                SizedBox(
                  width: 15.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      name,
                      style: TextStyle(
                        color: Colors.grey[900],
                        fontSize: 15.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Text(
                        lastMessage,
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 15.0,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                count > 0
                    ? Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(30.0)),
                        alignment: Alignment.center,
                        child: Container(
                          child: Text(
                            count.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    : Container(
                        width: 40.0,
                        height: 20.0,
                      ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15.0,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}