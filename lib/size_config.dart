import 'package:flutter/material.dart';

/// Dimensions of the Pixel 3a used for development
const width = 1080, height = 2220;

/// Allow to use the size configuration of any device
/// where the app is running.
class SizeConfig {
  /// Current media query used.
  static MediaQueryData _mediaQueryData;

  /// Current width of the screen.
  static double screenWidth;

  /// Current height of the screen.
  static double screenHeight;

  /// Current orientation of the screen.
  static Orientation orientation;

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
  return (inputHeight / height) * screenHeight;
}

/// Get the proportionate width of the screen to
/// which are used to develop the app.
/// The [inputWidth] is a number of pixels.
double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = SizeConfig.screenWidth;
  return (inputWidth / width) * screenWidth;
}
