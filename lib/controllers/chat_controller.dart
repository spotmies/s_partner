import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:spotmies_partner/reusable_widgets/progressIndicator.dart';
import 'package:video_player/video_player.dart';


class ChatController extends ControllerMVC {
  var scaffoldkey = GlobalKey<ScaffoldState>();

  List<File> chatimages = [];
  List<File> chatVideo = [];
  List imageLink = [];
  List videoLink = [];
  bool uploading = false;
  double val = 0;

   
  final picker = ImagePicker();
  VideoPlayerController videoPlayerController;

  chooseImage(sendCallBack) async {
    if(imageLink.length != 0){
     
     await imageLink.removeAt(0);
     chatimages.removeAt(0);

    }
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera,imageQuality: 10,);
    setState(() {
      chatimages.add(File(pickedFile?.path));
    });
    if (pickedFile.path == null) retrieveLostData();
    await uploadimage(sendCallBack);
  }
 

  pickVideo(sendCallBack) async {
    //   if(videoLink.isNotEmpty){
     
    //  await videoLink.removeAt(0);
    //  chatVideo.removeAt(0);

    // }
    PickedFile pickedFile = await picker.getVideo(source: ImageSource.camera);
     chatVideo.add( File(pickedFile.path));
    videoPlayerController = VideoPlayerController.file(chatVideo[0])..initialize().then((_) {
      setState(() { });
      videoPlayerController.play();
    });
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
      var postImageRef = FirebaseStorage.instance.ref().child('adImages');
      UploadTask uploadTask =
          postImageRef.child(DateTime.now().toString() + ".mp4").putFile(img);
      await (await uploadTask)
          .ref
          .getDownloadURL()
          .then((value) => imageLink.add(value.toString()));
      i++;
    }
    if(videoLink.isNotEmpty){
      sendCallBack(videoLink[0],'video').runtimeType;
       
    }
  }




 Future<void> uploadVideo(sendCallBack) async {
    int i = 1;
    for (var video in chatVideo) {
      setState(() {
        val = i / chatVideo.length;
      });
      var postImageRef = FirebaseStorage.instance.ref().child('adImages');
      UploadTask uploadTask =
          postImageRef.child(DateTime.now().toString() + ".jpg").putFile(video);
      await (await uploadTask)
          .ref
          .getDownloadURL()
          .then((value) => videoLink.add(value.toString()));
      i++;
    }
    if(chatVideo.isNotEmpty){
      sendCallBack(chatVideo[0],'video').runtimeType;
       
    }
  }
}

