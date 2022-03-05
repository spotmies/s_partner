import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:spotmies_partner/providers/theme_provider.dart';
import 'package:spotmies_partner/reusable_widgets/text_wid.dart';

class ProgressWaiter extends StatelessWidget {
  ProgressWaiter(
      {required this.contextt,
      required this.loaderState,
      this.loadingName = "Please Wait..."});

  final BuildContext contextt;
  final bool loaderState;
  final String loadingName;

  @override
  Widget build(BuildContext context) {
    print("1233 - $loaderState");
    final _width = MediaQuery.of(contextt).size.width;
    return Visibility(
      visible: loaderState,
      // visible: true,
      child: Positioned.fill(
          child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
        child: AbsorbPointer(
          absorbing: loaderState,
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                strokeWidth: 6.0,
                backgroundColor: SpotmiesTheme.background,
              ),
              Container(
                padding: EdgeInsets.only(top: 20),
                child: TextWid(
                  text: loadingName,
                  color: SpotmiesTheme.onBackground,
                  weight: FontWeight.bold,
                  size: _width * 0.06,
                ),
              ),
            ],
          )),
        ),
      )),
    );
  }
}
