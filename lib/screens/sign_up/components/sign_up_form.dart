import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../constants.dart';
import '../../../services/size_config.dart';
import '../../../services/firebase_settings.dart';
import '../../../components/default_button.dart';
import '../../../components/form_error.dart';
import '../../../helper/keyboard.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
  String confirmPassword;
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
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordConfirmFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          Text(
            "En continuant, vous acceptez d'être en accord\navec nos termes et conditions d'utilisation",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.caption,
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
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
                      .createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Vous êtes désormais inscrit")));
                  Navigator.pop(context);
                } on FirebaseAuthException catch (e) {
                  print(e.code);
                  if (e.code == 'weak-password') {
                    addError(error: kWeakPassword);
                  } else if (e.code == "email-already-in-use") {
                    addError(error: kAlreadyUsedEmail);
                  }
                }
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildPasswordConfirmFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => confirmPassword = newValue,
      onChanged: (value) {
        removeError(error: kWeakPassword);
        if (value.isNotEmpty) {
          removeError(error: kPassConfirmNullError);
        } else if (value.length >= minimumPasswordLength) {
          removeError(error: kShortPassError);
        } else if (value == password) {
          removeError(error: kMatchPassError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassConfirmNullError);
        } else if (value.length < minimumPasswordLength) {
          addError(error: kShortPassError);
        } else if (value != password) {
          addError(error: kMatchPassError);
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: "Confimez votre mot de passe",
        labelText: "Confirmation mot de passe",
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        removeError(error: kWeakPassword);
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
        removeError(error: kAlreadyUsedEmail);
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