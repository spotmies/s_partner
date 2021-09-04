import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotmies_partner/apiCalls/apiInterMediaCalls/chatList.dart';
import 'package:spotmies_partner/chat/chat_list.dart';
import 'package:spotmies_partner/home/drawer%20and%20appBar/drawer.dart';
import 'package:spotmies_partner/orders/orders.dart';
import 'package:spotmies_partner/profile/profile.dart';
import 'package:spotmies_partner/providers/chat_provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:spotmies_partner/providers/universal_provider.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';

void main() => runApp(Home());

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  UniversalProvider universalProvider;
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
      universalProvider.setChatBadge();
    });
    socket.on("recieveReadReciept", (data) {
      chatProvider.chatReadReceipt(data['msgId'], data['status']);
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
    chatProvider = Provider.of<ChatProvider>(context, listen: false);
    universalProvider = Provider.of<UniversalProvider>(context, listen: false);
    getChatList();

    _chatResponse = StreamController();

    stream = _chatResponse.stream.asBroadcastStream();

    socketResponse();
    stream.listen((event) {
      chatProvider.addnewMessage(event);
    });

    chatProvider.addListener(() {
      log("event");
      var newMessageObject = chatProvider.newMessagetemp();
      var readReceiptsList = chatProvider.getReadReceipt();
      if (readReceiptsList.length > 0) {
        log("readReceipt evewnt");
        for (var item in readReceiptsList) {
          socket.emit("sendReadReciept", item);
        }

        chatProvider.setReadReceipt("clear");
      }
      if (chatProvider.getReadyToSend() == false) {
        log(chatProvider.getReadyToSend().toString());
        return;
      }

      if (newMessageObject.length > 0) {
        log("sending");
        chatProvider.setReadyToSend(false);
        for (int i = 0; i < newMessageObject.length; i++) {
          var item = newMessageObject[i];

          log("new msg $item");
          socket.emitWithAck('sendNewMessageCallback', item,
              ack: (var callback) {
            if (callback == 'success') {
              print('working Fine');
              if (i == newMessageObject.length - 1) {
                log("clear msg queue");
                var msgId = item['target']['msgId'];
                chatProvider.clearMessageQueue(msgId);
              }
              // chatProvider.addnewMessage(item);
            } else {
              log('notSuccess');
            }
          });
        }
        log("loop end");
      }
    });
    // chatProvider.confirmReceiveAllMessages();
  }

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

  List icons = [
    Icons.home,
    Icons.chat,
    Icons.home_repair_service,
    Icons.person
  ];

  List text = ['Home', 'Chat', 'Jobs', 'Learn'];

  @override
  Widget build(BuildContext context) {
    log("rendering >>>>>>>>");
    final width = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Consumer<UniversalProvider>(builder: (context, data, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            child: _widgetOptions.elementAt(data.getCurrentPage),
          ),
          bottomNavigationBar: Container(
            height: width * 0.163,
            child: AnimatedBottomNavigationBar.builder(
                elevation: 0,
                itemCount: icons.length,
                tabBuilder: (int index, bool isActive) {
                  final color = isActive ? Colors.grey[800] : Colors.grey;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Column(
                            children: [
                              Icon(
                                icons[index],
                                size: 24,
                                color: color,
                              ),
                              TextWid(
                                text: text[index],
                                color: color,
                              )
                            ],
                          ),
                          if (index == 1)
                            Positioned(
                                right: 0,
                                top: 0,
                                child: CircleAvatar(
                                  radius: 4,
                                  backgroundColor: data.getChatBadge
                                      ? Colors.indigo[800]
                                      : Colors.transparent,
                                ))
                        ],
                      ),
                    ],
                  );
                },
                backgroundColor: Colors.white,
                activeIndex: data.getCurrentPage,
                splashColor: Colors.grey[200],
                splashSpeedInMilliseconds: 300,
                notchSmoothness: NotchSmoothness.verySmoothEdge,
                gapLocation: GapLocation.none,
                leftCornerRadius: 32,
                rightCornerRadius: 32,
                onTap: (index) {
                  data.setCurrentPage(index);
                }),
          ),
        );
      }),
    );
  }
}
