import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../../account_parameters/account_parameters_screen.dart';
import '../../../constants.dart';
import '../../../components/default_button.dart';
import '../../../components/form_error.dart';
import '../../../helper/keyboard.dart';
import '../../../services/size_config.dart';
import '../../../services/user_manager.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  final List<String> _errors = [];

  void addError({String error}) {
    if (!_errors.contains(error))
      setState(() {
        _errors.add(error);
      });
  }

  void removeError({String error}) {
    if (_errors.contains(error))
      setState(() {
        _errors.remove(error);
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
          SizedBox(height: getProportionateScreenHeight(20)),
          Text(
            "En continuant, vous acceptez d'être en accord\navec nos termes et conditions d'utilisation",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.caption,
          ),
          SizedBox(height: getProportionateScreenHeight(20)),
          FormError(errors: _errors),
          SizedBox(height: getProportionateScreenHeight(10)),
          DefaultButton(
            text: 'Continuer',
            height: getProportionateScreenHeight(50),
            longPress: () {},
            press: () async {
              if (_formKey.currentState.validate() && _errors.isEmpty) {
                _formKey.currentState.save();
                KeyboardUtil.hideKeyboard(context);
                try {
                  await Provider.of<UserManager>(context, listen: false)
                      .registerWithEmailAndPassword(_email, _password);
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Vous êtes désormais inscrit")));
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AccountParametersScreen(firstTime: true)));
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    addError(error: kWeakPassword);
                  } else if (e.code == "email-already-in-use") {
                    addError(error: kAlreadyUsedEmail);
                  } else if (e.code ==
                      'account-exists-with-different-credential') {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "Votre adresse email est déjà assoiciée à un compte existant")));
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Erreur lors de l'inscription")));
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
      onChanged: (value) {
        removeError(error: kWeakPassword);
        if (value.isNotEmpty) {
          removeError(error: kPassConfirmNullError);
        } else if (value.length >= minimumPasswordLength) {
          removeError(error: kShortPassError);
        } else if (value == _password) {
          removeError(error: kMatchPassError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassConfirmNullError);
        } else if (value.length < minimumPasswordLength) {
          addError(error: kShortPassError);
        } else if (value != _password) {
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
      onSaved: (newValue) => _password = newValue,
      onChanged: (value) {
        removeError(error: kWeakPassword);
        removeError(error: kMatchPassError);
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= minimumPasswordLength) {
          removeError(error: kShortPassError);
        }
        setState(() {
          _password = value;
        });
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
      onSaved: (newValue) => _email = newValue,
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
