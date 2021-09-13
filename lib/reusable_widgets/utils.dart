import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class Utils{
  static Future<String> downloadFile(String url,String fileName)async{
    final directory = await getApplicationDocumentsDirectory();
    final filepath = '${directory.path}/$fileName';
    final response = await http.get(Uri.parse(url));
    final file  = File(filepath);

    await file.writeAsBytes(response.bodyBytes);
    return filepath;

  }
}