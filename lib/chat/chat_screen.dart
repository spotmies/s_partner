// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:mvc_pattern/mvc_pattern.dart';
// import 'package:spotmies_partner/apiCalls/apiInterMediaCalls/chatList.dart';
// import 'package:spotmies_partner/localDB/localGet.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// date(msg1, msg2) {
//   var temp1 = jsonDecode(msg1);
//   var temp2 = jsonDecode(msg2);
//   var ct = DateFormat('dd').format(
//       DateTime.fromMillisecondsSinceEpoch(int.parse(temp1['timestamp'])));
//   var pt = DateFormat('dd').format(
//       DateTime.fromMillisecondsSinceEpoch(int.parse(temp2['timestamp'])));
//   var daynow = DateFormat('EEE').format(DateTime.fromMillisecondsSinceEpoch(
//       int.parse(DateTime.now().millisecondsSinceEpoch.toString())));
//   var daypast = DateFormat('EEE').format(
//       DateTime.fromMillisecondsSinceEpoch(int.parse(temp1['timestamp'])));
//   if (ct != pt) {
//     return (daypast == daynow
//         ? 'Today'
//         : (DateFormat('dd MMM yyyy').format(DateTime.fromMillisecondsSinceEpoch(
//             int.parse(temp1['timestamp'])))));
//   } else {
//     return "";
//   }
// }

// class ChatScreen extends StatefulWidget {
//   final String? msgid;
//   ChatScreen({this.msgid});
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends StateMVC<ChatScreen> {
//   TextEditingController _controller = TextEditingController();
//   ScrollController _scrollController = ScrollController();
//   String? textInput;
//   String? msgid;
//   List<File>? chatimages = [];
//   bool? uploading = false;
//   double? val = 0;
//   String? timestamp = DateTime.now().millisecondsSinceEpoch.toString();
//   List? imageLink = [];
//   DateTime? now = DateTime.now();
//   // _ChatScreenState(this.msgid);

//   //socket

//   StreamController? _chatResponseList;

//   Stream? stream;

//   // var chatDataLog;

//   IO.Socket? socket;

//   void socketResponse() {
//     socket = IO.io("https://spotmies.herokuapp.com", <String, dynamic>{
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
//     socket?.on('recieveNewMessage', (recieveMsg) {
//       log(recieveMsg);
//       _chatResponseList?.add(recieveMsg);
//     });
//   }

//   @override
//   void initState() {
//     //var chatData = Provider.of<ChattingProvider>(context, listen: false);
//     _chatResponseList = StreamController();

//     stream = _chatResponseList?.stream.asBroadcastStream();
//     // chatData.chatInfo(_chatResponseList == null ? false : true);
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
//     Timer(
//         Duration(milliseconds: 300),
//         () => _scrollController.animateTo(
//             _scrollController.position.maxScrollExtent,
//             duration: Duration(milliseconds: 200),
//             curve: Curves.easeInOut));
//     // return Consumer<ChattingProvider>(builder: (context, data, child) {
//     //   chatDataLog = data.chatLocal;
//     // var user = data.chatLocal[0]['uDetails'];
//     // var partner = data.chatLocal[index]['pDetails'];
//     // var c = data.chatLocal[0]['msgs'];
//     return FutureBuilder(
//         future: localChatListGet(),
//         builder: (context, localChatList) {
//           if (localChatList.data == null) {
//             CircularProgressIndicator();
//           }
//           dynamic user = localChatList.data[0]['uDetails'];
//           dynamic c = localChatList.data[0]['msgs'];
//           if (user == null || c == null) {
//             chattingList();
//           }

//           return Scaffold(
//               backgroundColor: Colors.white,
//               appBar: AppBar(
//                 backgroundColor: Colors.blue[800],
//                 leading: IconButton(
//                     icon: Icon(Icons.arrow_back, color: Colors.white),
//                     onPressed: () {}),
//                 title: InkWell(
//                   onTap: () {
//                     // var msgid = chatDataLog[0]['msgId'];
//                     // Navigator.of(context).push(MaterialPageRoute(
//                     //   builder: (context) => UserDetails(
//                     //     value: msgid,
//                     //   ),
//                     // ));
//                   },
//                   child: Row(
//                     children: [
//                       CircleAvatar(
//                         child: AspectRatio(
//                           aspectRatio: 400 / 400,
//                           child: ClipOval(
//                             child: user['pic'] == null
//                                 ? Icon(
//                                     Icons.person,
//                                     color: Colors.black,
//                                     size: 30,
//                                   )
//                                 : Image.network(
//                                     user['pic'].toString(),
//                                     fit: BoxFit.cover,
//                                     width: MediaQuery.of(context).size.width,
//                                   ),
//                           ),
//                         ),
//                         backgroundColor: Colors.grey[50],
//                       ),
//                       SizedBox(
//                         width: _width * 0.03,
//                       ),
//                       Container(
//                         // padding: EdgeInsets.only(top: 10),
//                         child: Text(
//                           user['name'] == null ? 'Costumer' : user['name'],
//                           style: TextStyle(
//                               color: Colors.white, fontSize: _width * 0.055),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//               body: StreamBuilder(
//                   stream: stream,
//                   builder: (context, newMsg) {
//                     // if (snapshot.data != null) chatDataLog.add(snapshot.data);
//                     log('message');
//                     log(newMsg.data.toString());
//                     // if (!snapshot.hasData)
//                     //   return Center(
//                     //     child: CircularProgressIndicator(),
//                     //   );
//                     //var document = snapshot.data;
//                     // List<String> msgs = List.from(document['body']);
//                     Timer(
//                         Duration(milliseconds: 400),
//                         () => _scrollController.jumpTo(
//                             _scrollController.position.maxScrollExtent));
//                     return ListView(
//                       children: [
//                         Container(
//                           padding: EdgeInsets.all(10),
//                           height: _hight * 0.87,
//                           width: _width * 1,
//                           child: ListView.builder(
//                               controller: _scrollController,
//                               itemCount: c.length,
//                               itemBuilder: (BuildContext ctxt, int index) {
//                                 String msgData = c[index];
//                                 var data = jsonDecode(msgData);
//                                 //var date2 = index - 1 == -1 ? index : index - 1;

//                                 if ((data['sender'] == 'partner') &&
//                                     (data['type'] == 'text')) {
//                                   return Column(
//                                     children: [
//                                       // if (date(msgData, msgs[date2]) != '')
//                                       //   Padding(
//                                       //     padding: const EdgeInsets.all(8.0),
//                                       //     child: Container(
//                                       //         height: _hight * 0.04,
//                                       //         width: _width * 0.3,
//                                       //         decoration: BoxDecoration(
//                                       //             color: Colors.blueGrey[800],
//                                       //             borderRadius:
//                                       //                 BorderRadius.circular(10)),
//                                       //         child: Center(
//                                       //             child: Text(
//                                       //           date(msgData, msgs[date2]),
//                                       //           style:
//                                       //               TextStyle(color: Colors.white),
//                                       //         ))),
//                                       //   ),

//                                       Row(
//                                         children: [
//                                           Expanded(
//                                             child: Container(
//                                                 alignment:
//                                                     Alignment.centerRight,
//                                                 child: Column(
//                                                   children: [
//                                                     Container(
//                                                       alignment:
//                                                           Alignment.centerLeft,
//                                                       padding: EdgeInsets.only(
//                                                           top: 10,
//                                                           left: 15,
//                                                           right: 15),
//                                                       width: _width * 0.55,
//                                                       decoration: BoxDecoration(
//                                                           color:
//                                                               Colors.grey[200],
//                                                           borderRadius:
//                                                               BorderRadius.only(
//                                                             topLeft:
//                                                                 Radius.circular(
//                                                                     15),
//                                                             topRight:
//                                                                 Radius.circular(
//                                                                     15),
//                                                           )),
//                                                       child: Text(
//                                                           toBeginningOfSentenceCase(
//                                                               data['msg']).toString()),
//                                                     ),
//                                                     Container(
//                                                       padding: EdgeInsets.only(
//                                                           bottom: 2, right: 15),
//                                                       width: _width * 0.55,
//                                                       decoration: BoxDecoration(
//                                                           color:
//                                                               Colors.grey[200],
//                                                           borderRadius:
//                                                               BorderRadius.only(
//                                                             bottomLeft:
//                                                                 Radius.circular(
//                                                                     30),

//                                                             // bottomLeft:Radius.circular(30)
//                                                           )),
//                                                       child: Row(
//                                                         mainAxisAlignment:
//                                                             MainAxisAlignment
//                                                                 .end,
//                                                         children: [
//                                                           Text(DateFormat.jm().format(
//                                                               DateTime.fromMillisecondsSinceEpoch(
//                                                                   (int.parse(data[
//                                                                           'time']
//                                                                       .toString()))))),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                     SizedBox(
//                                                       height: 5,
//                                                     ),
//                                                   ],
//                                                 )),
//                                           ),
//                                         ],
//                                       ),
//                                       // Text("date")
//                                     ],
//                                   );
//                                 }
//                                 if ((data['sender'] == 'user') &&
//                                     (data['type'] == 'text')) {
//                                   return Column(
//                                     children: [
//                                       // if (date(msgData, msgs[date2]) != '')
//                                       //   Padding(
//                                       //     padding: const EdgeInsets.all(8.0),
//                                       //     child: Container(
//                                       //         height: _hight * 0.04,
//                                       //         width: _width * 0.3,
//                                       //         decoration: BoxDecoration(
//                                       //             color: Colors.blueGrey[800],
//                                       //             borderRadius:
//                                       //                 BorderRadius.circular(10)),
//                                       //         child: Center(
//                                       //             child: Text(
//                                       //           date(msgData, msgs[date2]),
//                                       //           style:
//                                       //               TextStyle(color: Colors.white),
//                                       //         ))),
//                                       //   ),
//                                       Row(
//                                         children: [
//                                           Expanded(
//                                             child: Container(
//                                                 alignment: Alignment.centerLeft,
//                                                 child: Column(
//                                                   children: [
//                                                     Container(
//                                                       alignment:
//                                                           Alignment.centerRight,
//                                                       padding: EdgeInsets.only(
//                                                           top: 10,
//                                                           right: 15,
//                                                           left: 15),
//                                                       width: _width * 0.55,
//                                                       decoration: BoxDecoration(
//                                                           color:
//                                                               Colors.grey[100],
//                                                           borderRadius:
//                                                               BorderRadius.only(
//                                                             topLeft:
//                                                                 Radius.circular(
//                                                                     15),
//                                                             topRight:
//                                                                 Radius.circular(
//                                                                     15),
//                                                           )),
//                                                       child: Text(
//                                                           toBeginningOfSentenceCase(
//                                                                   data['msg'])
//                                                               .toString()),
//                                                     ),
//                                                     Container(
//                                                       padding: EdgeInsets.only(
//                                                           bottom: 2, left: 15),
//                                                       width: _width * 0.55,
//                                                       decoration: BoxDecoration(
//                                                           color:
//                                                               Colors.grey[100],
//                                                           borderRadius:
//                                                               BorderRadius.only(
//                                                             bottomRight:
//                                                                 Radius.circular(
//                                                                     30),

//                                                             // bottomLeft:Radius.circular(30)
//                                                           )),
//                                                       child: Row(
//                                                         mainAxisAlignment:
//                                                             MainAxisAlignment
//                                                                 .start,
//                                                         children: [
//                                                           Text(DateFormat.jm().format(
//                                                               (DateTime.fromMillisecondsSinceEpoch(
//                                                                   (int.parse(data[
//                                                                           'time']
//                                                                       .toString())))))),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                     SizedBox(
//                                                       height: 5,
//                                                     ),
//                                                     // Text(date(msgData, msgs[date2])),
//                                                   ],
//                                                 )),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   );
//                                 }
//                                 if ((data['type'] == 'media') &&
//                                     (data['sender'] == 'partner')) {
//                                   // List<String> list = data['msg'].length;
//                                   // List<Widget> widgets = list.map((name) => new Text(name)).toList();
//                                   return Column(
//                                     children: [
//                                       // if (date(msgData, msgs[date2]) != '')
//                                       //   Padding(
//                                       //     padding: const EdgeInsets.all(8.0),
//                                       //     child: Container(
//                                       //         height: _hight * 0.04,
//                                       //         width: _width * 0.3,
//                                       //         decoration: BoxDecoration(
//                                       //             color: Colors.blueGrey[800],
//                                       //             borderRadius:
//                                       //                 BorderRadius.circular(10)),
//                                       //         child: Center(
//                                       //             child: Text(
//                                       //           date(msgData, msgs[date2]),
//                                       //           style:
//                                       //               TextStyle(color: Colors.white),
//                                       //         ))),
//                                       //   ),
//                                       Row(
//                                         children: [
//                                           Expanded(
//                                               child: Container(
//                                             alignment: Alignment.centerRight,
//                                             child: Column(
//                                               children: [
//                                                 Container(
//                                                   padding: EdgeInsets.all(10),
//                                                   // height: _hight * 0.3,
//                                                   width: _width * 0.5,
//                                                   decoration: BoxDecoration(
//                                                       color: Colors.grey[50],
//                                                       borderRadius:
//                                                           BorderRadius.only(
//                                                         topLeft:
//                                                             Radius.circular(15),
//                                                         topRight:
//                                                             Radius.circular(15),
//                                                       )),
//                                                   child: Column(
//                                                     children: [
//                                                       Row(
//                                                         children: [
//                                                           Text(
//                                                             'You ',
//                                                             style: TextStyle(
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w500,
//                                                                 color: Colors
//                                                                     .black),
//                                                           ),
//                                                           SizedBox(
//                                                             height: 10,
//                                                           )
//                                                         ],
//                                                       ),
//                                                       Image.network(
//                                                         data['msg'],
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 Container(
//                                                   padding: EdgeInsets.only(
//                                                       bottom: 2, left: 15),
//                                                   width: _width * 0.5,
//                                                   decoration: BoxDecoration(
//                                                       color: Colors.grey[50],
//                                                       borderRadius:
//                                                           BorderRadius.only(
//                                                         bottomLeft:
//                                                             Radius.circular(30),

//                                                         // bottomLeft:Radius.circular(30)
//                                                       )),
//                                                   child: Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment.start,
//                                                     children: [
//                                                       Text(DateFormat.jm().format(
//                                                           (DateTime.fromMillisecondsSinceEpoch(
//                                                               (int.parse(data[
//                                                                       'timestamp']
//                                                                   .toString())))))),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 SizedBox(
//                                                   height: 5,
//                                                 )
//                                               ],
//                                             ),
//                                           )),
//                                         ],
//                                       ),
//                                     ],
//                                   );
//                                 }
//                                 if ((data['type'] == 'media') &&
//                                     (data['sender'] == 'user')) {
//                                   return Column(
//                                     children: [
//                                       // if (date(msgData, msgs[date2]) != '')
//                                       //   Padding(
//                                       //     padding: const EdgeInsets.all(8.0),
//                                       //     child: Container(
//                                       //         height: _hight * 0.04,
//                                       //         width: _width * 0.3,
//                                       //         decoration: BoxDecoration(
//                                       //             color: Colors.blueGrey[800],
//                                       //             borderRadius:
//                                       //                 BorderRadius.circular(10)),
//                                       //         child: Center(
//                                       //             child: Text(
//                                       //           date(msgData, msgs[date2]),
//                                       //           style:
//                                       //               TextStyle(color: Colors.white),
//                                       //         ))),
//                                       //   ),
//                                       Row(
//                                         children: [
//                                           Expanded(
//                                               child: Container(
//                                             alignment: Alignment.centerLeft,
//                                             child: Column(
//                                               children: [
//                                                 Container(
//                                                   padding: EdgeInsets.all(10),
//                                                   // height: _hight * 0.3,
//                                                   width: _width * 0.5,
//                                                   decoration: BoxDecoration(
//                                                       color: Colors.grey[50],
//                                                       borderRadius:
//                                                           BorderRadius.only(
//                                                         topLeft:
//                                                             Radius.circular(15),
//                                                         topRight:
//                                                             Radius.circular(15),
//                                                       )),
//                                                   child: Column(
//                                                     children: [
//                                                       Row(
//                                                         children: [
//                                                           Text(
//                                                             'From ' +
//                                                                 user['name'],
//                                                             style: TextStyle(
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w500,
//                                                                 color: Colors
//                                                                     .black),
//                                                           ),
//                                                           SizedBox(
//                                                             height: 10,
//                                                           )
//                                                         ],
//                                                       ),
//                                                       Image.network(
//                                                         data['msg'],
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 Container(
//                                                   padding: EdgeInsets.only(
//                                                       bottom: 2, left: 15),
//                                                   width: _width * 0.55,
//                                                   decoration: BoxDecoration(
//                                                       color: Colors.grey[50],
//                                                       borderRadius:
//                                                           BorderRadius.only(
//                                                         bottomRight:
//                                                             Radius.circular(30),

//                                                         // bottomLeft:Radius.circular(30)
//                                                       )),
//                                                   child: Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment.start,
//                                                     children: [
//                                                       Text(DateFormat.jm().format(
//                                                           (DateTime.fromMillisecondsSinceEpoch(
//                                                               (int.parse(data[
//                                                                       'timestamp']
//                                                                   .toString())))))),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 SizedBox(
//                                                   height: 5,
//                                                 )
//                                               ],
//                                             ),
//                                           )),
//                                         ],
//                                       ),
//                                     ],
//                                   );
//                                 } else {
//                                   return Text('Undefined');
//                                 }
//                               }),
//                           color: Colors.white,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             Container(
//                                 padding: EdgeInsets.only(right: 20),
//                                 height: _hight * 0.035,
//                                 child: Row(
//                                   children: [
//                                     Icon(
//                                       Icons.done_all,
//                                       color:
//                                           localChatList.data[0]['uState'] == 1
//                                               ? Colors.greenAccent
//                                               : Colors.grey,
//                                     ),
//                                     Text(localChatList.data[0]['uState'] == 1
//                                         ? 'Seen'
//                                         : 'Unseen'),
//                                   ],
//                                 )),
//                           ],
//                         ),
//                         Container(
//                           // color: Colors.amber,
//                           padding: EdgeInsets.all(1),
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 child: Container(
//                                   padding: EdgeInsets.all(5),
//                                   height: _hight * 0.1,
//                                   width: _width * 0.8,
//                                   child: TextField(
//                                     maxLines: 4,
//                                     controller: _controller,
//                                     keyboardType: TextInputType.name,
//                                     decoration: InputDecoration(
//                                       border: new OutlineInputBorder(
//                                           borderSide: new BorderSide(
//                                               color: Colors.white),
//                                           borderRadius:
//                                               BorderRadius.circular(15)),
//                                       focusedBorder: OutlineInputBorder(
//                                           borderRadius: BorderRadius.all(
//                                               Radius.circular(15)),
//                                           borderSide: BorderSide(
//                                               width: 1, color: Colors.white)),
//                                       enabledBorder: OutlineInputBorder(
//                                           borderRadius: BorderRadius.all(
//                                               Radius.circular(15)),
//                                           borderSide: BorderSide(
//                                               width: 1, color: Colors.white)),
//                                       hintStyle: TextStyle(fontSize: 17),
//                                       hintText: 'Type Message......',
//                                       contentPadding: EdgeInsets.all(20),
//                                     ),
//                                     onChanged: (value) {
//                                       this.textInput = value;
//                                     },
//                                   ),
//                                 ),
//                               ),
//                               IconButton(
//                                   icon: Icon(
//                                     Icons.photo_camera,
//                                     color: Colors.grey,
//                                   ),
//                                   onPressed: () {
//                                     var msgcount =
//                                         localChatList.data[0]['uCount'];
//                                     var uread = localChatList.data[0]['uState'];

//                                     bottomappbar(msgcount, uread);
//                                   }),
//                               Container(
//                                 height: _hight * 0.1,
//                                 width: _width * 0.14,
//                                 decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: Colors.blue[900]),
//                                 padding: EdgeInsets.all(10),
//                                 child: Center(
//                                     child: IconButton(
//                                         icon: Icon(
//                                           Icons.send,
//                                           size: 25,
//                                           color: Colors.white,
//                                         ),
//                                         onPressed: () {
//                                           // int msgcount =
//                                           //     chatDataLog[0]['uCount'] + 1;
//                                           _controller.clear();
//                                           String timestamp = DateTime.now()
//                                               .millisecondsSinceEpoch
//                                               .toString();
//                                           var msgData = {
//                                             'msg': textInput,
//                                             'time': timestamp,
//                                             'sender': 'partner',
//                                             'type': 'text'
//                                           };
//                                           var target = {
//                                             'uId': user['uId'],
//                                             'pId': FirebaseAuth
//                                                 .instance.currentUser.uid,
//                                             'msgId': localChatList.data[0]
//                                                 ['msgId'],
//                                             'ordId': localChatList.data[0]
//                                                 ['ordId'],
//                                           };
//                                           String temp = jsonEncode(msgData);
//                                           log(target.toString());
//                                           log(temp.toString());

//                                           socket.emitWithAck(
//                                               'sendNewMessageCallback', {
//                                             "object": temp,
//                                             "target": target
//                                           }, ack: (var callback) {
//                                             if (callback == 'success') {
//                                               print('working Fine');
//                                               log(target.toString());
//                                               log(temp.toString());
//                                             } else {
//                                               log('notSuccess');
//                                             }
//                                           });
//                                           // socket.emit(
//                                           //   'sendNewMessage',
//                                           //   {"object": temp, "target": target},
//                                           // );
//                                           // textInput == null
//                                           //     ? ScaffoldMessenger.of(context)
//                                           //         .showSnackBar(SnackBar(
//                                           //         content:
//                                           //             Text('Please type text...'),
//                                           //         action: SnackBarAction(
//                                           //           label: 'Undo',
//                                           //           onPressed: () {
//                                           //             // Some code to undo the change.
//                                           //           },
//                                           //         ),
//                                           //       ))
//                                           // : FirebaseFirestore.instance
//                                           //     .collection('messaging')
//                                           //     .doc(value)
//                                           //     .update({
//                                           //     // if (document['createdAt'] == null)
//                                           //     'createdAt': timestamp,
//                                           //     'body':
//                                           //         FieldValue.arrayUnion([temp]),
//                                           //     'umsgcount': document['uread'] == 0
//                                           //         ? msgcount
//                                           //         : 0,
//                                           //   });
//                                           Timer(
//                                               Duration(milliseconds: 300),
//                                               () => _scrollController.jumpTo(
//                                                   _scrollController.position
//                                                       .maxScrollExtent));
//                                         })),
//                               )
//                             ],
//                           ),
//                         ),
//                       ],
//                     );
//                   }),
//               floatingActionButton: FloatingActionButton(
//                 backgroundColor: Colors.white,
//                 onPressed: () {
//                   Timer(
//                       Duration(milliseconds: 300),
//                       () => _scrollController
//                           .jumpTo(_scrollController.position.maxScrollExtent));
//                 },
//                 child: Icon(
//                   Icons.arrow_downward,
//                   color: Colors.blue[900],
//                 ),
//               ),
//               floatingActionButtonLocation:
//                   FloatingActionButtonLocation.endFloat);
//         });
//     // });
//   }

//   chooseImage() async {
//     final pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     setState(() {
//       chatimages.add(File(pickedFile?.path));
//     });
//     if (pickedFile.path == null) retrieveLostData();
//   }

//   Future<void> retrieveLostData() async {
//     final LostDataResponse response = await ImagePicker().retrieveLostData();
//     if (response.isEmpty) {
//       return;
//     }
//     if (response.file != null) {
//       setState(() {
//         chatimages.add(File(response.file.path));
//       });
//     } else {
//       print(response.file);
//     }
//   }

//   //image upload function
//   Future<void> uploadimage() async {
//     int i = 1;
//     for (var img in chatimages) {
//       setState(() {
//         val = i / chatimages.length;
//       });
//       var postImageRef = FirebaseStorage.instance.ref().child('adImages');
//       UploadTask uploadTask =
//           postImageRef.child(DateTime.now().toString() + ".jpg").putFile(img);
//       await (await uploadTask)
//           .ref
//           .getDownloadURL()
//           .then((value) => imageLink.add(value.toString()));
//       i++;
//     }
//   }

//   bottomappbar(int msgcount, int uread) {
//     final _hight = MediaQuery.of(context).size.height -
//         MediaQuery.of(context).padding.top -
//         kToolbarHeight;
//     final _width = MediaQuery.of(context).size.width;
//     showModalBottomSheet(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(
//             top: Radius.circular(15),
//           ),
//         ),
//         elevation: 2,
//         isScrollControlled: true,
//         context: context,
//         builder: (BuildContext context) {
//           return Container(
//             padding: EdgeInsets.all(15),
//             height: _hight * 0.50,
//             child: Column(
//               children: [
//                 Container(
//                     child: Row(
//                   children: [
//                     Text('Upload images:',
//                         style: TextStyle(
//                             fontSize: 17, fontWeight: FontWeight.w500)),
//                   ],
//                 )),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 chatimages == null
//                     ? Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           IconButton(
//                               icon: Icon(
//                                 Icons.cloud_upload_outlined,
//                                 size: 45,
//                                 color: Colors.grey,
//                               ),
//                               onPressed: () {}),
//                           SizedBox(
//                             height: 7,
//                           ),
//                           Text('Let us know your problem by uploading image')
//                         ],
//                       )
//                     : Column(
//                         children: [
//                           Container(
//                             height: _hight * 0.34,
//                             width: _width * 1,
//                             child: GridView.builder(
//                                 itemCount: chatimages.length + 1,
//                                 gridDelegate:
//                                     SliverGridDelegateWithFixedCrossAxisCount(
//                                         crossAxisCount: 5),
//                                 itemBuilder: (context, index) {
//                                   return index == 0
//                                       ? Center(
//                                           child: IconButton(
//                                               icon: Icon(Icons.add),
//                                               onPressed: () async {
//                                                 if (!uploading) {
//                                                   chooseImage();
//                                                   refresh();
//                                                 }
//                                               }),
//                                         )
//                                       : Stack(
//                                           alignment: Alignment.topRight,
//                                           children: [
//                                               Container(
//                                                 margin: EdgeInsets.all(6),
//                                                 decoration: BoxDecoration(
//                                                     image: DecorationImage(
//                                                         image: FileImage(
//                                                             chatimages[
//                                                                 index - 1]),
//                                                         fit: BoxFit.cover)),
//                                               ),
//                                               Positioned(
//                                                 left: 37.0,
//                                                 bottom: 37.0,
//                                                 child: IconButton(
//                                                     icon: Icon(
//                                                       Icons.remove_circle,
//                                                       color:
//                                                           Colors.redAccent[200],
//                                                     ),
//                                                     onPressed: () async {
//                                                       chatimages.removeAt(0);

//                                                       refresh();
//                                                     }),
//                                               ),
//                                             ]);
//                                 }),
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               InkWell(
//                                 onTap: () async {
//                                   await uploadimage();
//                                   _controller.clear();

//                                   int len = imageLink.length;

//                                   for (int i = 0; i <= len; i++) {
//                                     // var imageData = {
//                                     //   'msg': imageLink[i],
//                                     //   'timestamp': timestamp,
//                                     //   'sender': 'p',
//                                     //   'type': 'media'
//                                     // };
//                                     // String temp = jsonEncode(imageData);
//                                     // await FirebaseFirestore.instance
//                                     //     .collection('messaging')
//                                     //     .doc(value)
//                                     //     .update({
//                                     //   'createdAt': DateTime.now(),
//                                     //   'body': FieldValue.arrayUnion([temp]),
//                                     //   'umsgcount':
//                                     //       uread == 0 ? msgcount + 1 : 0,
//                                     // });

//                                     Navigator.pop(context);
//                                   }
//                                 },
//                                 child: Container(
//                                   padding: EdgeInsets.all(12),
//                                   height: _hight * 0.07,
//                                   decoration: BoxDecoration(
//                                       boxShadow: [
//                                         BoxShadow(
//                                             blurRadius: 2,
//                                             offset: Offset(
//                                               -2.0,
//                                               -1,
//                                             ),
//                                             color: Colors.grey[50],
//                                             spreadRadius: 1.0),
//                                         BoxShadow(
//                                             blurRadius: 2,
//                                             offset: Offset(
//                                               2.0,
//                                               1,
//                                             ),
//                                             color: Colors.grey[300],
//                                             spreadRadius: 1.0)
//                                       ],
//                                       color: Colors.white,
//                                       shape: BoxShape.circle),
//                                   child: Icon(
//                                     Icons.send,
//                                     color: Colors.blue[900],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//               ],
//             ),
//           );
//         });
//   }
// }
