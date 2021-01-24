import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'sign_up_form.dart';
import '../../../components/already_have_account_text.dart';
import '../../../components/social_card.dart';
import '../../../helper/keyboard.dart';
import '../../../services/size_config.dart';
import '../../../services/user_manager.dart';

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
                    press: () async {
                      KeyboardUtil.hideKeyboard(context);
                      try {
                        await Provider.of<UserManager>(context, listen: false)
                            .signInWithGoogle();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "Vous êtes désormais inscrit avec votre compte Google")));
                        Navigator.pop(context);
                      } on FirebaseAuthException catch (e) {
                        if (e.code ==
                            'account-exists-with-different-credential') {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "Votre adresse email est déjà assoiciée à un compte existant")));
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Erreur lors de la connection")));
                      }
                    },
                  ),
                  SocalCard(
                    icon: "assets/icons/facebook.svg",
                    press: () async {
                      KeyboardUtil.hideKeyboard(context);
                      try {
                        await Provider.of<UserManager>(context, listen: false)
                            .signInWithFacebook();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "Vous êtes désormais inscrit avec votre compte Facebook")));
                        Navigator.pop(context);
                      } on FirebaseAuthException catch (e) {
                        if (e.code ==
                            'account-exists-with-different-credential') {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "Votre adresse email est déjà assoiciée à un compte existant")));
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Erreur lors de la connection")));
                      }
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
