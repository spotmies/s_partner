import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:spotmies_partner/apiCalls/apiInterMediaCalls/chatList.dart';
import 'package:spotmies_partner/chat/chat_list.dart';
import 'package:spotmies_partner/chat/chat_page.dart';
import 'package:spotmies_partner/home/drawer%20and%20appBar/drawer.dart';
import 'package:spotmies_partner/orders/orders.dart';
import 'package:spotmies_partner/providers/chat_provider.dart';
import 'package:spotmies_partner/utilities/tutorial_category/tutorial_category.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() => runApp(Home());

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ChatProvider chatProvider;
//socket

  StreamController _chatResponse;

  Stream stream;

  IO.Socket socket;

  void socketResponse() {
    socket = IO.io("https://spotmiesserver.herokuapp.com", <String, dynamic>{
      "transports": ["websocket", "polling", "flashsocket"],
      "autoConnect": false,
    });
    socket.onConnect((data) {
      print("Connected");
      socket.on("message", (msg) {
        print(msg);
      });
    });
    socket.connect();
    socket.emit('join-room', FirebaseAuth.instance.currentUser.uid);
    socket.on('recieveNewMessage', (socket) {
      _chatResponse.add(socket);
    });
  }

  //socket
  getChatList() async {
    var chatList = await getChatListFromDb();
    print('chatlist $chatList ');
    chatProvider.setChatList(chatList);
  }

  @override
  void initState() {
    super.initState();
    getChatList();
    // var chatData = Provider.of<ChattingProvider>(context, listen: false);
    _chatResponse = StreamController();

    stream = _chatResponse.stream.asBroadcastStream();
    // chatData.chatInfo(_chatResponse == null ? false : true);
    socketResponse();
    stream.listen((event) {
      chatProvider.addnewMessage(event);
      // var newEvent = jsonEncode(event['object']);
      // log("event >>>>>> ${newEvent.toString()}");
    });
  }

  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    Center(
      child: HomePage(),
    ),
    Center(
      child: ChatList(),
      // child: ChatHome(),
    ),
    Center(
      child: Orders(),
    ),
    Center(
      // child: Profile(),
      child: TutCategory(),
    ),
  ];
  @override
  void didChangeDependencies() {
    chatProvider = Provider.of<ChatProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Consumer<ChatProvider>(builder: (context, notifier, child) {
          return Container(
            child: _widgetOptions.elementAt(_selectedIndex),
          );
        }),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(blurRadius: 5, color: Colors.black.withOpacity(0)),
          ]),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: GNav(
                  gap: 8,
                  activeColor: Colors.grey[800],
                  iconSize: 24,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  duration: Duration(milliseconds: 2),
                  tabBackgroundColor: Colors.white,
                  tabs: [
                    GButton(
                      icon: Icons.home,
                      text: 'Home',
                      iconColor: Colors.grey,
                    ),
                    GButton(
                      icon: Icons.chat_bubble_rounded,
                      text: 'Chat',
                      iconColor: Colors.grey,
                    ),
                    GButton(
                      icon: Icons.home_repair_service_rounded,
                      text: 'Orders',
                      iconColor: Colors.grey,
                    ),
                    GButton(
                      icon: Icons.explore,
                      text: 'Explore',
                      iconColor: Colors.grey,
                    ),
                  ],
                  selectedIndex: _selectedIndex,
                  onTabChange: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
