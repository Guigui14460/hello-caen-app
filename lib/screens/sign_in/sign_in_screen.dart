import 'package:flutter/material.dart';

import 'components/sign_in_body.dart';
import '../../components/app_bar.dart';
import '../../helper/keyboard.dart';

/// Screen displayed when the user try to log in
/// on the application.
class SignInScreen extends StatelessWidget {
  /// Name of the route where is the screen.
  static final String routeName = "/login";

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
        body: SignInBody(),
      ),
    );
  }
}
