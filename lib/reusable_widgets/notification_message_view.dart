import 'package:flutter/material.dart';

class NotificationMessage extends StatefulWidget {
  final Map? message;
  const NotificationMessage({Key? key, this.message}) : super(key: key);

  @override
  _NotificationMessageState createState() => _NotificationMessageState();
}

class _NotificationMessageState extends State<NotificationMessage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(widget.message.toString()),
    );
  }
}
