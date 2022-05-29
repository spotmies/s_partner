import 'package:flutter/material.dart';
import 'package:spotmies_partner/reusable_widgets/elevatedButtonWidget.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';

confirmDialog(
  BuildContext context,
  String? title,
  String? brief,
  String? label1,
  String? label2,
  VoidCallback? onClick,
) {
  final _width = MediaQuery.of(context).size.width;
  showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: TextWid(
            text: title ?? "title",
            color: Colors.black,
          ),
          titleTextStyle: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
          actionsOverflowButtonSpacing: 20,
          actions: [
            ElevatedButtonWidget(
              buttonName: label1 ?? "Close",
              textSize: _width * 0.04,
              onClick: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButtonWidget(
                buttonName: label2 ?? "confirm",
                onClick: () {
                  onClick!();
                  Navigator.pop(context);
                }),
          ],
          content: TextWid(text: brief ?? "description", color: Colors.black),
        );
      });
}
