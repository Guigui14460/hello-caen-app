/// Class which represents an object where we can save data for later use, or avoid requesting databases and servers.
class DataCache {
  /// Data structures where are saved the data.
  static Map<dynamic, Map<dynamic, dynamic>> _cachedData =
      <dynamic, Map<dynamic, dynamic>>{};

  /// Adds or updates the first level entry with a [key] and a [value].
  static void addOrUpdateEntry(dynamic key, dynamic value) {
    if (!_cachedData.containsKey(key)) {
      _cachedData.putIfAbsent(key, () => value);
    } else {
      _cachedData[key] = value;
    }
  }

  /// Adds or updates the second level entry with a [subKey] and a [value] contains in a first level entry of key [key].
  static void addOrUpdateSubEntry(dynamic key, dynamic subKey, dynamic value) {
    if (!_cachedData.containsKey(key)) {
      _cachedData.putIfAbsent(key, () => {subKey: value});
    } else {
      _cachedData[key][subKey] = value;
    }
  }

  /// Removes the first level entry with a [key].
  static void removeEntry(dynamic key) {
    _cachedData.remove(key);
  }

  /// Removes the second level entry with a [subKey] which is contained in a first level entry of key [key].
  static void removeSubEntry(dynamic key, dynamic subKey) {
    if (_cachedData.containsKey(key)) {
      _cachedData[key].remove(subKey);
    }
  }

  /// Gets a first level entry.
  static dynamic getEntry(dynamic key) {
    if (_cachedData.containsKey(key)) {
      return _cachedData[key];
    }
    return null;
  }

  /// Gets a second level entry.
  static dynamic getSubEntry(dynamic key, dynamic subKey) {
    if (_cachedData.containsKey(key) && _cachedData[key].containsKey(subKey)) {
      return _cachedData[key][subKey];
    }
    return null;
  }

  /// Print the cache data in the debug console.
  static void debug({dynamic key, dynamic subKey}) {
    if (key == null) {
      print(_cachedData.toString());
    } else {
      if (subKey == null) {
        print(_cachedData[key].toString());
      } else {
        print(_cachedData[key][subKey].toString());
      }
    }
  }

  /// Clear all the cache.
  static void clear() {
    _cachedData.clear();
  }

  /// Clear the map value associated to the [key].
  static void subClear(dynamic key) {
    if (_cachedData.containsKey(key)) {
      _cachedData.clear();
    }
  }
}
