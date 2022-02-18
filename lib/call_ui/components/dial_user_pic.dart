import 'package:flutter/material.dart';
import 'package:spotmies_partner/call_ui/audioCallWithImage/size.config.dart';
import 'package:spotmies_partner/providers/theme_provider.dart';

class DailUserPic extends StatelessWidget {
  const DailUserPic({
    Key? key,
    this.size = 192,
    required this.image,
  }) : super(key: key);
  final double size;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(35 / 192 * size), //Padding depends on size
      height: getProportionateScreenHeight(245),
      width: getProportionateScreenWidth(200),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [
          SpotmiesTheme.background.withOpacity(0.02),
          SpotmiesTheme.background.withOpacity(0.05),
        ], stops: [
          0.5,
          1
        ]),
      ),
      child: Image.asset(
        image,
        fit: BoxFit.cover,
      ),
    );
  }
}
