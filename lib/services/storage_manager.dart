import 'package:shared_preferences/shared_preferences.dart';

/// Manager of the local storage of the app.
class StorageManager {
  /// Saves or modifies a [value] to a [key] in the local storage
  /// of the app.
  static Future<void> saveData(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    } else if (value is List<String>) {
      await prefs.setStringList(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else {
      await prefs.setString(key, value.toString());
    }
  }

  /// Reads a [key] from the local storage of the app.
  static Future<dynamic> readData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.get(key);
  }

  /// Deletes a [key] and associated value from the local
  /// storage of the app.
  static Future<bool> deleteData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove(key);
  }

  /// Deletes the local storage of the app.
  static Future<bool> deleteStorage() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.clear();
  }

  /// Verifies if the [key] exists in the local storage.
  static Future<bool> exists(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }
}
