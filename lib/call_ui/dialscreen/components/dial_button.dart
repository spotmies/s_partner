import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotmies_partner/utilities/app_config.dart';

class DialButton extends StatelessWidget {
  const DialButton({
    Key? key,
    required this.iconSrc,
    required this.text,
    required this.press,
  }) : super(key: key);

  final String iconSrc, text;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          width: height(context) * 0.1,
          height: height(context) * 0.1,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(40.0)),
          child: ElevatedButton(
              onPressed: () {
                return press();
              },
              style: ButtonStyle(
                  elevation: MaterialStateProperty.all(2),
                  backgroundColor: MaterialStateProperty.all(
                    Colors.blue,
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                          side: BorderSide(color: Colors.white)))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SvgPicture.asset(
                    iconSrc,
                    color: Colors.white,
                    height: width(context) * 0.1,
                  )
                ],
              )),
        ),
        SizedBox(
          height: height(context) * 0.01,
        ),
        Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontSize: 13,
          ),
        )
      ]),
    );
  }
}
