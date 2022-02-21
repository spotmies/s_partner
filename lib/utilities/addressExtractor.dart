// ignore_for_file: file_names

import 'dart:convert';
import 'dart:developer';

addressExtractor(address) {
  Map<String, String> val = {
    "subLocality": "${address.subLocality}",
    "locality": "${address.locality}",
    "latitude": "${address.coordinates.latitude}",
    "logitude": "${address.coordinates.longitude}",
    "addressLine": "${address.addressLine}",
    "subAdminArea": "${address.subAdminArea}",
    "postalCode": "${address.postalCode}",
    "adminArea": "${address.adminArea}",
    "subThoroughfare": "${address.subThoroughfare}",
    "featureName": "${address.featureName}",
    "thoroughfare": "${address.thoroughfare}",
  };
  log(val.toString());
  return val;
}

addressExtractor2(address) {
  Map<String, String> val = {
    "subLocality": address.subLocality.toString(),
    "locality": address.locality.toString(),
    "city": address.locality.toString(),
    "state": address.administrativeArea.toString(),
    "country": address.country.toString(),
    "postalCode": address.postalCode.toString(),
    "addressLine": address.street.toString(),
    "subAdminArea": address.subAdministrativeArea.toString(),
    "subThoroughfare": address.subThoroughfare.toString(),
    "thoroughfare": address.thoroughfare.toString(),
  };
  return val;
}

Map getAddressFromJson(address) {
  try {
    Map<String, dynamic> temp = jsonDecode(address);
    return temp;
  } catch (e) {
    return {
      "locality": "",
      "latitude": "",
      "logitude": "",
      "street": "",
      "subAdminArea": "",
      "postalCode": "",
      "adminArea": "",
      "isoCountrycode": "",
      "from": ""
    };
  }
}
