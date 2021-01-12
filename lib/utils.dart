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

DateTime convertStringToDatetime(String datetime) {
  return DateTime.parse(datetime);
}
