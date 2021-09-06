import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:provider/provider.dart';
import 'package:spotmies_partner/call_ui/audioCallWithImage/components/body.dart';
import 'package:spotmies_partner/internet_calling/signaling.dart';
import 'package:spotmies_partner/providers/chat_provider.dart';

class MyCalling extends StatefulWidget {
  final String msgId;
  final dynamic ordId;
  final dynamic uId;
  final dynamic pId;
  final bool isIncoming;
  final dynamic roomId;

  MyCalling(
      {@required this.msgId,
      @required this.pId,
      @required this.uId,
      @required this.ordId,
      @required this.isIncoming,
      this.roomId});
  @override
  _MyCallingState createState() => _MyCallingState();
}

class _MyCallingState extends State<MyCalling> {
  ChatProvider chatProvider;
  Signaling signaling = Signaling();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  String roomId;
  TextEditingController textEditingController = TextEditingController(text: '');

  Future<void> createRoomId() async {
    await signaling.openUserMedia(_localRenderer, _remoteRenderer, context);
    roomId = await signaling.createRoom(_remoteRenderer);
    chatProvider.setAcceptCall(false);
    log("room is is $roomId");
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    Map<String, String> msgData = {
      'msg': roomId.toString(),
      'time': timestamp,
      'sender': 'partner',
      'type': "call"
    };
    Map<String, dynamic> target = {
      'uId': widget.uId,
      'pId': widget.pId,
      'msgId': widget.msgId,
      'ordId': widget.ordId,
      'type': 'call',
      'roomId': roomId.toString()
    };
    Map<String, Object> sendPayload = {
      "object": jsonEncode(msgData),
      "target": target
    };
    chatProvider.addnewMessage(sendPayload);
    chatProvider.setSendMessage(sendPayload);
    setState(() {});
  }

  Future<void> handUpCall() async {
    log("===== handUp call =======");
    await signaling.hangUp(_localRenderer);
    chatProvider.setAcceptCall(true);
    chatProvider.resetDuration();
    Navigator.pop(context);
  }

  void joinOnRoom() {
    log("joing call////");
    signaling.joinRoom(
      widget.roomId,
      _remoteRenderer,
    );
    chatProvider.setAcceptCall(false);
    Timer.periodic(Duration(seconds: 1), (timer) {
      chatProvider.incrementDuration();
      if (chatProvider.getAcceptCall) timer.cancel();
    });
  }

  @override
  void initState() {
    chatProvider = Provider.of<ChatProvider>(context, listen: false);
    _localRenderer.initialize();
    _remoteRenderer.initialize();

    signaling.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {});
    });
    signaling.openUserMedia(_localRenderer, _remoteRenderer, context);
    if (!widget.isIncoming) {
      createRoomId();
    }

    super.initState();
  }

  @override
  void dispose() {
    log("====== disporse =======");
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    chatProvider.setAcceptCall(true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("=========== Render calling ==============");
    return Consumer<ChatProvider>(builder: (context, data, child) {
      Map uDetails =  data.getUdetailsByMsgId(widget.msgId);     
      return CallingUi(
        isInComingScreen: widget.isIncoming,
        onHangUp: handUpCall,
        onAccept: joinOnRoom,
        name: uDetails['name'],
        image: uDetails['pic'],
      );
    });
    // Scaffold(
    //   appBar: AppBar(
    //     title: Text("Welcome to Flutter Explained - WebRTC"),
    //   ),
    //   body: Column(
    //     children: [
    //       SizedBox(height: 8),
    //       SingleChildScrollView(
    //         scrollDirection: Axis.horizontal,
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             ElevatedButton(
    //               onPressed: () {
    //                 signaling.openUserMedia(_localRenderer, _remoteRenderer);
    //               },
    //               child: Text("Open camera & microphone"),
    //             ),
    //             SizedBox(
    //               width: 8,
    //             ),
    //             ElevatedButton(
    //               onPressed: () async {
    //                 roomId = await signaling.createRoom(_remoteRenderer);
    //                 textEditingController.text = roomId;
    //                 setState(() {});
    //               },
    //               child: Text("Create room"),
    //             ),
    //             SizedBox(
    //               width: 8,
    //             ),
    //             ElevatedButton(
    //               onPressed: () {
    //                 // Add roomId
    //                 signaling.joinRoom(
    //                   textEditingController.text,
    //                   _remoteRenderer,
    //                 );
    //               },
    //               child: Text("Join room"),
    //             ),
    //             SizedBox(
    //               width: 8,
    //             ),
    //             ElevatedButton(
    //               onPressed: () {
    //                 signaling.hangUp(_localRenderer);
    //               },
    //               child: Text("Hangup"),
    //             )
    //           ],
    //         ),
    //       ),
    //       SizedBox(height: 8),
    //       Expanded(
    //         child: Padding(
    //           padding: const EdgeInsets.all(8.0),
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               Expanded(child: RTCVideoView(_localRenderer, mirror: true)),
    //               Expanded(child: RTCVideoView(_remoteRenderer)),
    //             ],
    //           ),
    //         ),
    //       ),
    //       Padding(
    //         padding: const EdgeInsets.all(8.0),
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             Text("Join the following Room: "),
    //             Flexible(
    //               child: TextFormField(
    //                 controller: textEditingController,
    //               ),
    //             )
    //           ],
    //         ),
    //       ),
    //       SizedBox(height: 8)
    //     ],
    //   ),
    // );
  }
}