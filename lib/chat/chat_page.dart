// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:spotmies_partner/apiCalls/apiInterMediaCalls/chatList.dart';
// import 'package:spotmies_partner/chat/chat_screen.dart';
// import 'package:spotmies_partner/localDB/localGet.dart';
// import 'package:spotmies_partner/profile/settings.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// class ChatHome extends StatefulWidget {
//   @override
//   _ChatHomeState createState() => _ChatHomeState();
// }

// class _ChatHomeState extends State<ChatHome> {
//   ScrollController _scrollController = ScrollController();

//   StreamController? _chatResponse;

//   Stream? stream;

//   IO.Socket? socket;

//   void socketResponse() {
//     socket = IO.io("https://spotmiesserver.herokuapp.com", <String, dynamic>{
//       "transports": ["websocket", "polling", "flashsocket"],
//       "autoConnect": false,
//     });
//     socket?.onConnect((data) {
//       print("Connected");
//       socket?.on("message", (msg) {
//         print(msg);
//       });
//     });
//     socket?.connect();
//     socket!.emit('join-room', FirebaseAuth.instance.currentUser?.uid);
//     socket?.on('recieveNewMessage', (socket) {
//       _chatResponse?.add(socket);
//     });
//   }

//   @override
//   void initState() {
//     // var chatData = Provider.of<ChattingProvider>(context, listen: false);
//     _chatResponse = StreamController();

//     stream = _chatResponse?.stream.asBroadcastStream();
//     // chatData.chatInfo(_chatResponse == null ? false : true);
//     socketResponse();
//     stream?.listen((event) {
//       log(event.toString());
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final _hight = MediaQuery.of(context).size.height -
//         MediaQuery.of(context).padding.top -
//         kToolbarHeight;
//     final _width = MediaQuery.of(context).size.width;
//     return Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           actions: [
//             IconButton(
//                 icon: Icon(
//                   Icons.person_pin_rounded,
//                   size: 27,
//                   color: Colors.blue[900],
//                 ),
//                 onPressed: () {
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => Setting()));
//                 })
//           ],
//           backgroundColor: Colors.white,
//           elevation: 0,
//           title: Text('Conversations',
//               style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold)),
//         ),
//         body: FutureBuilder(
//             future: localChatListGet(),
//             builder: (context, localChat) {
//               dynamic chatListLog = localChat.data;
//               if (localChat.data == null) {
//                 chattingList();
//               }
//               return StreamBuilder(
//                   stream: stream,
//                   builder: (context, chatSocket) {
//                     dynamic socketChatData = chatSocket.data;
//                     // log(chatSocket.data.toString());

//                     if (socketChatData != null) {
//                       if (socketChatData['msgId'] != null) {
//                         if (chatListLog.last['msgId'] !=
//                             socketChatData['msgId']) {
//                           WidgetsBinding.instance
//                               ?.addPostFrameCallback((_) async {
//                             final prefs = await SharedPreferences.getInstance();
//                             prefs.setString(
//                                 'chatListStore',
//                                 jsonEncode(List.from(chatListLog)
//                                   ..addAll([socketChatData])));
//                             setState(() {});
//                           });
//                         }
//                       }
//                     }
//                     return Container(
//                       height: _hight * 1,
//                       width: _width * 1,
//                       child: ListView.builder(
//                           itemCount: chatListLog.length,
//                           itemBuilder: (BuildContext ctxt, int index) {
//                             var user = chatListLog[index]['uDetails'];

//                             // var partner = chatListLog[index]['pDetails'];
//                             var c = chatListLog[index]['msgs'];
//                             // log(partner.toString());
//                             return Column(
//                               children: [
//                                 InkWell(
//                                   onTap: () {
//                                     print(chatListLog[index]['msgId']);
//                                     Navigator.of(context).push(
//                                         MaterialPageRoute(
//                                             builder: (context) => ChatScreen(
//                                                 msgid: chatListLog[index]
//                                                     ['msgId'])));
//                                   },
//                                   child: Container(
//                                     padding: EdgeInsets.all(10),
//                                     height: _hight * 0.14,
//                                     width: _width * 0.95,
//                                     decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         borderRadius:
//                                             BorderRadius.circular(20.0),
//                                         boxShadow: [
//                                           BoxShadow(
//                                               color: Colors.grey[300]!,
//                                               blurRadius: 2,
//                                               spreadRadius: 1,
//                                               offset: Offset(3, 3)),
//                                           BoxShadow(
//                                               color: Colors.grey[50]!,
//                                               blurRadius: 2,
//                                               spreadRadius: 2,
//                                               offset: Offset(-3, -3))
//                                         ]),
//                                     child: ListView.builder(
//                                         controller: _scrollController,
//                                         itemCount: 1,
//                                         itemBuilder:
//                                             (BuildContext ctxt, int index) {
//                                           String msgData = c.last;
//                                           var msg = jsonDecode(msgData);
//                                           return Row(
//                                             children: [
//                                               CircleAvatar(
//                                                 child: AspectRatio(
//                                                   aspectRatio: 400 / 400,
//                                                   child: ClipOval(
//                                                     child: user['pic'] == null
//                                                         ? Icon(
//                                                             Icons.person,
//                                                             color: Colors.black,
//                                                             size: 30,
//                                                           )
//                                                         : Image.network(
//                                                             user['pic']
//                                                                 .toString(),
//                                                             fit: BoxFit.cover,
//                                                             width:
//                                                                 MediaQuery.of(
//                                                                         context)
//                                                                     .size
//                                                                     .width,
//                                                           ),
//                                                   ),
//                                                 ),
//                                                 backgroundColor:
//                                                     Colors.grey[50],
//                                               ),
//                                               // SizedBox(
//                                               //   width: _width * 0.00,
//                                               // ),
//                                               Container(
//                                                 padding: EdgeInsets.only(
//                                                     left: _width * 0.04,
//                                                     right: _width * 0.04,
//                                                     top: _width * 0.02,
//                                                     bottom: _width * 0.02),
//                                                 width: _width * 0.69,
//                                                 height: _hight * 0.12,
//                                                 child: Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceBetween,
//                                                   children: [
//                                                     Column(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .spaceEvenly,
//                                                       crossAxisAlignment:
//                                                           CrossAxisAlignment
//                                                               .start,
//                                                       children: [
//                                                         Text(user['name'] ==
//                                                                 null
//                                                             ? 'User'
//                                                             : user['name']
//                                                                 .toString()),
//                                                         msg['type'] != 'text'
//                                                             ? Row(
//                                                                 children: [
//                                                                   Icon(
//                                                                       Icons
//                                                                           .image,
//                                                                       color: Colors
//                                                                               .grey[
//                                                                           500]),
//                                                                   Text(
//                                                                     'image',
//                                                                     style: TextStyle(
//                                                                         fontWeight:
//                                                                             FontWeight
//                                                                                 .bold,
//                                                                         color: Colors
//                                                                             .grey[500]),
//                                                                   ),
//                                                                 ],
//                                                               )
//                                                             : SizedBox(
//                                                                 width: _width *
//                                                                     0.3,
//                                                                 child: Text(
//                                                                   msg['msg'],
//                                                                   overflow:
//                                                                       TextOverflow
//                                                                           .ellipsis,
//                                                                   maxLines: 1,
//                                                                   softWrap:
//                                                                       false,
//                                                                   style: TextStyle(
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .bold,
//                                                                       color: Colors
//                                                                               .grey[
//                                                                           500]),
//                                                                 ),
//                                                               )
//                                                       ],
//                                                     ),
//                                                     Column(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .spaceEvenly,
//                                                       children: [
//                                                         Text(DateFormat.jm().format(
//                                                             DateTime.fromMillisecondsSinceEpoch(
//                                                                 (int.parse(msg[
//                                                                         'time']
//                                                                     .toString()))))),
//                                                         Container(
//                                                           child: chatListLog[
//                                                                           index]
//                                                                       [
//                                                                       'pCount'] >
//                                                                   0
//                                                               ? Container(
//                                                                   decoration: BoxDecoration(
//                                                                       color: Colors
//                                                                               .blue[
//                                                                           50],
//                                                                       borderRadius:
//                                                                           BorderRadius.circular(
//                                                                               15)),
//                                                                   height:
//                                                                       _hight *
//                                                                           0.03,
//                                                                   width:
//                                                                       _width *
//                                                                           0.17,
//                                                                   child: Center(
//                                                                     child: Text(
//                                                                       'Unread'
//                                                                           .toString(),
//                                                                       style: TextStyle(
//                                                                           color:
//                                                                               Colors.grey[800]),
//                                                                     ),
//                                                                   ),
//                                                                 )
//                                                               : Container(
//                                                                   decoration: BoxDecoration(
//                                                                       color: Colors
//                                                                               .blue[
//                                                                           50],
//                                                                       borderRadius:
//                                                                           BorderRadius.circular(
//                                                                               15)),
//                                                                   height:
//                                                                       _hight *
//                                                                           0.03,
//                                                                   width:
//                                                                       _width *
//                                                                           0.17,
//                                                                   child: Center(
//                                                                     child: Text(
//                                                                       'Read'
//                                                                           .toString(),
//                                                                       style: TextStyle(
//                                                                           color:
//                                                                               Colors.grey[500]),
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                         )
//                                                       ],
//                                                     )
//                                                   ],
//                                                 ),
//                                               )
//                                             ],
//                                           );
//                                         }),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//                               ],
//                             );
//                           }),
//                     );
//                   });
//             }));
//   }
// }
