import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

date(msg1, msg2) {
  var temp1 = jsonDecode(msg1);
  var temp2 = jsonDecode(msg2);
  var ct = DateFormat('dd').format(
      DateTime.fromMillisecondsSinceEpoch(int.parse(temp1['timestamp'])));
  var pt = DateFormat('dd').format(
      DateTime.fromMillisecondsSinceEpoch(int.parse(temp2['timestamp'])));
  var daynow = DateFormat('EEE').format(DateTime.fromMillisecondsSinceEpoch(
      int.parse(DateTime.now().millisecondsSinceEpoch.toString())));
  var daypast = DateFormat('EEE').format(
      DateTime.fromMillisecondsSinceEpoch(int.parse(temp1['timestamp'])));
  if (ct != pt) {
    return (daypast == daynow
        ? 'Today'
        : (DateFormat('dd MMM yyyy').format(DateTime.fromMillisecondsSinceEpoch(
            int.parse(temp1['timestamp'])))));
  } else {
    return "";
  }
}

class ChatScreen extends StatefulWidget {
  final String value;
  ChatScreen({this.value});
  @override
  _ChatScreenState createState() => _ChatScreenState(value);
}

class _ChatScreenState extends StateMVC<ChatScreen> {
  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  String textInput;
  String value;
  List<File> chatimages = [];
  bool uploading = false;
  double val = 0;
  String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  List imageLink = [];
  DateTime now = DateTime.now();
  _ChatScreenState(this.value);
  @override
  Widget build(BuildContext context) {
    final _hight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('messaging')
                  .doc(value)
                  .update({'pstatus': 0});
              Navigator.of(context).pop();
            }),
        title: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('messaging')
                .doc(value)
                .snapshots(),
            builder: (context, snapshot) {
              var document = snapshot.data;
              return Text(
                  document['uname'] == null ? 'User' : document['uname']);
            }),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('messaging')
              .doc(value)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
            var document = snapshot.data;

            List<String> msgs = List.from(document['body']);

            return ListView(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  height: _hight * 0.87,
                  width: _width * 1,
                  child: ListView.builder(
                      //reverse: true,
                      controller: _scrollController,
                      itemCount: msgs.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        // Iterable()
                        String msgData = msgs[index];
                        var data = jsonDecode(msgData);
                        var date2 = index - 1 == -1 ? index : index - 1;

                        if ((data['sender'] == 'p') &&
                            (data['type'] == 'text')) {
                          return Column(
                            children: [
                              if (date(msgData, msgs[date2]) != '')
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      height: _hight * 0.04,
                                      width: _width * 0.3,
                                      decoration: BoxDecoration(
                                          color: Colors.blueGrey[800],
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                          child: Text(
                                        date(msgData, msgs[date2]),
                                        style: TextStyle(color: Colors.white),
                                      ))),
                                ),

                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                        alignment: Alignment.centerRight,
                                        child: Column(
                                          children: [
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              padding: EdgeInsets.only(
                                                  top: 10, left: 15, right: 15),
                                              width: _width * 0.55,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(15),
                                                    topRight:
                                                        Radius.circular(15),
                                                  )),
                                              child: Text(data['msg']),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(
                                                  bottom: 2, right: 15),
                                              width: _width * 0.55,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(30),

                                                    // bottomLeft:Radius.circular(30)
                                                  )),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(DateFormat.jm().format(DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                          (int.parse(data[
                                                              'timestamp']))))),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        )),
                                  ),
                                ],
                              ),
                              // Text("date")
                            ],
                          );
                        }
                        if ((data['sender'] == 'u') &&
                            (data['type'] == 'text')) {
                          return Column(
                            children: [
                              if (date(msgData, msgs[date2]) != '')
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      height: _hight * 0.04,
                                      width: _width * 0.3,
                                      decoration: BoxDecoration(
                                          color: Colors.blueGrey[800],
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                          child: Text(
                                        date(msgData, msgs[date2]),
                                        style: TextStyle(color: Colors.white),
                                      ))),
                                ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                          children: [
                                            Container(
                                              alignment: Alignment.centerRight,
                                              padding: EdgeInsets.only(
                                                  top: 10, right: 15, left: 15),
                                              width: _width * 0.55,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[100],
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(15),
                                                    topRight:
                                                        Radius.circular(15),
                                                    // bottomRight:
                                                    //     Radius.circular(30)
                                                  )),
                                              child: Text(data['msg']),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(
                                                  bottom: 2, left: 15),
                                              width: _width * 0.55,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[100],
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(30),

                                                    // bottomLeft:Radius.circular(30)
                                                  )),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(DateFormat.jm().format((DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                          (int.parse(data[
                                                              'timestamp'])))))),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            // Text(date(msgData, msgs[date2])),
                                          ],
                                        )),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }
                        if ((data['type'] == 'media') &&
                            (data['sender'] == 'p')) {
                          // List<String> list = data['msg'].length;
                          // List<Widget> widgets = list.map((name) => new Text(name)).toList();
                          return Row(
                            children: [
                              Expanded(
                                  child: Container(
                                alignment: Alignment.centerRight,
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      // height: _hight * 0.3,
                                      width: _width * 0.5,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[50],
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15),
                                          )),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'You ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              )
                                            ],
                                          ),
                                          Image.network(
                                            data['msg'],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.only(bottom: 2, left: 15),
                                      width: _width * 0.5,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[50],
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(30),

                                            // bottomLeft:Radius.circular(30)
                                          )),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(DateFormat.jm().format((DateTime
                                              .fromMillisecondsSinceEpoch(
                                                  (int.parse(
                                                      data['timestamp'])))))),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    )
                                  ],
                                ),
                              )),
                            ],
                          );
                        }
                        if ((data['type'] == 'media') &&
                            (data['sender'] == 'u')) {
                          return Row(
                            children: [
                              Expanded(
                                  child: Container(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      // height: _hight * 0.3,
                                      width: _width * 0.5,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[50],
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15),
                                          )),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'From ' + document['pname'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              )
                                            ],
                                          ),
                                          Image.network(
                                            data['msg'],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.only(bottom: 2, left: 15),
                                      width: _width * 0.55,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[50],
                                          borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(30),

                                            // bottomLeft:Radius.circular(30)
                                          )),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(DateFormat.jm().format((DateTime
                                              .fromMillisecondsSinceEpoch(
                                                  (int.parse(
                                                      data['timestamp'])))))),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    )
                                  ],
                                ),
                              )),
                            ],
                          );
                        } else
                          return Text('Undefined');
                      }),
                  color: Colors.white,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                        padding: EdgeInsets.only(right: 20),
                        height: _hight * 0.035,
                        child: Row(
                          children: [
                            Icon(
                              Icons.done_all,
                              color: document['ustatus'] == 1
                                  ? Colors.greenAccent
                                  : Colors.grey,
                            ),
                            Text(document['ustatus'] == 1 ? 'Seen' : 'Unseen'),
                          ],
                        )),
                  ],
                ),
                Container(
                  // color: Colors.amber,
                  padding: EdgeInsets.all(1),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(5),
                          height: _hight * 0.1,
                          width: _width * 0.8,
                          child: TextField(
                            maxLines: 4,
                            controller: _controller,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              border: new OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(15)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.white)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.white)),
                              hintStyle: TextStyle(fontSize: 17),
                              hintText: 'Type Message......',
                              contentPadding: EdgeInsets.all(20),
                            ),
                            onChanged: (value) {
                              this.textInput = value;
                            },
                          ),
                        ),
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.photo_camera,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            var msgcount = document['umsgcount'];
                            var ustatus = document['ustatus'];

                            bottomappbar(msgcount, ustatus);
                          }),
                      Container(
                        height: _hight * 0.1,
                        width: _width * 0.14,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.blue[900]),
                        padding: EdgeInsets.all(10),
                        child: Center(
                            child: IconButton(
                                icon: Icon(
                                  Icons.send,
                                  size: 25,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  int msgcount = document['umsgcount'] + 1;
                                  _controller.clear();
                                  String timestamp = DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString();
                                  var msgData = {
                                    'msg': textInput,
                                    'timestamp': timestamp,
                                    'sender': 'p',
                                    'type': 'text'
                                  };
                                  String temp = jsonEncode(msgData);
                                  FirebaseFirestore.instance
                                      .collection('messaging')
                                      .doc(value)
                                      .update({
                                    'createdAt': DateTime.now(),
                                    'body': FieldValue.arrayUnion([temp]),
                                    'umsgcount':
                                        document['ustatus'] == 0 ? msgcount : 0,
                                  });
                                })),
                      )
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }

  chooseImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      chatimages.add(File(pickedFile?.path));
    });
    if (pickedFile.path == null) retrieveLostData();
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

  //image upload function
  Future<void> uploadimage() async {
    int i = 1;
    for (var img in chatimages) {
      setState(() {
        val = i / chatimages.length;
      });
      var postImageRef = FirebaseStorage.instance.ref().child('adImages');
      UploadTask uploadTask =
          postImageRef.child(DateTime.now().toString() + ".jpg").putFile(img);
      await (await uploadTask)
          .ref
          .getDownloadURL()
          .then((value) => imageLink.add(value.toString()));
      i++;
    }
  }

  bottomappbar(int msgcount, int ustatus) {
    final _hight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(15),
          ),
        ),
        elevation: 2,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(15),
            height: _hight * 0.50,
            child: Column(
              children: [
                Container(
                    child: Row(
                  children: [
                    Text('Upload images:',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500)),
                  ],
                )),
                SizedBox(
                  height: 10,
                ),
                chatimages == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              icon: Icon(
                                Icons.cloud_upload_outlined,
                                size: 45,
                                color: Colors.grey,
                              ),
                              onPressed: () {}),
                          SizedBox(
                            height: 7,
                          ),
                          Text('Let us know your problem by uploading image')
                        ],
                      )
                    : Column(
                        children: [
                          Container(
                            height: _hight * 0.34,
                            width: _width * 1,
                            child: GridView.builder(
                                itemCount: chatimages.length + 1,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 5),
                                itemBuilder: (context, index) {
                                  return index == 0
                                      ? Center(
                                          child: IconButton(
                                              icon: Icon(Icons.add),
                                              onPressed: () async {
                                                if (!uploading) {
                                                  chooseImage();
                                                  refresh();
                                                }
                                              }),
                                        )
                                      : Stack(
                                          alignment: Alignment.topRight,
                                          children: [
                                              Container(
                                                margin: EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: FileImage(
                                                            chatimages[
                                                                index - 1]),
                                                        fit: BoxFit.cover)),
                                              ),
                                              Positioned(
                                                left: 37.0,
                                                bottom: 37.0,
                                                child: IconButton(
                                                    icon: Icon(
                                                      Icons.remove_circle,
                                                      color:
                                                          Colors.redAccent[200],
                                                    ),
                                                    onPressed: () async {
                                                      chatimages.removeAt(0);

                                                      refresh();
                                                    }),
                                              ),
                                            ]);
                                }),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () async {
                                  await uploadimage();
                                  _controller.clear();

                                  int len = imageLink.length;

                                  for (int i = 0; i <= len; i++) {
                                    var imageData = {
                                      'msg': imageLink[i],
                                      'timestamp': timestamp,
                                      'sender': 'p',
                                      'type': 'media'
                                    };
                                    String temp = jsonEncode(imageData);
                                    await FirebaseFirestore.instance
                                        .collection('messaging')
                                        .doc(value)
                                        .update({
                                      'createdAt': DateTime.now(),
                                      'body': FieldValue.arrayUnion([temp]),
                                      'umsgcount':
                                          ustatus == 0 ? msgcount + 1 : 0,
                                    });

                                    Navigator.pop(context);
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  height: _hight * 0.07,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 2,
                                            offset: Offset(
                                              -2.0,
                                              -1,
                                            ),
                                            color: Colors.grey[50],
                                            spreadRadius: 1.0),
                                        BoxShadow(
                                            blurRadius: 2,
                                            offset: Offset(
                                              2.0,
                                              1,
                                            ),
                                            color: Colors.grey[300],
                                            spreadRadius: 1.0)
                                      ],
                                      color: Colors.white,
                                      shape: BoxShape.circle),
                                  child: Icon(
                                    Icons.send,
                                    color: Colors.blue[900],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
              ],
            ),
          );
        });
  }
}
