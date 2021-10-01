import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:spotmies_partner/chat/personal_chat_ui_methods.dart';
import 'package:spotmies_partner/chat/userDetails.dart';
import 'package:spotmies_partner/controllers/chat_controller.dart';
import 'package:spotmies_partner/internet_calling/calling.dart';
import 'package:spotmies_partner/reusable_widgets/bottom_options_menu.dart';
import 'package:spotmies_partner/reusable_widgets/chat_input_field.dart';
import 'package:provider/provider.dart';
import 'package:spotmies_partner/providers/chat_provider.dart';
import 'package:spotmies_partner/reusable_widgets/date_formates.dart';
import 'package:spotmies_partner/reusable_widgets/profile_pic.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';

class PersonalChat extends StatefulWidget {
  final String msgId;
  PersonalChat(this.msgId);
  @override
  _PersonalChatState createState() => _PersonalChatState();
}

class _PersonalChatState extends StateMVC<PersonalChat> {
  ChatController _chatController;
  _PersonalChatState() : super(ChatController()) {
    this._chatController = controller;
  }
  List bottomMenuOptions = [
    {
      "name": "view order",
      "icon": Icons.remove_red_eye,
      "onPress": () {
        print("view order");
      }
    },
    {
      "name": "Partner details",
      "icon": Icons.account_circle,
      "onPress": () {
        print("Partner details");
      }
    },
    {
      "name": "Disable chat",
      "icon": Icons.block,
      "onPress": () {
        print("Disable chat");
      }
    },
    {
      "name": "Delete chat",
      "icon": Icons.delete_forever,
      "onPress": () {
        print("Delete chat");
      }
    },
  ];
  // final recorder = SoundRecorder();
  @override
  void initState() {
    super.initState();
    _chatController.chatProvider =
        Provider.of<ChatProvider>(context, listen: false);

    _chatController.scrollController.addListener(() {
      if (_chatController.scrollController.position.pixels ==
          _chatController.scrollController.position.maxScrollExtent) {
        // log("at top >>>");
        _chatController.chatProvider
            .setMsgCount(_chatController.chatProvider.getMsgCount() + 20);
      }
      if (_chatController.scrollController.position.pixels < 40) {
        // log('disable float >>>>>>>>>>>>');
        if (_chatController.chatProvider.getFloat())
          _chatController.chatProvider.setFloat(false);
      } else if (_chatController.scrollController.position.pixels > 40) {
        if (!_chatController.chatProvider.getFloat()) {
          _chatController.chatProvider.setFloat(true);
          // log('en float >>>>>>>>>>>>');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    log("======== render chat screen =============");
    final _hight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;
    log(_chatController.isUploading.toString());
    return Scaffold(
        key: _chatController.scaffoldkey,
        appBar: _buildAppBar(context, _hight, _width),
        body: Consumer<ChatProvider>(builder: (context, data, child) {
          _chatController.chatList = data.getChatList2();
          _chatController.targetChat = _chatController.getTargetChat(
              _chatController.chatList, widget.msgId);
          _chatController.user = _chatController.targetChat['uDetails'];
          _chatController.partner = _chatController.targetChat['pDetails'];
          List messages = _chatController.targetChat['msgs'];
          return Container(
            child: Column(children: [
              Expanded(
                child: Container(
                    child: ListView.builder(
                        reverse: true,
                        controller: _chatController.scrollController,
                        itemCount: data.getMsgCount() < messages.length
                            ? data.getMsgCount()
                            : messages.length,
                        itemBuilder: (BuildContext context, int index) {
                          Map rawMsgData = jsonDecode(
                              messages[(messages.length - 1) - index]);
                          // Map rawMsgDataprev = rawMsgData;

                          Map rawMsgDataprev;
                          if (index == messages.length - 1) {
                            rawMsgDataprev = rawMsgData;
                          } else {
                            rawMsgDataprev = jsonDecode(
                                messages[(messages.length - 1) - (index + 1)]);
                          }
                          String message = rawMsgData['msg'];
                          String sender = rawMsgData['sender'];
                          String type = rawMsgData['type'];

                          return Container(
                            padding: EdgeInsets.only(
                                left: sender == "user" ? 10 : 0,
                                bottom: 5,
                                right: sender == "user" ? 0 : 10),
                            child: Column(
                              children: [
                                Visibility(
                                  visible: _chatController.dateCompare(
                                              rawMsgData['time'],
                                              rawMsgDataprev['time']) !=
                                          "false" ||
                                      index == messages.length - 1,
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(top: 30, bottom: 30),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey[900],
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          padding: EdgeInsets.only(
                                              right: 20,
                                              left: 20,
                                              top: 7,
                                              bottom: 7),
                                          alignment: Alignment.center,
                                          child: TextWid(
                                            text: index == messages.length - 1
                                                ? _chatController
                                                    .getDate(rawMsgData['time'])
                                                : _chatController.dateCompare(
                                                    rawMsgData['time'],
                                                    rawMsgDataprev['time']),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: sender == "user"
                                      ? MainAxisAlignment.start
                                      : sender == "partner"
                                          ? MainAxisAlignment.end
                                          : MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          constraints: BoxConstraints(
                                            minHeight: _hight * 0.05,
                                            minWidth: 30,
                                            maxWidth: _width * 0.55,
                                          ),
                                          decoration: BoxDecoration(
                                              color: sender == "user"
                                                  ? Colors.white
                                                  : sender == "partner"
                                                      ? Colors.blueGrey[50]
                                                      : Colors.grey[900],
                                              border: Border.all(
                                                  color: Colors.blueGrey[500],
                                                  width: 0.3),
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(15),
                                                  topRight: Radius.circular(15),
                                                  bottomRight: Radius.circular(
                                                      sender == "user"
                                                          ? 15
                                                          : 0),
                                                  bottomLeft: Radius.circular(
                                                      sender != "user"
                                                          ? 15
                                                          : 0))),
                                          child: Column(
                                            children: [
                                              sender == "user" ||
                                                      sender == "partner"
                                                  ? Container(
                                                      padding: EdgeInsets.only(
                                                        left: 10,
                                                        top: 5,
                                                      ),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: TextWid(
                                                        weight: FontWeight.w800,
                                                        color: Colors.grey[600],
                                                        text: sender ==
                                                                'partner'
                                                            ? 'You'
                                                            : _chatController
                                                                .user['name'],
                                                      ))
                                                  : Container(),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 10,
                                                    top: 10,
                                                    right: 10),
                                                alignment: Alignment.centerLeft,
                                                child: typeofChat(
                                                    type,
                                                    message,
                                                    sender,
                                                    _hight,
                                                    _width,
                                                    _chatController,
                                                    context),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    right: 10, top: 5),
                                                alignment:
                                                    Alignment.centerRight,
                                                child: TextWid(
                                                  text: getTime(
                                                      rawMsgData['time']),
                                                  size: _width * 0.03,
                                                  color: sender != "user"
                                                      ? Colors.grey[500]
                                                      : Colors.grey[500],
                                                  weight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible:
                                              index == 0 && sender == "partner",
                                          child: readReciept(
                                              _width,
                                              _chatController
                                                  .targetChat['pState']),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        })),
              ),
              _chatController.targetChat['cBuild'] == 1
                  ? chatInputField(_chatController.sendMessageHandler, context,
                      _hight, _width, _chatController, widget.msgId)
                  : Container(
                      child: TextWid(
                          text:
                              "You can't chat because user might be disabled or order completed"),
                    )
            ]),
          );
        }),
        floatingActionButton: Container(
          height: _hight * 0.2,
          padding: EdgeInsets.only(bottom: _hight * 0.1),
          child: Consumer<ChatProvider>(
            builder: (context, data, child) {
              return data.getFloat()
                  ? FloatingActionButton(
                      elevation: 0,
                      mini: true,
                      backgroundColor: Colors.white,
                      onPressed: () {
                        _chatController.scrollToBottom();
                      },
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.blue[900],
                        size: _width * 0.07,
                      ),
                    )
                  : Container();
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat);
  }

  Widget _buildAppBar(BuildContext context, double hight, double width) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.grey[50],
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          )),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MyCalling(
                      msgId: widget.msgId,
                      ordId: _chatController.targetChat['ordId'],
                      uId: _chatController.user['uId'],
                      pId: FirebaseAuth.instance.currentUser.uid,
                      isIncoming: false,
                      name: _chatController.user['name'],
                      profile: _chatController.user['pic'],
                      userDeviceToken:_chatController.user['userDeviceToken'].toString()
                     
                    )));
          },
          icon: Icon(
            Icons.phone,
            color: Colors.grey[900],
          ),
        ),
        IconButton(
            padding: EdgeInsets.only(bottom: 0),
            icon: Icon(
              Icons.more_vert,
              color: Colors.grey[900],
            ),
            onPressed: () {
              bottomOptionsMenu(context,
                  options: bottomMenuOptions, menuTitle: "More options");
            })
      ],
      title: Consumer<ChatProvider>(
        builder: (context, data, child) {
          _chatController.chatList = data.getChatList2();
          _chatController.targetChat = _chatController.getTargetChat(
              _chatController.chatList, widget.msgId);
          _chatController.user = _chatController.targetChat['uDetails'];
          // log(user.toString());
          return InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      UserDetails(userDetails: _chatController.user)));
            },
            child: Row(
              children: [
                ProfilePic(
                  name: _chatController.user['name'],
                  profile: _chatController.user['pic'],
                  status: false,
                  badge: false,
                  bgColor: Colors.blueGrey[600],
                  size: width * 0.045,
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                    child: TextWid(
                  text: _chatController.user['name'] ?? "Spotmies User",
                  size: width * 0.058,
                  weight: FontWeight.w600,
                )),
              ],
            ),
          );
        },
      ),
    );
  }
}
