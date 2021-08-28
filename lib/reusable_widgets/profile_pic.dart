import 'package:flutter/material.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic(
      {Key key,
      @required this.profile,
      @required this.name,
      this.status = true})
      : super(key: key);

  final String profile;
  final String name;
  final bool status;
  Widget _activeIcon() {
    if (status) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.all(3),
          width: 16,
          height: 16,
          color: Colors.white,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              color: Color(0xff43ce7d), // flat green
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
    return Container(
      child: profile != null
          ? Stack(
              children: [
                CircleAvatar(
                  radius: 25.0,
                  backgroundImage: NetworkImage(profile ?? ""),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: _activeIcon(),
                ),
              ],
            )
          : Stack(
              children: [
                CircleAvatar(
                  radius: 25.0,
                  child: Center(
                    child: TextWid(
                      text: name[0],
                      size: 30.0,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: _activeIcon(),
                ),
              ],
            ),
    );
  }
}
