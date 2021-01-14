import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// Class allows to display a explanations content
/// to the users.
class ExplanationsContent extends StatelessWidget {
  /// Constructor.
  /// [text] parameter is the text to display at the top.
  /// [imageUrl] parameter is the image URL which is a pointer
  /// to the image to display (can be a svg, png or jpg)
  /// image format.
  /// [imageWidth] parameter is the width of the image
  /// (height is calculated automatically).
  const ExplanationsContent({
    @required this.text,
    @required this.imageUrl,
    @required this.imageWidth,
  }) : assert(imageWidth > 0);
  final String imageUrl, text;
  final double imageWidth;

  @override
  Widget build(BuildContext context) {
    final Widget imageWidget = (imageUrl.endsWith("svg")
        ? SvgPicture.asset(imageUrl, width: imageWidth)
        : Image.asset(imageUrl, width: imageWidth));
    return Column(
      children: [
        Text(text, textAlign: TextAlign.center),
        Spacer(),
        imageWidget,
      ],
    );
  }
}
