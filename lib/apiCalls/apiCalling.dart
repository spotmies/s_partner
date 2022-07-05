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

String? dynamic_base_server_url;
String? dynamic_base_socket_url;

class Server {
/* -------------------------- GET USER ACCESS TOKEN ------------------------- */
  Future<dynamic> getAccessTokenApi() async {
    log("getting access token");
    Map<String, dynamic>? query;
    dynamic uri = await getServerUri(API.accessToken, query);
    log("server url" + uri.toString());
    // Uri.https(API.host, API.accessToken);

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

  Future<Uri> getServerUri(String api, Map<String, dynamic>? query) async {
    log(dynamic_base_server_url.toString());
    if (dynamic_base_server_url != null)
      return Uri.https(dynamic_base_server_url.toString(), api,
          {...?query, ...API.defaultQuery});
    try {
      log("getting server url from storage");
      String base_server_url = await getDynamicUrl("base_server_url");
      if (base_server_url != "null") {
        dynamic_base_server_url = base_server_url.toString();
        log("server url dynamic" + base_server_url);
        return Uri.https(dynamic_base_server_url.toString(), api,
            {...?query, ...API.defaultQuery});
      }
      return Uri.https(API.host, api, {...?query, ...API.defaultQuery});
    } catch (e) {
      log("server url err" + e.toString());
      return Uri.https(API.host, api, {...?query, ...API.defaultQuery});
    }
  }

  Future<String> getSocketUrl() async {
    if (dynamic_base_socket_url != null)
      return dynamic_base_server_url.toString();
    final String socketUrl = await getDynamicUrl("base_socket_url");
    if (socketUrl != "null") {
      dynamic_base_socket_url = socketUrl;
      return socketUrl;
    }
    return API.host;
  }

  Future<String> getDynamicUrl(String objId) async {
    // socket = base_socket_url
    // server = base_server_url
    try {
      final dynamic constants = await getAppConstants();
      final List utilities = constants['utilities'] as List;
      final String base_server_url = utilities[utilities
          .indexWhere((element) => element['objId'] == objId)]['value'];
      log("server url " + base_server_url);
      return base_server_url.toString();
    } catch (e) {
      return "null";
    }
  }

  Future<dynamic> getMethod(String api, {Map<String, dynamic>? query}) async {
    // dynamic uri = Uri.https(API.host, api, {...?query, ...API.defaultQuery});
    Uri uri = await getServerUri(api, query);
    log("server url" + uri.toString());
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
    // Uri uri = Uri.https(API.host, api, queryParameters);
    Uri uri = await getServerUri(api, queryParameters);
    log("server url" + uri.toString());
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

  Future<dynamic> postMethod(String api, Map<String, dynamic> body,
      {Map<String, dynamic>? query}) async {
    // Uri uri = Uri.https(API.host, api, {...?query, ...API.defaultQuery});
    Uri uri = await getServerUri(api, query);
    log("server url" + uri.toString());
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

  Future<dynamic> post(String api, String body,
      {Map<String, dynamic>? query}) async {
    // Uri uri = Uri.https(API.host, api, {...?query, ...API.defaultQuery});
    Uri uri = await getServerUri(api, query);
    log("server url" + uri.toString());
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

  Future<dynamic> editMethod(String api, Map<String, dynamic> body,
      {Map<String, dynamic>? query}) async {
    // Uri uri = Uri.https(API.host, api, {...?query, ...API.defaultQuery});
    Uri uri = await getServerUri(api, query);
    log("server url" + uri.toString());
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

  Future<dynamic> deleteMethod(String api,
      {Map<String, dynamic>? query}) async {
    // Uri uri = Uri.https(API.host, api, {...?query, ...API.defaultQuery});
    Uri uri = await getServerUri(api, query);
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
