import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'compare.dart';
import 'sex.dart';
import 'database/commerce_model.dart';

/// Represents a user account.
class User with Compare<User> {
  // ID of the object in database.
  String id;

  /// First name of the user.
  String firstName;

  /// Last name of the user.
  String lastName;

  /// URL profile picture.
  String profilePicture;

  /// Date of birth of the user.
  DateTime dateOfBirth;

  /// Sex of the user.
  Sex sex;

  /// List of the favorite commerce.
  List<String> favoriteCommerceIds = [];

  /// Is a PRO account.
  bool proAccount = false;

  /// Is an admin account.
  bool adminAccount = false;

  /// Constructor.
  User(
      {this.id,
      @required this.firstName,
      @required this.lastName,
      @required this.profilePicture,
      @required this.dateOfBirth,
      @required this.sex,
      this.favoriteCommerceIds,
      this.proAccount,
      this.adminAccount});

  /// Private constructor.
  User._() {
    this.firstName = null;
    this.lastName = null;
    this.profilePicture = null;
    this.dateOfBirth = null;
    this.sex = null;
    this.favoriteCommerceIds = [];
  }

  List<DocumentReference> getFavoriteCommerceRefs() {
    List<DocumentReference> refs = [];
    for (String commerceId in this.favoriteCommerceIds) {
      refs.add(CommerceModel().getDocumentReference(commerceId));
    }
    return refs;
  }

  /// Adds a commerce to favorites list.
  void addFavoriteEnterprise(String valueId) =>
      this.favoriteCommerceIds.add(valueId);

  /// Removes a commerce from favorites list.
  void removeFavoriteEnterprise(String valueId) =>
      this.favoriteCommerceIds.remove(valueId);

  /// Gets the widget to display user sex.
  String getSexWidget() {
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
    return sex;
  }

  /// Gets the actual age of the user.
  int getAge() {
    int diff = DateTime.now().millisecondsSinceEpoch -
        dateOfBirth.millisecondsSinceEpoch;
    return DateTime.fromMillisecondsSinceEpoch(diff).year;
  }

  /// Is an anonymous user.
  bool isAnonymous() {
    return this.firstName == null;
  }

  /// Gets and creates an anonymous user.
  static getAnonymousUser() {
    return User._();
  }

  @override
  bool equals(User other) {
    return this.id == other.id &&
        this.firstName == other.firstName &&
        this.lastName == other.lastName &&
        this.dateOfBirth == other.dateOfBirth &&
        this.profilePicture == other.profilePicture &&
        this.sex == other.sex;
  }

  static createEmptyUser(String id, {String pictureUrl, String displayName}) {
    User user = User(
      id: id,
      firstName: "",
      lastName: "",
      profilePicture: pictureUrl ?? "",
      dateOfBirth: DateTime.now(),
      sex: Sex.Male,
      favoriteCommerceIds: [],
      adminAccount: false,
      proAccount: false,
    );
    return user;
  }
}
