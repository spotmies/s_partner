import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';
import 'package:spotmies_partner/reusable_widgets/elevatedButtonWidget.dart';
import 'package:permission_handler/permission_handler.dart';

final pathToSaveAudio =  DateTime.now().millisecondsSinceEpoch.toString();
// // final audioplayer = AssetsAudioPlayer();
// bool play = false;
// String recordText = DateTime.now().millisecondsSinceEpoch.toString();

class SoundRecorder {
  FlutterSoundRecorder audioRecorder;
  bool isRecordedInitied = false;
  bool get isRecording => audioRecorder.isRecording;

   Future init() async {
    // audioRecorder = FlutterSoundRecorder();
    final status =  await Permission.microphone.request();
    if(status != PermissionStatus.granted){
     log('Not permitted');
    }
    await audioRecorder.openAudioSession();
    isRecordedInitied = true;
  }
   Future dispose() async {
     if(!isRecordedInitied)return;
    audioRecorder.closeAudioSession();
    audioRecorder = null;
    isRecordedInitied = false;
  }

  Future startRecord() async {
    if(!isRecordedInitied)return;
    await audioRecorder.startRecorder(toFile: pathToSaveAudio);
  }

  Future stopRecord() async {
    if(!isRecordedInitied)return;
    await audioRecorder.startRecorder();
  }

  Future toggleRecording() async {
    if (audioRecorder.isStopped) {
      await startRecord();
    } else {
      await stopRecord();
    }
  }
}

Future audioRecoder(BuildContext context, double hight, double width, SoundRecorder recorder) {
  final isRecording = recorder.isRecording;
  final icon = isRecording ? Icons.stop:Icons.mic;
  final text = isRecording ? 'Stop':'Start';
  final color = isRecording ? Colors.white:Colors.black;
  final textColor = isRecording ? Colors.black:Colors.white;
  return showModalBottomSheet(
      context: context,
      elevation: 22,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          height: hight * 0.5,
          child: Column(
            children: [
              Row(
                children: [
                  ElevatedButtonWidget(
                    onClick: () {
                    final isRecording = SoundRecorder().toggleRecording();
                    },
                    buttonName: text,
                    leadingIcon: Icon(icon),
                    minWidth: width * 0.35,
                    height: hight * 0.06,
                    bgColor: color,
                    textColor: textColor,
                  ),
                  // ElevatedButtonWidget(
                  //   onClick: () {
                  //     SoundRecorder().stopRecord();
                  //   },
                  //   buttonName: 'Stop Recording',
                  //   minWidth: width * 0.35,
                  //   height: hight * 0.06,
                  // ),
                ],
              )
            ],
          ),
        );
      });
}
