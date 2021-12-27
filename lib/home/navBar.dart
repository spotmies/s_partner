import 'dart:developer';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotmies_partner/apiCalls/apiInterMediaCalls/chatList.dart';
import 'package:spotmies_partner/apiCalls/apiInterMediaCalls/faqList.dart';
import 'package:spotmies_partner/apiCalls/apiInterMediaCalls/partnerDetailsAPI.dart';
import 'package:spotmies_partner/chat/chat_list.dart';
import 'package:spotmies_partner/controllers/login_controller.dart';
import 'package:spotmies_partner/home/home.dart';
import 'package:spotmies_partner/internet_calling/calling.dart';
import 'package:spotmies_partner/login/onboard.dart';
import 'package:spotmies_partner/orders/orders.dart';
import 'package:spotmies_partner/profile/profile.dart';
import 'package:spotmies_partner/providers/chat_provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:spotmies_partner/providers/partnerDetailsProvider.dart';
import 'package:spotmies_partner/reusable_widgets/notifications.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';
import 'package:spotmies_partner/utilities/shared_preference.dart';
import 'package:spotmies_partner/utilities/snackbar.dart';
import 'package:spotmies_partner/utilities/tutorial_category/tutorial_category.dart';

void main() => runApp(NavBar());
String pId = "123456"; //user id

class NavBar extends StatefulWidget {
  final int data;
  final String payload;
  NavBar({this.data, this.payload});
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  ChatProvider chatProvider;
  PartnerDetailsProvider partnerProvider;
//socket

  // StreamController _chatResponse;

  // Stream stream;

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
      var typeCheck = socket['target']['type'];
      if (typeCheck == "call") {
        log("======== incoming call ===========");
        chatProvider.startCallTimeout();
        var newTarget = socket['target'];
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MyCalling(
                  uId: newTarget['uId'],
                  pId: newTarget['pId'],
                  msgId: newTarget['msgId'],
                  ordId: newTarget['ordId'],
                  isIncoming: true,
                  roomId: newTarget['roomId'],
                  name: newTarget['incomingName'],
                  profile: newTarget['incomingProfile'],
                )));
      }
      // _chatResponse.add(socket);
      chatProvider.addnewMessage(socket);
    });
    socket.on("recieveReadReciept", (data) {
      chatProvider.chatReadReceipt(data['msgId'], data['status']);
    });
    socket.on('inComingOrders', (socket) {
      socket['action'] == "new"
          ? partnerProvider.addNewIncomingOrder(socket['payload'])
          : partnerProvider.refressIncomingOrder(true);
      log("incoming ord $socket");
    });
    socket.on("chatStream", (socket) async {
      if (socket['type'] == "insert") {
        var newChat = await getChatByIdFromDB(socket['doc']['msgId']);
        chatProvider.addNewChat(newChat);
      } else if (socket['type'] == "disable") {
        log("disable chat $socket");
        chatProvider.disableChatByMsgId(socket['msgId']);
      }
    });
  }

  retriveDataFromSF() async {
    dynamic user = await getMyProfile();
    dynamic chats = await getChats();
    dynamic orders = await getOrders();
    log("chat $chats");
    log("user $user");
    log("order $orders");
    if (chats != null) chatProvider.setChatList(chats);
    if (orders != null) partnerProvider.setOrder(orders);
    if (user != null) partnerProvider.setPartnerDetails(user);
  }

  loginPartner() async {
    if (FirebaseAuth.instance.currentUser != null) {
      String resp =
          await checkPartnerRegistered(FirebaseAuth.instance.currentUser.uid);
      if (resp == "true") {
        partnerProvider.setCurrentPid(FirebaseAuth.instance.currentUser.uid);
        log("login succssfully");
      } else if (resp == "false") {
        FirebaseAuth.instance.signOut().then((value) => {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => OnboardingScreen()),
                  (route) => false)
            });
      } else
        snackbar(context, "something went wrong");
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => OnboardingScreen()),
          (route) => false);
    }
  }

  //socket
  hittingAllApis(currentPid) async {
    log("pid is >>>>>>>>> $pId");
    await loginPartner();

    dynamic details = await partnerDetailsFull(currentPid);

    if (details != null) {
      partnerProvider.setPartnerDetails(details);
      if (details['appConfig'] == true) {
        partnerProvider.getServiceListFromServer();
        partnerProvider.getConstants(alwaysHit: false);
      }
    }
    dynamic chatList = await getChatListFromDb(currentPid);

    if (chatList != null) chatProvider.setChatList(chatList);

    dynamic partnerOrders = await partnerAllOrders(currentPid);

    if (partnerOrders != null) partnerProvider.setOrder(partnerOrders);

    log("hitting all api completed");
  }

  connectNotifications() async {
    log("devic id ${await FirebaseMessaging.instance.getToken()}");
    await FirebaseMessaging.instance.subscribeToTopic("spotmiesPartner");
  }

  @override
  initState() {
    pId = FirebaseAuth.instance.currentUser.uid.toString();

    chatProvider = Provider.of<ChatProvider>(context, listen: false);
    partnerProvider =
        Provider.of<PartnerDetailsProvider>(context, listen: false);
    retriveDataFromSF();
    // notifications();
    awesomeInitilize();
    // displayAwesomeNotification();
    notificationPermmision(context);
    // AwesomeNotifications().createdStream.listen((notification) {
    //   snackbar(context, 'notification ${notification.channelKey}');
    // });
    // AwesomeNotifications().actionStream.listen((notification) {
    //   if (notification.channelKey == 'firebasePushNotifictions') {
    //     AwesomeNotifications().getGlobalBadgeCounter().then(
    //         (value) => AwesomeNotifications().setGlobalBadgeCounter(value - 1));
    //   }
    // });
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      final routefromMessage = message?.data["route"];
      log(routefromMessage);
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => NavBar()), (route) => false);
    });
    //forground
    FirebaseMessaging.onMessage.listen((message) async {
      if (message.notification != null) {
        log(message.notification.title);
        log(message.notification.body);
        await displayAwesomeNotification(message, context);
      }
    });
    // when app background but in recent
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      log('Recent');
      final routefromMessage = message.data["route"];
      log(routefromMessage);
      await displayAwesomeNotification(message, context);
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => NavBar()), (route) => false);
    });

    log("current pid ${partnerProvider.currentPid}");
    connectNotifications();

    socketResponse();
    hittingAllApis(partnerProvider.currentPid.toString());

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
                var msgId = item['target']['msgId'];
                log("clear msg queue $msgId");
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
    super.initState();
    // chatProvider.confirmReceiveAllMessages();
  }

  @override
  void dispose() {
    AwesomeNotifications().actionSink.close();
    AwesomeNotifications().createdSink.close();
    super.dispose();
  }

  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    Center(
      child: Home(),
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
      child: TutCategory(),
      // child: Profile(),
    ),
  ];

  static List<Widget> shortCut = [
    Center(
      child: Home(),
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

  setBottomBarIndex(index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Consumer<ChatProvider>(builder: (context, notifier, child) {
          return Container(
            child: widget.data == null
                ? _widgetOptions.elementAt(_selectedIndex)
                : shortCut.elementAt(widget.data),
          );
        }),
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
                        Consumer<ChatProvider>(builder: (context, data, child) {
                          List chatList = data.getChatList2();
                          int count =
                              chatList.isEmpty ? 0 : chatList[0]['pCount'];

                          return Positioned(
                              right: 0,
                              top: 0,
                              child: CircleAvatar(
                                radius: 4,
                                backgroundColor: count == 0
                                    ? Colors.transparent
                                    : Colors.greenAccent,
                              ));
                        })
                    ],
                  ),
                ],
              );
            },
            backgroundColor: Colors.white,
            activeIndex: _selectedIndex,
            splashColor: Colors.grey[200],
            splashSpeedInMilliseconds: 300,
            notchSmoothness: NotchSmoothness.verySmoothEdge,
            gapLocation: GapLocation.none,
            leftCornerRadius: 32,
            rightCornerRadius: 32,
            onTap: (index) => setState(() => _selectedIndex = index),
          ),
        ),
      ),
    );
  }
}
