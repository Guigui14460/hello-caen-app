import 'package:flutter/material.dart';

import '../services/size_config.dart';
import '../screens/sign_up/sign_up_screen.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Pas encore de compte ? ",
          style: TextStyle(fontSize: getProportionateScreenWidth(16)),
        ),
        GestureDetector(
          onTap: () =>
              Navigator.pushReplacementNamed(context, SignUpScreen.routeName),
          child: Text(
            "S'inscrire",
            style: TextStyle(
              fontSize: getProportionateScreenWidth(16),
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
