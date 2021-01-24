import 'package:flutter/material.dart';

const primaryColor = Color(0xFF643865);
const secondaryColor = Color(0xFFEB6265);
const ternaryColor = Color(0xFFFABB6B);

const primaryGradientColor = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryColor, secondaryColor]);
const textColor = Color(0x333333);
const animationDuration = Duration(milliseconds: 200);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Veuillez entrer votre adresse email";
const String kFirstNameNullError = "Veuillez entrer votre prénom";
const String kLastNameNullError = "Veuillez entrer votre nom de famille";
const String kDateOfBirthNullError = "Veuillez entrer votre date de naissance";
const String kDateOfBirthDatetimeError =
    "Veuillez entrer une date de naissance valide";
const String kInvalidEmailError = "Veuillez entrer une adresse email valide";
const String kPassNullError = "Veuillez entrer votre mot de passe";
const String kPassConfirmNullError = "Veuillez confirmer votre mot de passe";
const String kShortPassError = "Mot de passe trop court";
const String kMatchPassError = "Les mots de passe sont différents";
const String kUserNotFound = "Aucun compte trouvé pour cette adresse email";
const String kWrongPassword = "Mot de passe incorrect";
const String kWeakPassword = "Mot de passe trop faible";
const String kAlreadyUsedEmail = "Adresse email déjà utilisée";
// const int minimumPasswordLength = 10;
const int minimumPasswordLength = 1; // TODO: à échanger
