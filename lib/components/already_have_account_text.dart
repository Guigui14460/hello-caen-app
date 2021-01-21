import 'package:flutter/material.dart';

import '../services/size_config.dart';
import '../screens/sign_in/sign_in_screen.dart';

class AlreadyHaveAnAccountText extends StatelessWidget {
  const AlreadyHaveAnAccountText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Vous avez déjà un compte ? ",
          style: TextStyle(fontSize: getProportionateScreenWidth(16)),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, SignInScreen.routeName),
          child: Text(
            "Se connecter",
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
