// import 'dart:async';
// import 'dart:developer';
// import 'dart:io';
// import 'package:assets_audio_player/assets_audio_player.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:intl/date_symbol_data_local.dart';
// import 'package:spotmies_partner/controllers/chat_controller.dart';
// import 'package:spotmies_partner/reusable_widgets/elevatedButtonWidget.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:intl/intl.dart' show DateFormat;
// import 'package:path/path.dart' as path;



// class AudioRecorder extends StatefulWidget {
//   const AudioRecorder({ Key key}) : super(key: key);

//   @override
//   _AudioRecorderState createState() => _AudioRecorderState();
// }

// class _AudioRecorderState extends State<AudioRecorder> {
//    FlutterSoundRecorder _myRecorder;
//   final audioPlayer = AssetsAudioPlayer();
//   String filePath;
//   bool _play = false;
//   String _recorderTxt = '00:00:00';

//   @override
//   void initState() {
//     super.initState();
//     startIt();
//   }

//   void startIt() async {
//     filePath = '/sdcard/Download/temp.wav';
//     _myRecorder = FlutterSoundRecorder();

//     await _myRecorder.openAudioSession(
//         focus: AudioFocus.requestFocusAndStopOthers,
//         category: SessionCategory.playAndRecord,
//         mode: SessionMode.modeDefault,
//         device: AudioDevice.speaker);
//     await _myRecorder.setSubscriptionDuration(Duration(milliseconds: 10));
//     await initializeDateFormatting();

//     await Permission.microphone.request();
//     await Permission.storage.request();
//     await Permission.manageExternalStorage.request();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: <Widget>[
//             Container(
//               height: 400.0,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [Color.fromARGB(255, 2, 199, 226), Color.fromARGB(255, 6, 75, 210)],
//                 ),
//                 borderRadius: BorderRadius.vertical(
//                   bottom: Radius.elliptical(MediaQuery.of(context).size.width, 100.0),
//                 ),
//               ),
//               child: Center(
//                 child: Text(
//                   _recorderTxt,
//                   style: TextStyle(fontSize: 70),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 buildElevatedButton(
//                   icon: Icons.mic,
//                   iconColor: Colors.red,
//                   f: record,
//                 ),
//                 SizedBox(
//                   width: 30,
//                 ),
//                 buildElevatedButton(
//                   icon: Icons.stop,
//                   iconColor: Colors.black,
//                   f: stopRecord,
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 buildElevatedButton(
//                   icon: Icons.play_arrow,
//                   iconColor: Colors.black,
//                   f: startPlaying,
//                 ),
//                 SizedBox(
//                   width: 30,
//                 ),
//                 buildElevatedButton(
//                   icon: Icons.stop,
//                   iconColor: Colors.black,
//                   f: stopPlaying,
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(
//                 elevation: 10.0,
//               ),
//               onPressed: () {
//                 setState(() {
//                   _play = !_play;
//                 });
//                 if (_play) startPlaying();
//                 if (!_play) stopPlaying();
//               },
//               icon: _play
//                   ? Icon(
//                       Icons.stop,
//                     )
//                   : Icon(Icons.play_arrow),
//               label: _play
//                   ? Text(
//                       "Stop Playing",
//                       style: TextStyle(
//                         fontSize: 25,
//                       ),
//                     )
//                   : Text(
//                       "Start Playing",
//                       style: TextStyle(
//                         fontSize: 25,
//                       ),
//                     ),
//             ),
//           ],
//         ),
//       );
//   }
//   ElevatedButton buildElevatedButton({IconData icon, Color iconColor, Function f}) {
//     return ElevatedButton.icon(
//       style: ElevatedButton.styleFrom(
//         padding: EdgeInsets.all(5.0),
//         side: BorderSide(
//           color: Colors.orange,
//           width: 3.0,
//         ),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15),
//         ),
//         primary: Colors.white,
//         elevation: 10.0,
//       ),
//       onPressed: f,
//       icon: Icon(
//         icon,
//         color: iconColor,
//         size: 35.0,
//       ),
//       label: Text(''),
//     );
//   }

//   Future<void> record() async {
//     Directory dir = Directory(path.dirname(filePath));
//     if (!dir.existsSync()) {
//       dir.createSync();
//     }
//     _myRecorder.openAudioSession();
//     await _myRecorder.startRecorder(
//       toFile: filePath,
//       codec: Codec.pcm16WAV,
//     );

//     StreamSubscription _recorderSubscription = _myRecorder.onProgress.listen((e) {
//       var date = DateTime.fromMillisecondsSinceEpoch(e.duration.inMilliseconds, isUtc: true);
//       var txt = DateFormat('mm:ss:SS', 'en_GB').format(date);

//       setState(() {
//         _recorderTxt = txt.substring(0, 8);
//       });
//     });
//     _recorderSubscription.cancel();
//   }

//   Future<String> stopRecord() async {
//     _myRecorder.closeAudioSession();
//     return await _myRecorder.stopRecorder();
//   }

//   Future<void> startPlaying() async {
//     audioPlayer.open(
//       Audio.file(filePath),
//       autoStart: true,
//       showNotification: true,
//     );
//   }

//   Future<void> stopPlaying() async {
//     audioPlayer.stop();
//   }
// }





// // final pathToSaveAudio = DateTime.now().millisecondsSinceEpoch.toString();

// // class SoundRecorder {
// //   FlutterSoundRecorder audioRecorder;
// //   bool isRecordedInitied = false;
// //   bool get isRecording => audioRecorder.isRecording;

// //   Future init() async {
// //     audioRecorder = FlutterSoundRecorder();
// //     final status = await Permission.microphone.request();
// //     if (status != PermissionStatus.granted) {
// //       log('Not permitted');
// //     }
// //     await audioRecorder.openAudioSession();
// //      isRecordedInitied = true;
// //     return audioRecorder.recorderState;
   
// //   }

// //   Future dispose() async {
// //     if (!isRecordedInitied) return;
// //     audioRecorder.closeAudioSession();
// //     audioRecorder = null;
// //     isRecordedInitied = false;
// //   }

// //   Future startRecord() async {
// //     if (!isRecordedInitied) return;
// //     await audioRecorder.startRecorder(toFile: pathToSaveAudio);
    
// //     return audioRecorder.recorderState;
// //   }

// //   Future stopRecord() async {
// //     if (!isRecordedInitied) return;
// //     await audioRecorder.stopRecorder();
   
// //     return audioRecorder.recorderState;
// //   }

// //   Future toggleRecording() async {
// //     if (audioRecorder.isStopped) {
// //       await startRecord();
// //     } else {
// //       await stopRecord();
// //     }
// //   }
// // }

// // Future audioRecoder(BuildContext context, double hight, double width,
// //     SoundRecorder recorder, ChatController chatController) {
// //   final isRecording = recorder.isRecording;
// //   final icon = isRecording ? Icons.stop : Icons.mic;
// //   final text = isRecording ? 'Stop' : 'Start';
// //   final color = isRecording ? Colors.white : Colors.black;
// //   final textColor = isRecording ? Colors.black : Colors.white;
// //   return showModalBottomSheet(
// //       context: context,
// //       elevation: 22,
// //       isScrollControlled: true,
// //       shape: RoundedRectangleBorder(
// //         borderRadius: BorderRadius.vertical(
// //           top: Radius.circular(20),
// //         ),
// //       ),
// //       builder: (BuildContext context) {
// //         return Container(
// //           height: hight * 0.5,
// //           child: Column(
// //             children: [
// //               Row(
// //                 children: [
// //                   ElevatedButtonWidget(
// //                     onClick: () async {
// //                       var isRecording = await SoundRecorder().toggleRecording();
// //                       // log(isRecording.toString());
// //                       //     .catchError((e) {
// //                       //   log(e);
// //                       // });
// //                       chatController.refresh();
// //                     },
// //                     buttonName: text,
// //                     leadingIcon: Icon(icon),
// //                     minWidth: width * 0.35,
// //                     height: hight * 0.06,
// //                     bgColor: color,
// //                     textColor: textColor,
// //                   ),
// //                 ],
// //               )
// //             ],
// //           ),
// //         );
// //       });
// // }
