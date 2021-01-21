import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../services/size_config.dart';
import '../../../constants.dart';
import '../../../services/firebase_settings.dart';
import '../../../components/default_button.dart';
import '../../../components/form_error.dart';
import '../../../components/no_account_text.dart';
import '../../../helper/keyboard.dart';

class ForgotPasswordBody extends StatelessWidget {
  const ForgotPasswordBody({Key key}) : super(key: key);

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
                "Mot de passe oublié",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(28),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Veuillez entrer votre adresse email et nous \nvous enverrons un lien pour \nretrouver votre compte",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.1),
              ForgotPassForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class ForgotPassForm extends StatefulWidget {
  @override
  _ForgotPassFormState createState() => _ForgotPassFormState();
}

class _ForgotPassFormState extends State<ForgotPassForm> {
  final _formKey = GlobalKey<FormState>();
  String email;
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
          FormError(errors: errors),
          SizedBox(height: SizeConfig.screenHeight * 0.1),
          DefaultButton(
            text: "Continuer",
            height: getProportionateScreenHeight(50),
            press: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                KeyboardUtil.hideKeyboard(context);
                try {
                  await FirebaseSettings.instance
                      .getAuth()
                      .sendPasswordResetEmail(email: email);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "Email de réinitialisation envoyé à l'adresse $email")));
                  Navigator.pop(context);
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    addError(error: kUserNotFound);
                  }
                }
              }
            },
            longPress: () {},
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.1),
          NoAccountText(),
        ],
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
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Entrez votre adresse email",
      ),
    );
  }
}
