import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:spotmies_partner/apiCalls/apiUrl.dart';
import 'package:spotmies_partner/models/locationSearchModel.dart';

class PlacesApi {
  static Future<List<Places>> getLoc(String query) async {
    final url = Uri.parse("https://${API.host}/api/geocode/all");
    final response = await http.get(url);
    // List data  = json.decode(response.body);

    if (response.statusCode == 200) {
      final List geoLocations = json.decode(response.body);
      log('API Hit');
      log(geoLocations.toString());

      return geoLocations.map((json) => Places.fromJson(json)).where((geo) {
        final subLocality = geo.subLocality!.toLowerCase();
        final locality = geo.addressLine!.toLowerCase();
        final coord = geo.coordinates.toString();
        final searchLower = query.toLowerCase();

        return subLocality.contains(searchLower) ||
            locality.contains(searchLower) ||
            coord.contains(searchLower);
      }).toList();
    } else {
      throw Exception();
    }
  }

  static Future<List> getAllLocations() async {
    final url = Uri.parse('https://spotmies.herokuapp.com/api/geocode/all');
    final response = await http.get(url);
    // List data  = json.decode(response.body);

    if (response.statusCode == 200) {
      final List geoLocations = json.decode(response.body);
      log('API Hit');
      log(geoLocations.toString());

      return geoLocations;
    } else {
      throw Exception();
    }
  }
}

getArea(String searchAreaName, List geoLocationsList) {
  print(searchAreaName);
  return geoLocationsList.where((geo) {
    final subLocality = geo['subLocality'].toLowerCase();
    final locality = geo['addressLine'].toLowerCase();
    final coord = geo['coordinates'].toString();
    final searchLower = searchAreaName.toLowerCase();

    return subLocality.contains(searchLower) ||
        locality.contains(searchLower) ||
        coord.contains(searchLower);
  }).toList();
}
