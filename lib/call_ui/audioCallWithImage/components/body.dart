import 'package:flutter/material.dart';
import 'package:spotmies_partner/call_ui/components/rounded_button.dart';


import '../constants.dart';
import '../size.config.dart';

class Body extends StatefulWidget {
  Body({this.isDialScreen = false, this.image = "", this.name = "unknown"});
  final bool isDialScreen;
  final String image;
  final String name;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        widget.image != "" //need to put url validator
            ? Image.network(
                widget.image,
                fit: BoxFit.cover,
              )
            : Image.asset(
                "assets/images/full_image.png",
                fit: BoxFit.cover,
              ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: Theme.of(context)
                      .textTheme
                      .headline3
                      .copyWith(color: Colors.white),
                ),
                VerticalSpacing(of: 10),
                Text(
                  !widget.isDialScreen
                      ? "Duration 12:00 ".toUpperCase()
                      : "INCOMING CALL.....",
                  style: TextStyle(color: Colors.white60),
                ),
                Spacer(),
                Visibility(
                  visible: !widget.isDialScreen,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RoundedButton(
                        press: () {},
                        color: Colors.white,
                        iconColor: Colors.black,
                        iconSrc: "assets/icons/Icon Mic.svg",
                      ),
                      RoundedButton(
                        press: () {},
                        color: kRedColor,
                        iconColor: Colors.white,
                        iconSrc: "assets/icons/call_end.svg",
                      ),
                      RoundedButton(
                        press: () {},
                        color: Colors.white,
                        iconColor: Colors.black,
                        iconSrc: "assets/icons/Icon Volume.svg",
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: widget.isDialScreen,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      RoundedButton(
                        press: () {},
                        color: Colors.green,
                        iconColor: Colors.white,
                        iconSrc: "assets/icons/call_accept.svg",
                      ),
                      RoundedButton(
                        press: () {},
                        color: Colors.red,
                        iconColor: Colors.white,
                        iconSrc: "assets/icons/call_end.svg",
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
