import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:spotmies_partner/apiCalls/apiExceptions.dart';
import 'package:spotmies_partner/apiCalls/apiUrl.dart';
import 'package:spotmies_partner/models/access_token.dart';
import 'package:spotmies_partner/utilities/shared_preference.dart';

// final uri =
//     Uri.https('www.myurl.com', '/api/v1/test/8019933883', queryParameters);

class Server {
/* -------------------------- GET USER ACCESS TOKEN ------------------------- */
  Future<dynamic> getAccessTokenApi() async {
    log("getting access token");
    dynamic uri = Uri.https(API.host, API.accessToken);
    if (FirebaseAuth.instance.currentUser == null) return null;
    Map<String, String> body = {"uId": FirebaseAuth.instance.currentUser!.uid};
    try {
      dynamic response =
          await http.post(uri, body: body).timeout(Duration(seconds: 30));

      if (response?.statusCode == 200) {
        AccessToken result = AccessToken.fromJson(jsonDecode(response?.body));
        log("token ${result.token}");
        saveToken(result);
        return result;
      }
      return null;
    } on SocketException {
      throw FetchDataException('No Internet Connection', uri.toString());
    } on TimeoutException {
      throw APINotRespondingEXception(
          'API Not Responding in Time', uri.toString());
    }
  }

  Future<String> fetchAccessToken() async {
    if (FirebaseAuth.instance.currentUser == null) return "null";
    dynamic tokenDetails = await getToken();
    if (tokenDetails == null) {
      dynamic result = await getAccessTokenApi();
      if (result == null) return "null";
      return result.token.toString();
    } else {
      tokenDetails = AccessToken.fromJson(tokenDetails);
      if (tokenDetails.authData.exp <=
          (new DateTime.now().millisecondsSinceEpoch / 1000)) {
        dynamic result = await getAccessTokenApi();
        if (result == null) return "null";
        return result.token.toString();
      }
      return tokenDetails.token.toString();
    }
  }

  Future<dynamic> getMethod(String api) async {
    dynamic uri = Uri.https(API.host, api);

    final String accessToken = await fetchAccessToken();
    try {
      dynamic response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $accessToken'},
      ).timeout(Duration(seconds: 30));
      return processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection', uri.toString());
    } on TimeoutException {
      throw APINotRespondingEXception(
          'API Not Responding in Time', uri.toString());
    }
  }

  Future<dynamic> getMethodParems(String api, queryParameters) async {
    var uri = Uri.https(API.host, api, queryParameters);

    print(uri);
    final String accessToken = await fetchAccessToken();
    try {
      dynamic response = await http.get(uri, headers: {
        'Authorization': 'Bearer $accessToken'
      }).timeout(Duration(seconds: 30));
      return processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection', uri.toString());
    } on TimeoutException {
      throw APINotRespondingEXception(
          'API Not Responding in Time', uri.toString());
    }
  }

  Future<dynamic> postMethod(String api, Map<String, dynamic> body) async {
    var uri = Uri.https(API.host, api);
    final String accessToken = await fetchAccessToken();
    try {
      var response = await http.post(uri, body: body, headers: {
        'Authorization': 'Bearer $accessToken'
      }).timeout(Duration(seconds: 30));
      return response;
    } on SocketException {
      throw FetchDataException('No Internet Connection', uri.toString());
    } on TimeoutException {
      throw APINotRespondingEXception(
          'API Not Responding in Time', uri.toString());
    }
  }

  Future<dynamic> post(
    String api,
    String body,
  ) async {
    Uri uri = Uri.https(API.host, api);
    final String accessToken = await fetchAccessToken();

    try {
      var response = await http.post(uri, body: body, headers: {
        'Authorization': 'Bearer $accessToken'
      }).timeout(Duration(seconds: 30));

      return response;
    } on SocketException {
      throw FetchDataException('No Internet Connection', uri.toString());
    } on TimeoutException {
      throw APINotRespondingEXception(
          'API Not Responding in Time', uri.toString());
    }
  }

  Future<dynamic> editMethod(String api, Map<String, dynamic> body) async {
    var uri = Uri.https(API.host, api);
    final String accessToken = await fetchAccessToken();
    try {
      var response = await http.put(uri, body: body, headers: {
        'Authorization': 'Bearer $accessToken'
      }).timeout(Duration(seconds: 30));
      print(processResponse(response));
      return response;
    } on SocketException {
      throw FetchDataException('No Internet Connection', uri.toString());
    } on TimeoutException {
      throw APINotRespondingEXception(
          'API Not Responding in Time', uri.toString());
    }
  }

  Future<dynamic> deleteMethod(String api) async {
    var uri = Uri.https(API.host, api);
    final String accessToken = await fetchAccessToken();

    try {
      var response = await http.delete(uri, headers: {
        'Authorization': 'Bearer $accessToken'
      }).timeout(Duration(seconds: 30));
      return processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection', uri.toString());
    } on TimeoutException {
      throw APINotRespondingEXception(
          'API Not Responding in Time', uri.toString());
    }
  }

  Future<bool> checkStoreIdAvailability(String id) async {
    String api = API.storeAvailabilityCheck;
    Map<String, String> body = {"storeId": id};
    dynamic result = await postMethod(api, body);

    if (result.statusCode == 404) {
      return true;
    }
    return false;
  }

  dynamic processResponse(http.Response response) {
    return response;
    // switch (response.statusCode) {
    //   case 200:
    //     var responseJson = utf8.decode(response.bodyBytes);
    //     print(responseJson);
    //     return responseJson;
    //
    //   case 400:
    //     throw BadRequestException(
    //         utf8.decode(response.bodyBytes), response.request.url.toString());
    //   case 401:
    //   case 403:
    //     throw UnAuthorizedException(
    //         utf8.decode(response.bodyBytes), response.request.url.toString());
    //   case 404:
    //     return null;
    //   case 500:
    //   default:
    //     throw FetchDataException(
    //         'Error occured with with code:${response.statusCode}',
    //         response.request.url.toString());
    // }
  }
}
