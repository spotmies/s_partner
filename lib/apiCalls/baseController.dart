import 'package:flutter/cupertino.dart';
import 'package:spotmies_partner/apiCalls/apiExceptions.dart';
import 'package:spotmies_partner/apiCalls/dialogue_helper.dart';

class BaseController {
  void handleError(error) {
    if (error is BadRequestException) {
      var msg = error.message;
      DialogueHelper.showErrorDialogue(description: msg,context: BuildContext);
    } else if (error is FetchDataException) {
      var msg = error.message;
      DialogueHelper.showErrorDialogue(description: msg,context: BuildContext);
    } else if (error is APINotRespondingEXception) {
      DialogueHelper.showErrorDialogue(description: 'Oops it took longer to respond.',context: BuildContext);
    }
  }
}
