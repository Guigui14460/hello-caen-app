import 'package:flutter/material.dart';

import 'components/sign_up_body.dart';
import '../../components/app_bar.dart';
import '../../helper/keyboard.dart';

class SignUpScreen extends StatelessWidget {
  static String routeName = "/signup";
  const SignUpScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          leading: Icon(Icons.arrow_back),
          leadingCallback: () {
            KeyboardUtil.hideKeyboard(context);
            Navigator.pop(context);
          },
        ),
        body: SignUpBody(),
      ),
    );
  }
}
