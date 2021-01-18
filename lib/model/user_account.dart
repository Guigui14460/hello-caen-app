import 'package:flutter/material.dart';

import '../model/sex.dart';

class User {
  String firstName;
  String lastName;
  String profilePicture;
  DateTime dateOfBirth;
  Sex sex;
  List<String> favoriteEnterprises = [];
  bool proAccount = false;
  bool adminAccount = false;

  User(
      {@required this.firstName,
      @required this.lastName,
      @required this.profilePicture,
      @required this.dateOfBirth,
      @required this.sex,
      this.favoriteEnterprises,
      this.proAccount,
      this.adminAccount});

  User._() {
    this.firstName = null;
    this.lastName = null;
    this.profilePicture = null;
    this.dateOfBirth = null;
    this.sex = null;
    this.favoriteEnterprises = null;
  }

  String getFirstName() => this.firstName;
  void setFirstName(String value) => this.firstName = value;
  String getLastName() => this.lastName;
  void setLastName(String value) => this.lastName = value;
  String getProfilePicture() => this.profilePicture;
  void setProfilePicture(String value) => this.profilePicture = value;
  DateTime getDateOfBirth() => this.dateOfBirth;
  void setDateOfBirth(DateTime value) => this.dateOfBirth = value;
  Sex getSex() => this.sex;
  void setSex(Sex value) => this.sex = value;
  List<String> getFavoriteEnterprises() => this.favoriteEnterprises;
  void addFavoriteEnterprise(String valueId) =>
      this.favoriteEnterprises.add(valueId);
  void removeFavoriteEnterprise(String valueId) =>
      this.favoriteEnterprises.remove(valueId);
  bool isAdmin() => this.adminAccount;
  bool isPro() => this.proAccount;

  Widget getProfilePictureWdget() {
    return null;
  }

  Widget getFullNameWidget() {
    return Text(firstName + " " + lastName);
  }

  Widget getFavoriteEnterprisesWidget() {
    return null;
  }

  Widget getSexWidget() {
    String sex;
    switch (this.sex) {
      case Sex.Female:
        sex = "Femme";
        break;
      case Sex.Male:
        sex = "Homme";
        break;
      case Sex.Other:
        sex = "Autre";
        break;
      default:
    }
    return Text(sex);
  }

  int getAge() {
    int diff = DateTime.now().millisecondsSinceEpoch -
        dateOfBirth.millisecondsSinceEpoch;
    return DateTime.fromMillisecondsSinceEpoch(diff).year;
  }

  bool isAnonymous() {
    return this.firstName == null;
  }

  Widget buildSmallProfile() {
    return null;
  }

  static getAnonymousUser() {
    return User._();
  }
}
