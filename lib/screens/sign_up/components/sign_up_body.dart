import 'package:flutter/material.dart';

import 'sign_up_form.dart';
import '../../../components/social_card.dart';
import '../../../components/already_have_account_text.dart';
import '../../../helper/keyboard.dart';
import '../../../services/size_config.dart';

class SignUpBody extends StatelessWidget {
  const SignUpBody({Key key}) : super(key: key);

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
                "Inscription",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(28),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.02),
              Text(
                "Inscrivez-vous avec une adresse email \net un mot de passe\nou continuez avec un réseaux social",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.04),
              SignUpForm(),
              SizedBox(height: SizeConfig.screenHeight * 0.04),
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
              AlreadyHaveAnAccountText(),
              SizedBox(height: getProportionateScreenHeight(20)),
            ],
          ),
        ),
      ),
    );
  }
}
