import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';
import 'package:spotmies_partner/apiCalls/apiCalling.dart';
import 'package:spotmies_partner/apiCalls/apiUrl.dart';
import 'package:spotmies_partner/providers/chat_provider.dart';
import 'package:spotmies_partner/utilities/snackbar.dart';
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

  ChatProvider chatProvider;
  ScrollController scrollController = ScrollController();

  List chatList = [];
  Map targetChat = {};
  Map user = {};
  Map orderDetails = {};
  Map partner = {};
  int msgCount = 20;

  @override
  void initState() {
    chatProvider = Provider.of<ChatProvider>(context, listen: false);

    super.initState();
  }

  cardOnClick(msgId, msgId2, readReceiptObj) {
    log("$msgId $msgId2");

    if (readReceiptObj != "" &&
        chatProvider.getChatDetailsByMsgId(msgId)['pCount'] > 0) {
      log("readdd////////////////////");
      chatProvider.setReadReceipt(readReceiptObj);
    }
    chatProvider.setMsgCount(20);
    chatProvider.resetMessageCount(msgId);
    chatProvider.setMsgId(msgId2);
  }

  void scrollToBottom() {
    Timer(
        Duration(milliseconds: 200),
        () =>
            scrollController.jumpTo(scrollController.position.minScrollExtent));
  }

  getTargetChat(list, msgId) {
    List currentChatData = list.where((i) => i['msgId'] == msgId).toList();

    return currentChatData[0];
  }

  sendMessageHandler(value, String type, msgId) {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    Map<String, String> msgData = {
      'msg': value.toString(),
      'time': timestamp,
      'sender': 'partner',
      'type': typeofData(type)
    };
    Map<String, dynamic> target = {
      'uId': user['uId'],
      'pId': FirebaseAuth.instance.currentUser.uid,
      'msgId': msgId,
      'ordId': targetChat['ordId'],
      'deviceToken': [targetChat['uDetails']['userDeviceToken']],
      'incomingName': targetChat['pDetails']['name'],
      'incomingProfile': targetChat['pDetails']['partnerPic'],
    };
    Map<String, Object> sendPayload = {
      "object": jsonEncode(msgData),
      "target": target
    };
    chatProvider.addnewMessage(sendPayload);
    chatProvider.setSendMessage(sendPayload);
    // scrollToBottom();
  }

  typeofData(type) {
    switch (type) {
      case 'text':
        return 'text';
        break;
      case 'img':
        return 'img';
      case 'video':
        return 'video';
      case 'audio':
        return 'audio';

        break;
      default:
        return 'text';
    }
  }

  getDate(stamp) {
    int timeStamp = stamp.runtimeType == String ? int.parse(stamp) : stamp;
    log(timeStamp.runtimeType.toString());
    var daynow = DateFormat('EEE').format(DateTime.fromMillisecondsSinceEpoch(
        int.parse(DateTime.now().millisecondsSinceEpoch.toString())));
    var daypast = DateFormat('EEE')
        .format(DateTime.fromMillisecondsSinceEpoch(timeStamp));
    if (daypast == daynow) {
      return "Today";
    } else {
      return DateFormat('dd MMM yyyy')
          .format(DateTime.fromMillisecondsSinceEpoch(timeStamp));
    }
  }

  dateCompare(msg1, msg2) {
    var time1 = msg1;
    var time2 = msg2;
    if (time1.runtimeType != int) time1 = int.parse(time1);
    if (time2.runtimeType != int) time2 = int.parse(time2);
    var ct =
        DateFormat('dd').format(DateTime.fromMillisecondsSinceEpoch(time1));
    var pt =
        DateFormat('dd').format(DateTime.fromMillisecondsSinceEpoch(time2));
    var daynow = DateFormat('EEE').format(DateTime.fromMillisecondsSinceEpoch(
        int.parse(DateTime.now().millisecondsSinceEpoch.toString())));
    var daypast =
        DateFormat('EEE').format(DateTime.fromMillisecondsSinceEpoch(time1));
    if (ct != pt) {
      return (daypast == daynow
          ? 'Today'
          : (DateFormat('dd MMM yyyy')
              .format(DateTime.fromMillisecondsSinceEpoch(time1))));
    } else {
      return "false";
    }
  }

  chooseImage(sendCallBack, String msgId) async {
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
    await uploadimage(sendCallBack, msgId);
  }

  pickVideo(sendCallBack, String msgId) async {
    PickedFile pickedFile = await picker.getVideo(
        source: ImageSource.camera, maxDuration: Duration(seconds: 10));
    chatVideo.add(File(pickedFile.path));
    videoPlayerController = VideoPlayerController.file(chatVideo[0]);
    uploadVideo(sendCallBack, msgId);
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

  Future<void> uploadimage(sendCallBack, String msgId) async {
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
      sendCallBack(imageLink[0], 'img', msgId).runtimeType;
    }
  }

  Future<void> uploadVideo(sendCallBack, String msgId) async {
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
      sendCallBack(videoLink[0], 'video', msgId).runtimeType;
    }
  }

  Future<void> audioUpload(
    String filePath,
    Function sendCallBack,
    String msgId,
  ) async {
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
        sendCallBack(audioLink[0], 'audio', msgId).runtimeType;
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

  Future fetchNewChatList() async {
    var response = await Server().getMethod(API.partnerChat);
    if(response.statusCode == 200){
    var chatList = jsonDecode(response.body);
    chatProvider.setChatList2(chatList);
    snackbar(context, "sync with new changes");
    }
    else snackbar(context, "something went wrong");

  }
}
