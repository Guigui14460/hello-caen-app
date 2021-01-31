import 'dart:math' show cos, sqrt, sin, pi, atan2;

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:latlong/latlong.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'settings.dart';

/// Converts [DateTime] object to a [String] object.
String convertDatetimeToString(DateTime datetime, {bool full = false}) {
  if (datetime == null) {
    return "";
  }
  if (!full) {
    return DateFormat("dd-MM-yyyy").format(datetime);
  }
  return DateFormat("dd-MM-yyyy HH:mm").format(datetime);
}

/// Converts [String] object to a [DateTime] object.
DateTime convertStringToDatetime(String datetime, {bool full = false}) {
  if (datetime == "") {
    return null;
  }
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

/// Copy [data] to the clipboard.
Future<void> copyData(String data) async {
  await Clipboard.setData(
    ClipboardData(text: data),
  );
}

double R = 6371; // Radius of the earth in km
double getDistanceFromLatLonInKm(lat1, lon1, lat2, lon2) {
  double dLat = deg2rad(lat2 - lat1); // deg2rad below
  double dLon = deg2rad(lon2 - lon1);
  double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return R * c; // Distance in km
}

double deg2rad(double deg) {
  return deg * (pi / 180);
}

List<LatLng> searchBorderBox(double latitude, double longitude) {
  double degreedeltalat =
      0.001 * (maximalDistanceToSeeStore / 2.0) * cos(longitude);
  double degreedeltalon =
      0.001 * (maximalDistanceToSeeStore / 2.0) * cos(latitude);
  return [
    LatLng(latitude - degreedeltalat, longitude - degreedeltalon),
    LatLng(latitude + degreedeltalat, longitude + degreedeltalon)
  ];
}
