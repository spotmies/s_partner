import 'dart:convert';
import 'dart:developer';

import 'package:spotmies_partner/apiCalls/apiCalling.dart';
import 'package:spotmies_partner/apiCalls/apiUrl.dart';

faqData() async {
  var response = await Server().getMethod(API.faq);
  if (response.statusCode == 200) {
    var responseDecode = jsonDecode(response.body);
    log(responseDecode.toString());
    return responseDecode;
  }
  return null;
}
