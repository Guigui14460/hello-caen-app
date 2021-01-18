import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hello_caen/model/sex.dart';

import 'firebase_firestore_db.dart';
import '../user_account.dart';
import '../../utils.dart';

/// Model used to communicate with the database for the
/// user collection.
class UserModel extends FirebaseFirestoreDB<User> {
  /// Default constructor.
  UserModel() : super("users");

  @override
  User getTElement(DocumentSnapshot value) {
    return User(
        firstName: value['firstName'],
        lastName: value['lastName'],
        profilePicture: value['profilePicture'],
        sex: Sex.values[value['sex']],
        favoriteEnterprises: value['favoriteEnterprises'].toString().split(","),
        dateOfBirth: convertStringToDatetime(value['dateOfBirth']),
        adminAccount: value['admin'],
        proAccount: value['pro']);
  }

  @override
  Map<String, dynamic> getElementData(User object) {
    return {
      'firstName': object.getFirstName(),
      'lastName': object.getLastName(),
      'profilePicture': object.getProfilePicture(),
      'sex': object.getSex().index,
      'dateOfBirth': convertDatetimeToString(object.getDateOfBirth()),
      'favoriteEnterprises': object.getFavoriteEnterprises().join(","),
      'admin': object.isAdmin(),
      'pro': object.isPro(),
    };
  }
}
