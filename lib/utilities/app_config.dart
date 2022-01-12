import 'package:flutter/material.dart';

class AppColors {
  static var primaryColorLite = Colors.indigo[900];
  static var secondaryColorLite = Colors.indigo[50];
  static var white = Colors.white;
  static var dark = Colors.grey[900];
  static var grey = Colors.grey;
}

 height(context) {
  return MediaQuery.of(context).size.height -
      MediaQuery.of(context).padding.top -
      kToolbarHeight;
}
 width(context) {
  return MediaQuery.of(context).size.width;
}



class SizeConfig {
  static MediaQueryData?  _mediaQueryData;
  static double?  screenWidth;
  static double?  screenHeight;
  static double?  blockSizeHorizontal;
  static double?  blockSizeVertical;

  static double?  _safeAreaHorizontal;
  static double?  _safeAreaVertical;
  static double?  safeBlockHorizontal;
  static double?  safeBlockVertical;
  static Orientation?  orientation;
  static double?  defaultSize;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData! .size.width;
    screenHeight = _mediaQueryData! .size.height;
    orientation = _mediaQueryData !.orientation;
    // defaultSize = orientation == Orientation.portrait
    //       screenWidth  * 0.03
    //     : screenHeight  * 0.03;
    blockSizeHorizontal = screenWidth!  / 100;
    blockSizeVertical = screenHeight!  / 100;

    _safeAreaHorizontal =
        _mediaQueryData !.padding.left + _mediaQueryData! .padding.right;
    _safeAreaVertical =
        _mediaQueryData !.padding.top + _mediaQueryData! .padding.bottom;
    safeBlockHorizontal = (screenWidth!  - _safeAreaHorizontal! ) / 100;
    safeBlockVertical = (screenHeight!  - _safeAreaVertical! ) / 100;
  }
}
