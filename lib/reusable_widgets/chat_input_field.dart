import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:spotmies_partner/controllers/chat_controller.dart';
import 'package:spotmies_partner/reusable_widgets/audio.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';
import 'package:spotmies_partner/utilities/snackbar.dart';

String chatInput;
TextEditingController inputController = TextEditingController();

Container chatInputField(
  sendCallBack,
  BuildContext context,
  double hight,
  double width,
  ChatController chatController, String msgId,
) {
  // SoundRecorder recorder
  // bool isInput = false;

  // var formkey = GlobalKey<FormState>();

  return Container(
    padding: EdgeInsets.all(10),
    color: Colors.transparent,
    height: 70,
    child: Row(
      children: [
        Expanded(
          child: Container(
            // padding: EdgeInsets.symmetric(horizontal: 14),
            height: hight * 0.08,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[200], blurRadius: 2, spreadRadius: 2)
              ],
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      TextField(
                        // readOnly: true,
                        maxLines: 100,

                        style: fonts(
                            width * 0.05, FontWeight.w500, Colors.grey[900]),
                        controller: inputController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          // suffixIcon:
                          prefixIcon: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.mic,
                              color: Colors.grey[500],
                              size: width * 0.07,
                            ),
                          ),
                          border: InputBorder.none,
                          hintStyle: fonts(
                              width * 0.05, FontWeight.w400, Colors.grey[400]),
                          hintText: 'Type Message......',
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: inputController.text.isEmpty
                            ? IconButton(
                                onPressed: () async {
                                  await attachments(
                                    context,
                                    hight,
                                    width,
                                    chatController,
                                    sendCallBack,
                                    msgId
                                  );
                                },
                                icon: Icon(
                                  Icons.attach_file,
                                  color: Colors.grey[500],
                                  size: width * 0.05,
                                ),
                              )
                            : IconButton(
                                onPressed: () {
                                  inputController.clear();
                                },
                                icon: Icon(
                                  Icons.clear,
                                  color: Colors.grey[500],
                                  size: width * 0.05,
                                ),
                              ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: width * 0.03,
        ),
        InkWell(
          onTap: () {
            if (inputController.text == "") {
              snackbar(context, 'Enter Message');
            } else {
              sendCallBack(inputController.text, 'text',msgId);
              inputController.clear();
            }
            log(inputController.text);
          },
          child: CircleAvatar(
            backgroundColor: Colors.blueGrey[500],
            radius: width * 0.065,
            child: Icon(
              Icons.send,
              color: Colors.white,
            ),
          ),
        )
      ],
    ),
  );
}

Future attachments(BuildContext context, double hight, double width,
    ChatController chatController, sendCallBack, String msgId) {
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
          height: hight * 0.1,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    IconButton(
                      onPressed: () async {
                        chatController.chooseImage(sendCallBack,msgId);
                        Navigator.pop(context);

                        // imageGallery(context, chatController);
                      },
                      icon: Icon(Icons.camera),
                    ),
                    TextWid(
                      text: 'Camera',
                      size: width * 0.03,
                    )
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.collections),
                    ),
                    TextWid(
                      text: 'Gallery',
                      size: width * 0.03,
                    )
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        chatController.pickVideo(sendCallBack,msgId);
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.video_camera_back),
                    ),
                    TextWid(
                      text: 'Video',
                      size: width * 0.03,
                    )
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                      Navigator.pop(context);
                        audioRecoder(context, hight, width,chatController,sendCallBack,msgId);
                        
                      },
                      icon: Icon(Icons.mic),
                    ),
                    TextWid(
                      text: 'Audio',
                      size: width * 0.03,
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      });
}

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

// imageGallery(BuildContext context, ChatController chatController) {
//   final _hight = MediaQuery.of(context).size.height -
//       MediaQuery.of(context).padding.top -
//       kToolbarHeight;
//   final _width = MediaQuery.of(context).size.width;
//   showModalBottomSheet(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(
//           top: Radius.circular(15),
//         ),
//       ),
//       elevation: 2,
//       isScrollControlled: true,
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           padding: EdgeInsets.all(15),
//           height: _hight * 0.50,
//           child: Column(
//             children: [
//               Container(
//                   child: Row(
//                 children: [
//                   TextWid(
//                     text: 'Selected Images:',
//                     size: _width * 0.05,
//                     weight: FontWeight.w600,
//                   )
//                 ],
//               )),
//               SizedBox(
//                 height: _hight * 0.01,
//               ),
//               chatController.chatimages.length == 0
//                   ? Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         IconButton(
//                             icon: Icon(
//                               Icons.cloud_upload_outlined,
//                               size: _width * 0.1,
//                               color: Colors.grey,
//                             ),
//                             onPressed: () {
//                               chatController.chooseImage();
//                             }),
//                         SizedBox(
//                           height: _hight * 0.01,
//                         ),
//                         TextWid(
//                           text: 'Let us know your problem by uploading \n Images',
//                           size: _width * 0.04,
//                         )
//                       ],
//                     )
//                   : Column(
//                       children: [
//                         Container(
//                           height: _hight * 0.3,
//                           width: _width * 1,
//                           child: GridView.builder(
//                               itemCount: chatController.chatimages.length + 1,
//                               gridDelegate:
//                                   SliverGridDelegateWithFixedCrossAxisCount(
//                                       mainAxisSpacing: 3.5,
//                                       crossAxisSpacing: 3.5,
//                                       crossAxisCount: 4),
//                               itemBuilder: (context, index) {
//                                 return index == 0
//                                     ? Center(
//                                         child: IconButton(
//                                             icon: Icon(Icons.add),
//                                             onPressed: () async {
//                                               if (!chatController.uploading) {
//                                                 chatController.chooseImage();
//                                                 chatController.refresh();
//                                               } else {
//                                                 return null;
//                                               }
//                                             }),
//                                       )
//                                     : Stack(
//                                         alignment: Alignment.topRight,
//                                         children: [
//                                             Container(
//                                               // margin: EdgeInsets.all(6),
//                                               decoration: BoxDecoration(
//                                                   image: DecorationImage(
//                                                       image: FileImage(
//                                                           chatController
//                                                                   .chatimages[
//                                                               index - 1]),
//                                                       fit: BoxFit.cover)),
//                                             ),
//                                             Positioned(
//                                                 right: 0,
//                                                 top: 0,
//                                                 child: InkWell(
//                                                     onTap: () {
//                                                       chatController.chatimages
//                                                           .removeAt(index-1);

//                                                       chatController.refresh();
//                                                     },
//                                                     child: Icon(
//                                                       Icons.close,
//                                                       size: _width * 0.05,
//                                                       color: Colors.white,
//                                                     ))
                                               
//                                                 ),
//                                           ]);
//                               }),
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             InkWell(
//                               onTap: () async {
//                                 await chatController.uploadimage();
//                                 // _controller.clear();

//                                 int len = chatController.imageLink.length;

//                                 for (int i = 0; i <= len; i++) {
//                                   // var imageData = {
//                                   //   'msg': imageLink[i],
//                                   //   'timestamp': timestamp,
//                                   //   'sender': 'p',
//                                   //   'type': 'media'
//                                   // };
//                                   // String temp = jsonEncode(imageData);
//                                   // await FirebaseFirestore.instance
//                                   //     .collection('messaging')
//                                   //     .doc(value)
//                                   //     .update({
//                                   //   'createdAt': DateTime.now(),
//                                   //   'body': FieldValue.arrayUnion([temp]),
//                                   //   'umsgcount':
//                                   //       uread == 0 ? msgcount + 1 : 0,
//                                   // });

//                                   Navigator.pop(context);
//                                 }
//                               },
//                               child: Container(
//                                 padding: EdgeInsets.all(12),
//                                 height: _hight * 0.07,
//                                 decoration: BoxDecoration(boxShadow: [
//                                   BoxShadow(
//                                       blurRadius: 2,
//                                       offset: Offset(
//                                         -2.0,
//                                         -1,
//                                       ),
//                                       color: Colors.grey[50],
//                                       spreadRadius: 1.0),
//                                   BoxShadow(
//                                       blurRadius: 2,
//                                       offset: Offset(
//                                         2.0,
//                                         1,
//                                       ),
//                                       color: Colors.grey[300],
//                                       spreadRadius: 1.0)
//                                 ], color: Colors.white, shape: BoxShape.circle),
//                                 child: Icon(
//                                   Icons.send,
//                                   color: Colors.blue[900],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//             ],
//           ),
//         );
//       });
// }
