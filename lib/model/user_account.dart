import 'package:flutter/cupertino.dart';
import 'package:hello_caen/model/enterprise.dart';
import 'package:hello_caen/model/sex.dart';

class User {
  String firstName;
  String lastName;
  String profilePicture;
  DateTime dateOfBirth;
  Sex sex;
  Enterprise favorites;

  User(
      {@required this.firstName,
      @required this.lastName,
      @required this.profilePicture,
      @required this.dateOfBirth,
      @required this.sex,
      @required this.favorites});

  Widget getProfilePicture() {
    return null;
  }

  Widget getFullName() {
    return Text(firstName + " " + lastName);
  }

  Widget getFavorites() {
    return null;
  }

  Widget getSex() {
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

  buildSmallProfile() {}
}
