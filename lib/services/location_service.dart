import 'dart:core';

import 'package:flutter/material.dart';
import 'package:location/location.dart';

import 'storage_manager.dart';
import '../settings.dart';

/// Class provides an access to phone location.
class LocationService extends ChangeNotifier {
  static final String storageKey = "location-enabled";

  /// Location manager.
  static Location _location;

  /// Instance of the singleton pattern design.
  static LocationService instance;

  /// Last known location data.
  LocationData _userLocation;
  static bool _enabled;
  List<Function(LocationData)> _onChangedFunctions = [];

  static Future<void> init() async {
    instance = new LocationService();
    await StorageManager.exists(storageKey).then((value) async {
      if (value) {
        await StorageManager.readData(storageKey).then((value) {
          _enabled = value;
        });
      } else {
        StorageManager.saveData(storageKey, true).then((value) => null);
        _enabled = true;
      }
      if (_enabled) {
        await instance.enableService();
      }
    });
  }

  bool isEnabled() {
    return _enabled;
  }

  Future<void> enableService() async {
    _location = new Location();
    await _location.requestPermission().then((value) async {
      switch (value) {
        case PermissionStatus.granted:
          _enabled = true;
          await StorageManager.saveData(storageKey, true);
          if (!await _location.isBackgroundModeEnabled()) {
            _location.enableBackgroundMode(enable: true);
            _location.changeSettings(interval: intervalLocationChanges);
            _location.onLocationChanged.listen((event) {
              for (Function fn in this._onChangedFunctions) {
                fn(event);
              }
            });
          }
          notifyListeners();
          break;
        default:
          throw new Exception(
              "Veuillez autoriser la géolocalisation pour continuer");
          break;
      }
    });
    await this.refresh();
  }

  Future<void> disableService() async {
    _location.enableBackgroundMode(enable: false);
    _location = null;
    _userLocation = null;
    _enabled = false;
    await StorageManager.saveData(storageKey, false);
    notifyListeners();
  }

  /// Sets the new location.
  /// [value] parameters must be a [LocationData] object.
  void _setLocation(LocationData value) {
    _userLocation = value;
  }

  /// Refreshes the location of the user.
  Future<void> refresh() async {
    await this._getLocation().then((value) => {_setLocation(value)});
  }

  /// Gets the current user location.
  Future<LocationData> _getLocation() async {
    if (_enabled) {
      var currentLocation;
      try {
        currentLocation = await _location.getLocation();
      } catch (error) {
        print(error);
      }
      return currentLocation;
    }
    return null;
  }

  LocationData getLocationDataWithoutFuture() {
    return this._userLocation;
  }

  /// Gets the known location data.
  Future<LocationData> getLocationData({refresh = true}) async {
    if (refresh) {
      await this.refresh();
    }
    return this._userLocation;
  }

  /// Gets a default [Text] widget to display
  /// last known location data.
  Widget getText() {
    if (this._userLocation == null) {
      return Text("No location");
    }
    return Text(this._userLocation.latitude.toString() +
        " " +
        this._userLocation.longitude.toString());
  }

  /// Gets the singleton instance.
  static LocationService getInstance() {
    return instance;
  }

  /// Gets the [Location] object itself.
  Location getLocationObject() {
    if (_enabled) {
      return _location;
    }
    return null;
  }

  void addOnChangedFunction(Function(LocationData) fn) {
    this._onChangedFunctions.add(fn);
  }

  void removeOnChangedFunction(Function(LocationData) fn) {
    this._onChangedFunctions.remove(fn);
  }
}
