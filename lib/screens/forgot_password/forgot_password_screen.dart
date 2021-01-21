import 'package:flutter/material.dart';

import 'components/forgot_password_body.dart';
import '../../components/app_bar.dart';
import '../../helper/keyboard.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static String routeName = "/forgot-password";
  const ForgotPasswordScreen({Key key}) : super(key: key);

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
        body: ForgotPasswordBody(),
      ),
    );
  }
}
