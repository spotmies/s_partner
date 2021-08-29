import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spotmies_partner/utilities/snackbar.dart';

String chatInput;
TextEditingController inputController = TextEditingController();

Container chatInputField(sendCallBack, BuildContext context) {
  // bool isInput = false;

  // var formkey = GlobalKey<FormState>();

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10),
    color: Colors.transparent,
    height: 70,
    child: Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14),
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.mic,
                  color: Colors.grey[500],
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    controller: inputController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(fontSize: 17),
                      hintText: 'Type Message......',
                      contentPadding: EdgeInsets.all(20),
                    ),
                  ),
                ),
                Icon(
                  Icons.attach_file,
                  color: Colors.grey[500],
                )
              ],
            ),
          ),
        ),
        SizedBox(
          width: 16,
        ),
        InkWell(
          onTap: () {
            if (inputController.text == "") {
              snackbar(context, 'Enter Message');
            } else {
              sendCallBack(inputController.text);
              inputController.clear();
            }
            log(inputController.text);
          },
          child: CircleAvatar(
            backgroundColor: Colors.blue,
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
