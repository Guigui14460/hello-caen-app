import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../forgot_password/forgot_password_screen.dart';
import '../../../constants.dart';
import '../../../components/default_button.dart';
import '../../../components/form_error.dart';
import '../../../helper/keyboard.dart';
import '../../../services/firebase_settings.dart';
import '../../../services/size_config.dart';

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
  final List<String> errors = [];

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(20)),
          Row(
            children: [
              Spacer(),
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                    context, ForgotPasswordScreen.routeName),
                child: Text(
                  "Mot de passe oublié ?",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          SizedBox(height: getProportionateScreenHeight(20)),
          FormError(errors: errors),
          DefaultButton(
            text: 'Continuer',
            height: getProportionateScreenHeight(50),
            longPress: () {},
            press: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                KeyboardUtil.hideKeyboard(context);
                try {
                  await FirebaseSettings.instance
                      .getAuth()
                      .signInWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Vous êtes connecté")));
                  Navigator.pop(context);
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    addError(error: kUserNotFound);
                  } else if (e.code == 'wrong-password') {
                    addError(error: kWrongPassword);
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Erreur lors de la connection")));
                }
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        removeError(error: kWrongPassword);
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= minimumPasswordLength) {
          removeError(error: kShortPassError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
        } else if (value.length < minimumPasswordLength) {
          addError(error: kShortPassError);
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: "Entrez votre mot de passe",
        labelText: "Mot de passe",
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        removeError(error: kUserNotFound);
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kEmailNullError);
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: "Entrez votre adresse email",
        labelText: "Email",
      ),
    );
  }
}
