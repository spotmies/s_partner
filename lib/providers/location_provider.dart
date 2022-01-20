import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:spotmies_partner/utilities/shared_preference.dart';

class LocationProvider extends ChangeNotifier {
  Position? position;
  bool loader = true;

  bool get getLoader => loader;
  void setLoader(state) {
    loader = state;
    notifyListeners();
  }

  void setLocation(geoLoc) {
    position = geoLoc;

    loader = false;
    notifyListeners();
    saveLocation(geoLoc);
  }

  dynamic get getLocation => position;
}
