import 'package:flutter/material.dart';

import '../constants.dart';
import 'storage_manager.dart';

/// Manage the theme data of the application.
/// Extends [ChangeNotifier] to use it like a provider.
class ThemeManager with ChangeNotifier {
  /// Dark theme of the app.
  final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white12,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: TextTheme(
        // headline1: TextStyle(color: primaryColor),
        ),
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    appBarTheme: AppBarTheme(backgroundColor: Colors.white12),
  );

  /// Light theme of the app.
  final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    brightness: Brightness.light,
    primaryColor: primaryColor,
    appBarTheme: AppBarTheme(backgroundColor: Colors.white),
  );

  /// Actual theme currently display on the app.
  ThemeData _themeData;

  /// Gets the actual theme.
  ThemeData getTheme() => _themeData;

  /// Constructor of the manager.
  ThemeManager() {
    StorageManager.readData('themeMode').then((value) {
      var themeMode = value ?? 'light';
      if (themeMode == 'light') {
        _themeData = lightTheme;
      } else {
        _themeData = darkTheme;
      }
      notifyListeners();
    });
  }

  /// Toggle the theme mode between light and dark themes.
  void toggleThemeMode() async {
    StorageManager.readData('themeMode').then((value) {
      var themeMode = value ?? 'light';
      if (themeMode == 'light') {
        setDarkMode();
      } else {
        setLightMode();
      }
    });
  }

  /// Set the dark mode theme.
  void setDarkMode() async {
    _themeData = darkTheme;
    StorageManager.saveData('themeMode', 'dark');
    notifyListeners();
  }

  /// Set the light mode theme.
  void setLightMode() async {
    _themeData = lightTheme;
    StorageManager.saveData('themeMode', 'light');
    notifyListeners();
  }
}
