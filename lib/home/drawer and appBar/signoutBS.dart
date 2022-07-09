import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotmies_partner/login/login.dart';
import 'package:spotmies_partner/providers/theme_provider.dart';
import 'package:spotmies_partner/reusable_widgets/elevatedButtonWidget.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';

Future signOut(BuildContext context, double hight, double width) {
  return showModalBottomSheet(
      backgroundColor: SpotmiesTheme.background,
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
          height: hight * 0.45,
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.only(top: 30),
                  height: hight * 0.22,
                  child: SvgPicture.asset('assets/exit.svg')),
              Container(
                height: hight * 0.06,
                child: Center(
                  child: Text(
                    'Are Sure, You Want to Leave the App?',
                    style: fonts(width * 0.04, FontWeight.w600,
                        SpotmiesTheme.secondaryVariant),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                child: ElevatedButtonWidget(
                    bgColor: SpotmiesTheme.primary,
                    minWidth: width,
                    height: hight * 0.06,
                    textColor: SpotmiesTheme.background,
                    buttonName: 'Yes, I Want To Leave',
                    textSize: width * 0.05,
                    textStyle: FontWeight.w600,
                    borderRadius: 5.0,
                    borderSideColor: SpotmiesTheme.primary,
                    // trailingIcon: Icon(Icons.share),
                    onClick: () async {
                      await FirebaseMessaging.instance.deleteToken();
                      await FirebaseAuth.instance.signOut().then((action) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => LoginScreen()),
                            (route) => false);
                      }).catchError((e) {
                        print(e);
                      });
                    }),
              ),
              Container(
                padding: EdgeInsets.all(5),
                child: ElevatedButtonWidget(
                  bgColor: SpotmiesTheme.primaryVariant,
                  minWidth: width,
                  height: hight * 0.06,
                  textColor: SpotmiesTheme.secondaryVariant,
                  buttonName: 'Close',
                  textSize: width * 0.05,
                  textStyle: FontWeight.w600,
                  borderRadius: 5.0,
                  borderSideColor: SpotmiesTheme.primaryVariant,
                  onClick: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      });
}
