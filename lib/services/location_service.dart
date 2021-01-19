import 'dart:core';

import 'package:flutter/material.dart';
import 'package:location/location.dart';

/// Class provides an access to phone location.
class LocationService {
  /// Location manager.
  static Location _location = new Location();

  /// Instance of the singleton pattern design.
  static LocationService _instance = new LocationService();

  /// Last known location data.
  LocationData userLocation;

  /// Sets the new location.
  /// [value] parameters must be a [LocationData] object.
  void _setLocation(value) {
    this.userLocation = value;
  }

  /// Refreshes the location of the user.
  Future<void> refresh() async {
    await this._getLocation().then((value) => {_setLocation(value)});
  }

  /// Gets the current user location.
  Future<LocationData> _getLocation() async {
    var currentLocation;
    try {
      currentLocation = await _location.getLocation();
    } catch (e) {
      print(e);
    }
    return currentLocation;
  }

  /// Gets the known location data.
  Future<LocationData> getLocationData({refresh = true}) async {
    if (refresh) {
      await this.refresh();
    }
    return this.userLocation;
  }

  /// Gets a default [Text] widget to display
  /// last known location data.
  Widget getText() {
    if (this.userLocation == null) {
      return Text("No location");
    }
    return Text(this.userLocation.latitude.toString() +
        " " +
        this.userLocation.longitude.toString());
  }

  /// Gets the singleton instance.
  static LocationService getInstance() {
    return _instance;
  }

  /// Gets the [Location] object itself.
  static Location getLocationObject() {
    return _location;
  }
}
