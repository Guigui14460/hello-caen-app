import 'package:flutter/material.dart';

import '../constants.dart';
import '../size_config.dart';

/// Allows to use a default button.
/// You can pass differents arguments to create the button.
/// [text] is the label of the button. [width] and [height] are the dimensions of
/// the button in pixels and [fontSize] is the size of the label (modified to fit
/// with the current device). The [press] and [longPress] are callback functions
/// used to interact with it. [width], [fontSize] and [longPress] arguments are
/// optionnal. if you want [width] takes all the available width, you can put a
/// negative value.
class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key key,
    double width = -1,
    @required this.height,
    @required this.text,
    @required this.press,
    this.fontSize = 20,
    this.longPress,
  })  : this.width = (width < 0 ? double.infinity : width),
        super(key: key);

  /// Width of the button.
  final double width;

  /// Height of the button.
  final double height;

  /// Font size of the button text label.
  final double fontSize;

  /// Text label of the button.
  final String text;

  /// Calls when the user press quickly the button.
  final Function press;

  /// Calls when the user press longly the button.
  final Function longPress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getProportionateScreenWidth(width),
      height: getProportionateScreenHeight(height),
      child: TextButton(
        onPressed: press,
        onLongPress: longPress,
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(ternaryColor),
            shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                    side: BorderSide(style: BorderStyle.none),
                    borderRadius: BorderRadius.circular(12))),
            animationDuration: animationDuration),
        child: Text(
          text,
          overflow: TextOverflow.clip,
          style: TextStyle(
            color: primaryColor,
            fontSize: getProportionateScreenHeight(fontSize),
          ),
        ),
      ),
    );
  }
}
