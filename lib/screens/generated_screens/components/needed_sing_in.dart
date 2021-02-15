import 'package:flutter/material.dart';

import '../../../services/size_config.dart';

class NeededSignIn extends StatelessWidget {
  final String text;
  const NeededSignIn({
    Key key,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(10),
        vertical: getProportionateScreenHeight(10),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
      ),
    );
  }
}
