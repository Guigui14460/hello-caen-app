import 'package:flutter/material.dart';

/// Allow to use the size configuration of any device
/// where the app is running.
class SizeConfig {
  /// Current media query used.
  static MediaQueryData _mediaQueryData = MediaQueryData();

  /// Current width of the screen.
  static double screenWidth = 0;

  /// Current height of the screen.
  static double screenHeight = 0;

  /// Current orientation of the screen.
  static Orientation orientation = Orientation.portrait;

  /// Initialize the attributes via the [context].
  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
  }
}

/// Get the proportionate height of the screen to
/// which are used to develop the app.
/// The [inputHeight] is a number of pixels.
double getProportionateScreenHeight(double inputHeight) {
  double screenHeight = SizeConfig.screenHeight;
  return (inputHeight / 812.0) * screenHeight;
}

/// Get the proportionate width of the screen to
/// which are used to develop the app.
/// The [inputWidth] is a number of pixels.
double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = SizeConfig.screenWidth;
  return (inputWidth / 375.0) * screenWidth;
}
