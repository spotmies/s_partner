import 'package:flutter/material.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';

class ElevatedButtonWidget extends StatelessWidget {
  final Color? bgColor;
  final Color? textColor;
  final String? buttonName;
  final double? borderRadius;
  final double? minWidth;
  final double? height;
  final Color? borderSideColor;
  final TextStyle? style;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final double? textSize;
  final VoidCallback? onClick;
  final FontWeight? textStyle;
  final double? elevation;
  final bool? allRadius;
  final double? leftRadius;
  final double? rightRadius;

  const ElevatedButtonWidget({
    Key? key,
    this.bgColor,
    this.textColor,
    this.buttonName,
    this.borderRadius,
    this.leftRadius,
    this.rightRadius,
    this.minWidth,
    this.height,
    this.allRadius,
    this.borderSideColor,
    this.style,
    this.leadingIcon,
    this.trailingIcon,
    this.textSize,
    this.textStyle,
    this.onClick,
    this.elevation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return minWidth != null
        ? Container(
            width: minWidth,
            height: height ?? 50.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius ?? 0)),
            child: elevatedbutt(),
          )
        : Container(
            height: height ?? 50.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius ?? 0)),
            child: elevatedbutt(),
          );
  }

  ElevatedButton elevatedbutt() {
    return ElevatedButton(
        onPressed: () {
          return onClick!();
        },
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(elevation ?? 0),
            backgroundColor: MaterialStateProperty.all(
              bgColor ?? Colors.blue,
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: allRadius == true
                        ? BorderRadius.circular(borderRadius ?? 0)
                        : BorderRadius.only(
                            topLeft: Radius.circular(leftRadius ?? 0),
                            topRight: Radius.circular(rightRadius ?? 0)),
                    side: BorderSide(color: borderSideColor ?? Colors.white)))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildLeadingIcon(leadingIcon),
            Text(
              buttonName ?? 'Button',
              style:
                  fonts(textSize ?? 10.0, textStyle, textColor ?? Colors.black),
            ),
            buildTrailingIcon(trailingIcon),
          ],
        ));
  }
}

Widget buildLeadingIcon(Widget? leadingIcon) {
  if (leadingIcon != null) {
    return Row(
      children: <Widget>[leadingIcon, SizedBox(width: 10)],
    );
  }
  return Container();
}

Widget buildTrailingIcon(Widget? trailingIcon) {
  if (trailingIcon != null) {
    return Row(
      children: <Widget>[
        SizedBox(width: 10),
        trailingIcon,
      ],
    );
  }
  return Container();
}
