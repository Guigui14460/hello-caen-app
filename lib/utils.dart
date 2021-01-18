/// Converts [DateTime] object to a [String] object.
String convertDatetimeToString(DateTime datetime) {
  return "" +
      datetime.day.toString() +
      " " +
      datetime.month.toString() +
      " " +
      datetime.year.toString() +
      " " +
      datetime.hour.toString() +
      " " +
      datetime.minute.toString();
}

/// Converts [String] object to a [DateTime] object.
DateTime convertStringToDatetime(String datetime) {
  return DateTime.parse(datetime);
}
