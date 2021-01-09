import 'package:flutter/material.dart';

import '../../services/size_config.dart';
import 'components/sign_in_body.dart';

/// Screen displayed when the user try to log in
/// on the application.
class SignInScreen extends StatelessWidget {
  /// Name of the route where is the screen.
  static final String routeName = "/login";

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: SignInBody(),
      ),
    );
  }
}
