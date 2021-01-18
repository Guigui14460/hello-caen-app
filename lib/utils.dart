import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

/// Converts [DateTime] object to a [String] object.
String convertDatetimeToString(DateTime datetime, {bool full = false}) {
  if (!full) {
    return DateFormat("dd-MM-yyyy").format(datetime);
  }
  return DateFormat("dd-MM-yyyy HH:mm").format(datetime);
}

/// Converts [String] object to a [DateTime] object.
DateTime convertStringToDatetime(String datetime, {bool full = false}) {
  if (!full) {
    return DateFormat("dd-MM-yyyy").parse(datetime);
  }
  return DateFormat("dd-MM-yyyy HH:mm").parse(datetime);
}

/// Gets the string of the timeago from a particular
/// datetime.
String getTimeAgoFrom(DateTime time) {
  final int diff =
      DateTime.now().millisecondsSinceEpoch - time.millisecondsSinceEpoch;
  return getTimeAgo(Duration(milliseconds: diff));
}

/// Gets the string of the timeago for a particular
/// duration from now.
String getTimeAgo(Duration time) {
  return timeago.format(DateTime.now().subtract(time));
}
