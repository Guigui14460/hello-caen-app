import 'package:shared_preferences/shared_preferences.dart';

/// Manager of the local storage of the app.
class StorageManager {
  /// Saves or modifies a [value] to a [key] in the local storage
  /// of the app.
  static void saveData(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is int) {
      prefs.setInt(key, value);
    } else if (value is double) {
      prefs.setDouble(key, value);
    } else if (value is String) {
      prefs.setString(key, value);
    } else if (value is List<String>) {
      prefs.setStringList(key, value);
    } else if (value is bool) {
      prefs.setBool(key, value);
    } else {
      print("Invalid Type");
    }
  }

  /// Reads a [key] from the local storage of the app.
  static Future<dynamic> readData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    dynamic obj = prefs.get(key);
    return obj;
  }

  /// Deletes a [key] and associated value from the local
  /// storage of the app.
  static Future<bool> deleteData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

  /// Deletes the local storage of the app.
  static Future<bool> deleteStorage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }

  /// Verifies if the [key] exists in the local storage.
  static Future<bool> exists(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }
}
