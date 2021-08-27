import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spotmies_partner/providers/chat_provider.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  ChatProvider chatProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    chatProvider = Provider.of<ChatProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    List chatList = Provider.of<ChatProvider>(context).getChatList;
    return Scaffold(
      appBar: AppBar(title: Text("appbar")),
      body: Container(
        child: RecentChats(chatList),
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
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5.0),
                topRight: Radius.circular(30.0),
              ),
              child: ListView.builder(
                itemCount: widget.chatList.length,
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
                              (int.parse(lastMessage['time'].toString())))));
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
  const ChatListCard(this.profile, this.name, this.lastMessage, this.time);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () => Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (_) => ChatScreen(user: chat.sender),
      //     )),
      child: Container(
        margin: EdgeInsets.only(
          top: 5.0,
          bottom: 5.0,
          right: 20.0,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0,
        ),
        decoration: BoxDecoration(
          color: true ? Color(0xFFf2e6fa) : Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  child: profile != null
                      ? CircleAvatar(
                          radius: 25.0,
                          backgroundImage: NetworkImage(profile ?? ""),
                        )
                      : CircleAvatar(
                          radius: 25.0,
                          child: Center(
                            child: TextWid(
                              text: name[0],
                              size: 30.0,
                            ),
                          ),
                          // backgroundImage: NetworkImage(profile ?? ""),
                        ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      name,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Text(
                        lastMessage,
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Text(
                  time,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5.0,
                ),
                true
                    ? Container(
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
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    : Text('')
              ],
            )
          ],
        ),
      ),
    );
  }
}
