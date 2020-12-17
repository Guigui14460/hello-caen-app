import 'package:flutter/material.dart';
import 'package:hello_caen/size_config.dart';
import 'components/body.dart';

class SignInScreen extends StatelessWidget {
  static final String routeName = "/login";

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: Body(),
      ),
    );
  }
}
