import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:spotmies_partner/apiCalls/apiExceptions.dart';
import 'package:spotmies_partner/apiCalls/apiUrl.dart';

// final uri =
//     Uri.https('www.myurl.com', '/api/v1/test/8019933883', queryParameters);

class Server {
  Future<dynamic> getMethod(String api) async {
    var uri = Uri.https(API.host, api);

    print(uri);

    try {
      var response = await http.get(uri).timeout(Duration(seconds: 30));
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

    try {
      var response = await http.get(uri).timeout(Duration(seconds: 30));
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
    // var bodyData = json.encode(body);
    try {
      var response =
          await http.post(uri, body: body).timeout(Duration(seconds: 30));
      log(processResponse(response).toString());
      log(response.statusCode.toString());

      //return processResponse(response);
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
    var uri = Uri.https(API.host, api);
    // var bodyData = json.encode(body);
    try {
      var response =
          await http.post(uri, body: body).timeout(Duration(seconds: 30));
      log(processResponse(response).toString());
      log(response.statusCode.toString());

      //return processResponse(response);
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
    // var bodyData = json.encode(body);
    try {
      var response =
          await http.put(uri, body: body).timeout(Duration(seconds: 30));
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

    try {
      var response = await http.delete(uri).timeout(Duration(seconds: 30));
      return processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection', uri.toString());
    } on TimeoutException {
      throw APINotRespondingEXception(
          'API Not Responding in Time', uri.toString());
    }
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
