import 'package:flutter/material.dart';

import 'sign_in_form.dart';
import '../../../components/social_card.dart';
import '../../../components/no_account_text.dart';
import '../../../helper/keyboard.dart';
import '../../../services/size_config.dart';

/// Class to create all widgets of the [SignInScreen].
class SignInBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.02),
              Text(
                "Connectez-vous",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(28),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.02),
              Text(
                "Connectez-vous avec votre adresse email et mot de passe\nou continuez avec un réseaux social",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.08),
              SignInForm(),
              SizedBox(height: SizeConfig.screenHeight * 0.08),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SocalCard(
                    icon: "assets/icons/google.svg",
                    press: () {
                      KeyboardUtil.hideKeyboard(context);
                      print("Google authentication");
                      Navigator.pop(context);
                    },
                  ),
                  SocalCard(
                    icon: "assets/icons/facebook.svg",
                    press: () {
                      KeyboardUtil.hideKeyboard(context);
                      print("Facebook authentication");
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              NoAccountText(),
              SizedBox(height: getProportionateScreenHeight(20)),
            ],
          ),
        ),
      ),
    );
  }
}
