import 'package:intl/intl.dart';

getTime(timeStamp) {
  return DateFormat.jm().format(
      DateTime.fromMillisecondsSinceEpoch((int.parse(timeStamp.toString()))));
}
