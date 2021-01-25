import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../components/date_picker.dart';
import '../../../components/default_button.dart';
import '../../../components/form_error.dart';
import '../../../helper/keyboard.dart';
import '../../../model/sex.dart';
import '../../../model/user_account.dart';
import '../../../model/database/user_model.dart';
import '../../../services/size_config.dart';
import '../../../services/user_manager.dart';

class ParametersForm extends StatefulWidget {
  final User user;
  ParametersForm({Key key, @required this.user}) : super(key: key);

  @override
  _ParametersFormState createState() => _ParametersFormState();
}

class _ParametersFormState extends State<ParametersForm> {
  final _formKey = GlobalKey<FormState>();
  String firstName;
  String lastName;
  DateTime dateOfBirth;
  Sex sex;
  final List<String> errors = [];

  String _dropdownValue;

  @override
  void initState() {
    super.initState();
    setState(() {
      firstName = widget.user.firstName;
      lastName = widget.user.lastName;
      sex = widget.user.sex;
      dateOfBirth = widget.user.dateOfBirth ?? DateTime.now();
    });
  }

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
    UserManager userManager = Provider.of<UserManager>(context);
    User user = userManager.getLoggedInUser();

    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildFirstNameFormField(),
          SizedBox(height: getProportionateScreenHeight(20)),
          buildLastNameFormField(),
          SizedBox(height: getProportionateScreenHeight(20)),
          DatePicker(
            label: "Date de naissance",
            placeholder: "Sélectionnez votre date de naissance",
            initialValue: dateOfBirth,
            onChanged: (value) {
              setState(() {
                dateOfBirth = value;
              });
            },
          ),
          SizedBox(height: getProportionateScreenHeight(20)),
          buildSexDropdownButton(),
          SizedBox(height: getProportionateScreenHeight(20)),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          Text(
            "N.B. : Pour changer d'image de profil, pressez longuement votre image de profil sur le précédent écran",
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: 'Sauvegarder',
            height: getProportionateScreenHeight(50),
            longPress: () {},
            press: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                KeyboardUtil.hideKeyboard(context);
                try {
                  User updatedUser = User(
                      id: user.id,
                      firstName: firstName,
                      lastName: lastName,
                      profilePicture: user.profilePicture,
                      dateOfBirth: dateOfBirth,
                      sex: sex,
                      proAccount: user.proAccount,
                      adminAccount: user.adminAccount,
                      favoriteCommerceIds: user.favoriteCommerceIds);
                  UserModel().update(updatedUser.id, updatedUser);
                  userManager.updateLoggedInUser(updatedUser);
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Données mises à jour")));
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                          Text("Erreur lors de la mise à jour des données")));
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildSexDropdownButton() {
    return new DropdownButtonFormField<Sex>(
      isExpanded: true,
      value: sex,
      hint: _dropdownValue != null
          ? Text(_dropdownValue)
          : Text("Sélectionner un genre"),
      items: Sex.values.map((Sex value) {
        return new DropdownMenuItem(
          value: value,
          child: Text(_getSexString(value)),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _dropdownValue = _getSexString(value);
          sex = value;
        });
      },
    );
  }

  TextFormField buildFirstNameFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      initialValue: firstName,
      onSaved: (newValue) => firstName = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kFirstNameNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kFirstNameNullError);
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: "Entrez votre prénom",
        labelText: "Prénom",
      ),
    );
  }

  TextFormField buildLastNameFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      initialValue: lastName,
      onSaved: (newValue) => lastName = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kLastNameNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kLastNameNullError);
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: "Entrez votre nom de famille",
        labelText: "Nom de famille",
      ),
    );
  }

  String _getSexString(Sex value) {
    switch (value) {
      case Sex.Male:
        return "Homme";
      case Sex.Female:
        return "Femme";
      default:
        return "Autre";
    }
  }
}
