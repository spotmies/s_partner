import 'package:flutter/material.dart';

Container chatInputField(sendCallBack) {
  bool isInput = false;
  TextEditingController inputController = TextEditingController();
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
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Type your message ...',
                      hintStyle: TextStyle(color: Colors.grey[500]),
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
            if (inputController.text.isEmpty) return;
            sendCallBack(inputController.text);
            inputController.text = "";
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
