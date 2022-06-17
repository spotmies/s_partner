import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spotmies_partner/controllers/chat_controller.dart';
import 'package:spotmies_partner/providers/theme_provider.dart';
import 'package:spotmies_partner/reusable_widgets/audio.dart';
import 'package:spotmies_partner/reusable_widgets/image_viewer.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';
import 'package:spotmies_partner/reusable_widgets/video_widget.dart';
import 'package:spotmies_partner/utilities/constants.dart';
import 'package:url_launcher/url_launcher.dart';

typeofChat(type, message, sender, double hight, double width,
    ChatController chatController, BuildContext context) {
  String isLink = message.toString();
  // bool isPlaying = false;

  if ((isLink.contains('http') ||
          isLink.contains('https') ||
          isLink.contains('.com')) &&
      type == 'text') {
    return TextButton(
        onPressed: () {
          launchUrl(
            Uri(scheme: "https", path: removeHttpFromurl(message)),
            mode: LaunchMode.externalApplication,
          );
        },
        child: TextWid(
            text: message,
            weight: FontWeight.w600,
            color: SpotmiesTheme.onBackground,
            decoration: TextDecoration.underline));
  } else {
    switch (type) {
      case 'text':
        return TextWid(
          text: toBeginningOfSentenceCase(message).toString(),
          size: 16,
          maxlines: 200,
          lSpace: 1,
          color: sender == "partner"
              ? SpotmiesTheme.onBackground
              : sender == "user"
                  ? SpotmiesTheme.secondaryVariant
                  : SpotmiesTheme.surfaceVariant,
          weight: sender == "partner" ? FontWeight.w700 : FontWeight.w600,
        );
      case 'img':
        return InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ImageViewer(imageLink: message)));
            },
            child: Container(
                height: width * 0.55,
                width: width * 0.55,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(message), fit: BoxFit.cover))));

      case 'video':
        return TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Video(videoLink: message)));
            },
            child: Row(
              children: [
                Icon(
                  Icons.slow_motion_video,
                  color: Colors.grey,
                ),
                SizedBox(
                  width: width * 0.05,
                ),
                TextWid(
                    text: 'Play Video',
                    weight: FontWeight.w600,
                    color: SpotmiesTheme.onBackground,
                    decoration: TextDecoration.underline),
              ],
            ));
      case 'audio':
        return TextButton(
            onPressed: () {
              playAudio(context, hight, width, message);
            },
            child: Row(
              children: [
                Icon(
                  Icons.audiotrack,
                  color: Colors.grey,
                ),
                SizedBox(
                  width: width * 0.05,
                ),
                TextWid(
                    text: 'Play Audio',
                    weight: FontWeight.w600,
                    color: SpotmiesTheme.onBackground,
                    decoration: TextDecoration.underline),
              ],
            ));
      case "call":
        return TextWid(
          text: sender != "user" ? "OutGoing Call" : "Incoming Call",
          maxlines: 200,
          lSpace: 1.5,
          color: sender != "user"
              ? SpotmiesTheme.secondary
              : SpotmiesTheme.secondaryVariant,
          weight: sender != "user" ? FontWeight.w600 : FontWeight.w600,
        );
      default:
        return TextWid(
          text: message,
        );
    }
  }
}

Future playAudio(BuildContext context, double hight, double width, message) {
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
            height: hight * 0.2, child: FeatureButtonsView(message: message));
      });
}

Container readReciept(double _width, status) {
  getIcon() {
    switch (status) {
      case 0:
        return Icons.watch_later;
      case 1:
        return Icons.done;
      case 2:
      case 3:
        return Icons.done_all;

      default:
        return Icons.done;
    }
  }

  return Container(
      padding: EdgeInsets.only(right: 5),
      alignment: Alignment.centerRight,
      child: Icon(
        getIcon(),
        // Icons.done,
        // Icons.done_all,
        // Icons.watch_later,
        color: status == 3 ? Colors.blue : Colors.grey[400],
        size: _width * 0.05,
      ));
}
