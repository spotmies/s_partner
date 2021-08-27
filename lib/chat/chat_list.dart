import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spotmies_partner/chat/chat_screen.dart';
import 'package:spotmies_partner/chat/personal_chat.dart';
import 'package:spotmies_partner/providers/chat_provider.dart';
import 'package:spotmies_partner/reusable_widgets/chat_input_field.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';

class ChatList extends StatefulWidget {
  final dynamic socket;
  ChatList(this.socket);
  @override
  _ChatListState createState() => _ChatListState(socket);
}

class _ChatListState extends State<ChatList> {
  ChatProvider chatProvider;
  var socket;
  _ChatListState(socket);
  @override
  void initState() {
    super.initState();
    // var msgData = {
    //   'msg': "textInput",
    //   'time': "1625338441313",
    //   'sender': 'partner',
    //   'type': 'text'
    // };
    // var target = {
    //   'uId': "FtaZm2dasvN7cL9UumTG98ksk6I3",
    //   'pId': FirebaseAuth.instance.currentUser.uid,
    //   'msgId': "1621909636273",
    //   'ordId': "123",
    // };
    // String temp = jsonEncode(msgData);
    // log(widget.socket.toString());
    // widget.socket.emitWithAck(
    //     'sendNewMessageCallback', {"object": temp, "target": target},
    //     ack: (var callback) {
    //   if (callback == 'success') {
    //     print('working Fine');
    //   } else {
    //     log('notSuccess');
    //   }
    // });
  }

  @override
  void didChangeDependencies() {
    chatProvider = Provider.of<ChatProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    List chatList = Provider.of<ChatProvider>(context).getChatList;
    print(chatList);
    return Scaffold(
      appBar: AppBar(title: Text("appbar")),
      body: Container(
        child: chatList != null
            ? RecentChats(chatList)
            : CircularProgressIndicator(),
      ),
    );
  }
}

class RecentChats extends StatefulWidget {
  final List chatList;
  const RecentChats(this.chatList);

  @override
  _RecentChatsState createState() => _RecentChatsState();
}

class _RecentChatsState extends State<RecentChats> {
  @override
  Widget build(BuildContext context) {
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
              child: ListView.builder(
                itemCount: widget.chatList?.length,
                itemBuilder: (BuildContext context, int index) {
                  Map user = widget.chatList[index]['uDetails'];
                  List messages = widget.chatList[index]['msgs'];

                  var lastMessage = jsonDecode(messages.last);

                  return ChatListCard(
                      user['pic'],
                      user['name'],
                      lastMessage['msg'].toString(),
                      DateFormat.jm().format(
                          DateTime.fromMillisecondsSinceEpoch(
                              (int.parse(lastMessage['time'].toString())))),
                      widget.chatList[index]['msgId']);
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
  const ChatListCard(
      this.profile, this.name, this.lastMessage, this.time, this.msgId);

  Widget _activeIcon(isActive) {
    if (isActive) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.all(3),
          width: 16,
          height: 16,
          color: Colors.white,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              color: Color(0xff43ce7d), // flat green
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        log(msgId);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PersonalChat(msgId.toString())));
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
                profilePic(),
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
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15.0,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 40.0,
                  height: 20.0,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(30.0)),
                  alignment: Alignment.center,
                  child: Text(
                    'New',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Container profilePic() {
    return Container(
      child: profile != null
          ? Stack(
              children: [
                CircleAvatar(
                  radius: 25.0,
                  backgroundImage: NetworkImage(profile ?? ""),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: _activeIcon(true),
                ),
              ],
            )
          : Stack(
              children: [
                CircleAvatar(
                  radius: 25.0,
                  child: Center(
                    child: TextWid(
                      text: name[0],
                      size: 30.0,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: _activeIcon(true),
                ),
              ],
            ),
    );
  }
}
