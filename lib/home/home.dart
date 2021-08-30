import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:spotmies_partner/apiCalls/apiInterMediaCalls/chatList.dart';
import 'package:spotmies_partner/chat/chat_list.dart';
import 'package:spotmies_partner/home/drawer%20and%20appBar/drawer.dart';
import 'package:spotmies_partner/orders/orders.dart';
import 'package:spotmies_partner/profile/profile.dart';
import 'package:spotmies_partner/providers/chat_provider.dart';
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
  initState() {
    super.initState();

    getChatList();

    _chatResponse = StreamController();

    stream = _chatResponse.stream.asBroadcastStream();

    socketResponse();
    stream.listen((event) {
      chatProvider.addnewMessage(event);
    });

    chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.addListener(() {
      var newMessageObject = chatProvider.newMessagetemp();
      if (!newMessageObject.isEmpty) {
        log("new msg $newMessageObject");
        socket.emitWithAck('sendNewMessageCallback', newMessageObject,
            ack: (var callback) {
          if (callback == 'success') {
            print('working Fine');
            chatProvider.setSendMessage({});
            chatProvider.addnewMessage(newMessageObject);
          } else {
            log('notSuccess');
          }
        });
      }
    });
  }

  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    Center(
      child: HomePage(),
    ),
    Center(
        // child: ChatList(IO.socket socket),
        child: ChatList()
        // child: ChatHome(),
        ),
    Center(
      child: Orders(),
    ),
    Center(
      // child: Profile(),
      child: Profile(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    log("rendering >>>>>>>>");
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
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 7.3),
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
