import 'package:flutter/material.dart';
import 'package:spotmies_partner/utilities/snackbar.dart';

class DialogueHelper {
  static void showErrorDialogue(
      {String title = 'Error', String description = 'Something went wrong',context}) {
    print(description);
    description == 'Something went wrong'
        ? CircularProgressIndicator()
        : snackbar(context, description);
        
       
  }
}
