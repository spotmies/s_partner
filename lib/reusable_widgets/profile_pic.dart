import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic(
      {Key key,
      @required this.profile,
      @required this.name,
      this.bgColor,
      this.size,
      this.textSize,
      this.textColor,
      this.status = true})
      : super(key: key);

  final String profile;
  final String name;
  final bool status;
  final Color bgColor;
  final double textSize;
  final Color textColor;
  final double size;
  Widget _activeIcon(double hight, double width) {
    if (status) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.all(3),
          width: width * 0.04,
          height: width * 0.04,
          color: Colors.white,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              color: Colors.greenAccent, // flat green
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    final _hight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;
    return Container(
      child: profile != null
          ? Stack(
              children: [
                CircleAvatar(
                  backgroundColor:
                      bgColor ??  ([...Colors.primaries]..shuffle()).first,
                  radius: size ?? _width * 0.07,
                  backgroundImage: NetworkImage(profile ?? ""),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: _activeIcon(_hight, _width),
                ),
              ],
            )
          : Stack(
              children: [
                CircleAvatar(
                  backgroundColor: bgColor ?? avatarColor(name[0].toLowerCase()),
                  radius: size ?? _width * 0.07,
                  child: Center(
                    child: TextWid(
                      text: toBeginningOfSentenceCase(name[0]),
                      color:textColor?? Colors.white,
                      size:textSize ?? _width * 0.06,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: _activeIcon(_hight, _width),
                ),
              ],
            ),
    );
  }
}

List colors = [
  Colors.red,
  Colors.green,
  Colors.orange,
  Colors.amber,
  Colors.blue,
  Colors.indigo,
  Colors.pink,
  Colors.blueGrey,
  Colors.lightBlue,
  Colors.redAccent,
  Colors.greenAccent,
  Colors.black,
  Colors.brown,
  Colors.grey,
  Colors.cyanAccent,
  Colors.teal,
  Colors.deepPurple,
  Colors.indigoAccent,
  Colors.purple,
];

avatarColor(String name) {
  if (name == 'a') return colors[1];
  if (name == 'b') return colors[2];
  if (name == 'c') return colors[3];
  if (name == 'd') return colors[4];
  if (name == 'e') return colors[5];
  if (name == 'f') return colors[6];
  if (name == 'g') return colors[7];
  if (name == 'h') return colors[8];
  if (name == 'i') return colors[9];
  if (name == 'j') return colors[10];
  if (name == 'k') return colors[11];
  if (name == 'l') return colors[12];
  if (name == 'm') return colors[13];
  if (name == 'n') return colors[14];
  if (name == 'o') return colors[15];
  if (name == 'p') return colors[16];
  if (name == 'q') return colors[17];
  if (name == 'r') return colors[18];
  if (name == 's') return colors[19];
  if (name == 't') return colors[1];
  if (name == 'u') return colors[2];
  if (name == 'v') return colors[3];
  if (name == 'w') return colors[4];
  if (name == 'x') return colors[5];
  if (name == 'y') return colors[6];
  if (name == 'z') return colors[7];
  
}
