import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

getTime(timeStamp) {
  if(timeStamp == null){
    log(timeStamp);
    return '';
  }
  return DateFormat.jm().format(
      DateTime.fromMillisecondsSinceEpoch((int.parse(timeStamp.toString()))));
}
