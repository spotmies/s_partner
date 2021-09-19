import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class EditProfileController extends ControllerMVC {
  DateTime pickedDate = DateTime.now();
  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
  setDate(timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
    setState(() {
      pickedDate = date;
    });
  }

  pickDate(BuildContext context) async {
    DateTime date = await showDatePicker(
        confirmText: 'SET DATE',
        context: context,
        initialDate: pickedDate,
        // firstDate: pickedDate,
        firstDate: DateTime(DateTime.now().year - 80, DateTime.now().month - 0,
            DateTime.now().day - 0),
        lastDate: DateTime.now());
    if (date != null) {
      setState(() {
        pickedDate = date;
        print(pickedDate.millisecondsSinceEpoch);
        print(pickedDate);
      });
    }
  }
}
