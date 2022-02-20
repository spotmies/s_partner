import 'package:flutter/material.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:share/share.dart';
import 'package:spotmies_partner/controllers/edit_profile_controller.dart';
import 'package:spotmies_partner/home/drawer%20and%20appBar/editDetailsBS.dart';
import 'package:spotmies_partner/home/drawer%20and%20appBar/help&supportBS.dart';
import 'package:spotmies_partner/providers/theme_provider.dart';
import 'package:spotmies_partner/providers/partnerDetailsProvider.dart';
import 'package:spotmies_partner/reusable_widgets/elevatedButtonWidget.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';
import 'package:spotmies_partner/utilities/app_config.dart';
import 'package:spotmies_partner/utilities/snackbar.dart';

import '../home/drawer and appBar/catalog_list.dart';

Color colora = ([...Colors.primaries]..shuffle()).first;
Color colorb = ([...Colors.primaries]..shuffle()).first;

class MessageCard extends StatefulWidget {
  final int? statusCode;
  final dynamic alertMessage;
  final String? type;
  final VoidCallback? onClick;
  final dynamic pd;
  const MessageCard(
      {Key? key,
      this.statusCode,
      this.alertMessage,
      this.type,
      this.onClick,
      this.pd})
      : super(key: key);

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 15, right: 15, top: 10),
        padding: EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 10),
        decoration: BoxDecoration(
            color: SpotmiesTheme.background,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(children: [
          Container(
            width: width(context) * 0.87,
            child: ListTile(
              // minVerticalPadding: 0,

              horizontalTitleGap: height(context) * 0.01,
              title: TextWid(
                text: widget.type != 'offline'
                    ? 'Hey, you got message!'
                    : 'Your account status',
                size: width(context) * 0.04,
                weight: FontWeight.w600,
                lineSpace: 2.0,
              ),
              subtitle: TextWid(
                text: widget.type != 'offline'
                    ? widget.alertMessage.toString()
                    : verifyText(widget.statusCode),
                flow: TextOverflow.visible,
                size: width(context) * 0.04,
                // align: TextAlign.center,
              ),
              leading: CircleAvatar(
                radius: width(context) * 0.08,
                backgroundColor: widget.type == 'offline' ? colora : colorb,
                child: Icon(
                  widget.type != 'offline' ? Icons.chat_bubble : Icons.info,
                  color: SpotmiesTheme.background,
                ),
              ),
              trailing: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  onPressed: () {
                    // this.widget.onClick!();
                    helpAndSupport(context, widget.pd);
                  },
                  icon: Icon(Icons.help)),
            ),
          ),
          Container(
            width: width(context) * 0.015,
            margin: EdgeInsets.only(
                top: width(context) * 0.03, bottom: width(context) * 0.03),
            decoration: BoxDecoration(
                color: widget.type == 'offline' ? colora : colorb,
                borderRadius: BorderRadius.circular(5)),
          ),
        ]));
  }
}

verifyText(value) {
  switch (value) {
    case 0:
      return 'Your business profile successfully sumbitted to spotmies, shortly your profile sent to verification team, till then please keep checking your app';
    case 1:
      return 'your account is under verification. It might take upto 24 to 48 hours, till then please keep checking your app every 6 hours.';
    case 2:
      return 'Your application rejected due to inappropriate profile picture.\nGo to side menu > edit profile > change profile picture';
    case 3:
      return 'Your application rejected due to invalid mail id.\nGo to side menu > edit profile > change Email id';
    case 4:
      return 'Your application rejected due to inappropriate aadhar front image.\nGo to side menu > edit profile > change aadhar front image';
    case 5:
      return 'Your application rejected due to inappropriate aadhar back image.\nGo to side menu > edit profile > change aadhar back image';
    case 6:
      return 'Your application rejected due to invalid alternate mobile number.\nGo to side menu > edit profile > change alternate mobile number';
    case 7:
      return 'Oops';
    case 8:
      return 'Oops';
    case 9:
      return 'Oops';
    case 10:
      return 'Your document verication process completed successfully';
    default:
  }
}

