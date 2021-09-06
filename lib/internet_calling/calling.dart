import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:spotmies_partner/call_ui/audioCallWithImage/components/body.dart';
import 'package:spotmies_partner/internet_calling/signaling.dart';

class MyCalling extends StatefulWidget {
  @override
  _MyCallingState createState() => _MyCallingState();
}

class _MyCallingState extends State<MyCalling> {
  Signaling signaling = Signaling();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  String roomId;
  TextEditingController textEditingController = TextEditingController(text: '');

Future<void> createRoomId() async {
 roomId = await signaling.createRoom(_remoteRenderer);
 log("room is is $roomId");
 setState(() {});
}

Future<void> handUpCall() async {
  log("===== handUp call =======");
await signaling.hangUp(_localRenderer);
Navigator.pop(context);
}


  @override
  void initState() {
    _localRenderer.initialize();
    _remoteRenderer.initialize();

    signaling.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {});
    });
    signaling.openUserMedia(_localRenderer, _remoteRenderer);
    createRoomId();
   
    super.initState();
  }

  @override
  void dispose() {
    log("====== disporse =======");
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  @override
  
  Widget build(BuildContext context) {
    log("=========== Render calling ==============");
    return CallingUi(isInComingScreen: false,onHangUp: handUpCall,);
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
