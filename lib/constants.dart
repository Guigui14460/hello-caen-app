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

// Form error commerces
const String kCommerceNameNullError = "Le nom ne doit pas être vide";
const String kCommerceTypeNullError = "Veuillez sélectionner un type";
const String kCommerceImageLinkNullError = "Veuillez sélectionner une image";
const String kCommerceLatitudeNullError = "Veuillez ajouter la latitude";
const String kCommerceLongitudeNullError = "Veuillez ajouter la longitude";
const String kCommerceTimetablesNullError =
    "Veuillez ajouter vos horaires\nd'ouvertures/fermetures";

// Form error reduction codes
const String kCodeNameNullError =
    "Veuillez saisir un nom pour votre code de réduction";
const String kCodeNameAlreadyInUseError =
    "Ce nom est déjà utilisé. Veuillez en saisir un autre ou supprimer celui portant ce nom";
const String kCodeConditionNullError =
    "Veuillez entrer les conditions pour pouvoir utiliser ce code";
const String kCodeBeginDateNullError =
    "Veuillez entrer une date de démarrage de la campagne";
const String kCodeBeginDateInvalidError =
    "Veuillez entrer une date de démarrage valide";
const String kCodeEndDateInvalidError =
    "Veuillez entrer une date de fin valide";
const String kCodeMaxAvailableNullError =
    "Veuillez saisir le nombre maximum de codes disponible";
const String kCodeMaxAvailableInvalidError =
    "Le champ ne doit contenir que des chiffres";
const String kCodeMaxAvailableNegativError = "Le nombre ne peut pas être nul";
const String kCodeReductionAmountNullError =
    "Veuillez saisir le montant de la réduction";
const String kCodeReductionAmountInvalidError =
    "Le champ ne doit contenir que des chiffres";
const String kCodeReductionAmountNegativError =
    "Veuillez saisir un montant positif";
