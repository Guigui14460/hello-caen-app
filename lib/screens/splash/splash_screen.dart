import 'package:flutter/material.dart';
import 'package:hello_caen/size_config.dart';
import 'components/body.dart';

class SplashScreen extends StatelessWidget {
  static final String routeName = "/splash";

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      child: Scaffold(
        body: Body(),
      ),
    );
  }
}
