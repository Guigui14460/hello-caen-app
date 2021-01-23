import 'package:flutter/material.dart';

import '../constants.dart';
import 'storage_manager.dart';

/// Manages the theme data of the application.
/// Extends [ChangeNotifier] to use it like a provider.
class ThemeManager with ChangeNotifier {
  /// Actual theme currently display on the app.
  ThemeData _themeData;

  /// Gets the actual theme.
  ThemeData getTheme() => _themeData;

  /// Constructor of the manager.
  ThemeManager() {
    StorageManager.exists('themeMode').then((value) {
      if (value) {
        StorageManager.readData('themeMode').then((value) {
          var themeMode = value ?? 'light';
          if (themeMode == 'light') {
            _themeData = _getLightTheme();
          } else {
            _themeData = _getDarkTheme();
          }
          notifyListeners();
        });
      } else {
        setLightMode();
      }
    });
  }

  ThemeData _getDarkTheme() {
    return ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: TextTheme(
          // headline1: TextStyle(color: primaryColor),
          ),
      brightness: Brightness.dark,
      primaryColor: ternaryColor,
      appBarTheme: AppBarTheme(
        elevation: 0.0,
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[900],
      inputDecorationTheme: getInputDecorationTheme(),
    );
  }

  ThemeData _getLightTheme() {
    return ThemeData(
      backgroundColor: Colors.white,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      appBarTheme: AppBarTheme(
        elevation: 0.0,
        centerTitle: true,
      ),
      inputDecorationTheme: getInputDecorationTheme(),
    );
  }

  /// Is in dark mode.
  bool isDarkMode() {
    if (this._themeData == null) {
      return false;
    }
    return this._themeData.brightness == Brightness.dark;
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
    _themeData = _getDarkTheme();
    StorageManager.saveData('themeMode', 'dark');
    notifyListeners();
  }

  /// Set the light mode theme.
  void setLightMode() async {
    _themeData = _getLightTheme();
    StorageManager.saveData('themeMode', 'light');
    notifyListeners();
  }

  InputDecorationTheme getInputDecorationTheme() {
    OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      gapPadding: 10,
      borderSide: BorderSide(
          color: isDarkMode() ? Color(0xff9e9e9e) : Color(0xff6e6e6e)),
    );
    return InputDecorationTheme(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      enabledBorder: border,
      focusedBorder: border,
      border: border,
      errorBorder: border,
    );
  }
}
