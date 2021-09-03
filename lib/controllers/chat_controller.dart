import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:video_player/video_player.dart';

class ChatController extends ControllerMVC {
  var scaffoldkey = GlobalKey<ScaffoldState>();

  List<File> chatimages = [];
  List<File> chatVideo = [];
  List imageLink = [];
  List videoLink = [];
  List audioLink = [];
  bool isUploading = false;
  double val = 0;

  final picker = ImagePicker();
  VideoPlayerController videoPlayerController;

  chooseImage(sendCallBack) async {
    if (imageLink.length != 0) {
      await imageLink.removeAt(0);
      chatimages.removeAt(0);
    }
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 10,
    );
    setState(() {
      chatimages.add(File(pickedFile?.path));
    });
    if (pickedFile.path == null) retrieveLostData();
    await uploadimage(sendCallBack);
  }

  pickVideo(sendCallBack) async {
    PickedFile pickedFile = await picker.getVideo(
        source: ImageSource.camera, maxDuration: Duration(seconds: 10));
    chatVideo.add(File(pickedFile.path));
    videoPlayerController = VideoPlayerController.file(chatVideo[0]);
    uploadVideo(sendCallBack);
  }

  Future<void> retrieveLostData() async {
    final LostData response = await ImagePicker().getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        chatimages.add(File(response.file.path));
      });
    } else {
      print(response.file);
    }
  }

  Future<void> uploadimage(sendCallBack) async {
    int i = 1;
    for (var img in chatimages) {
      setState(() {
        val = i / chatimages.length;
      });
      var chatImages = FirebaseStorage.instance.ref().child('chatImages');
      UploadTask uploadTask =
          chatImages.child(DateTime.now().toString() + ".jpg").putFile(img);
      await (await uploadTask)
          .ref
          .getDownloadURL()
          .then((value) => imageLink.add(value.toString()));
      i++;
    }
    if (imageLink.isNotEmpty) {
      sendCallBack(imageLink[0], 'img').runtimeType;
    }
  }

  Future<void> uploadVideo(sendCallBack) async {
    int i = 1;
    for (var video in chatVideo) {
      setState(() {
        val = i / chatVideo.length;
      });
      var chatVideos = FirebaseStorage.instance.ref().child('chatVideos');
      UploadTask uploadTask =
          chatVideos.child(DateTime.now().toString() + ".mp4").putFile(video);
      await (await uploadTask)
          .ref
          .getDownloadURL()
          .then((value) => videoLink.add(value.toString()));
      i++;
    }
    if (videoLink.isNotEmpty) {
      sendCallBack(videoLink[0], 'video').runtimeType;
    }
  }

  Future<void> audioUpload(
      String filePath, Function sendCallBack,) async {
    // FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    var chatAudio = FirebaseStorage.instance.ref().child('chatVideos');

    setState(() {
      isUploading = true;
    });

    try {
      UploadTask uploadTask = chatAudio.child(filePath).putFile(File(filePath));
      await (await uploadTask)
          .ref
          .getDownloadURL()
          .then((value) => audioLink.add(value.toString()));
      if (audioLink.isNotEmpty) {
        sendCallBack(audioLink[0], 'audio').runtimeType;
      }
      audioLink.clear();
      
    } catch (error) {
      print('Error occured while uplaoding to Firebase ${error.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error occured while uplaoding'),
        ),
      );
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }
}
