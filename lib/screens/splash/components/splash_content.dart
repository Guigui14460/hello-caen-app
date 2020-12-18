import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({
    Key key,
    @required this.text,
    @required this.image,
    @required this.imageWidth,
  })  : assert(text != null),
        assert(image != null),
        assert(imageWidth > 0),
        super(key: key);
  final String image, text;
  final double imageWidth;

  @override
  Widget build(BuildContext context) {
    final Widget imageWidget = (image.endsWith("svg")
        ? SvgPicture.asset(image, width: imageWidth)
        : Image.asset(image, width: imageWidth));
    return Column(
      children: [
        Text(text, textAlign: TextAlign.center),
        Spacer(),
        imageWidget,
      ],
    );
  }
}
