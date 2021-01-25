import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_firestore_db.dart';
import '../sex.dart';
import '../user_account.dart';
import '../../utils.dart';

/// Model used to communicate with the database for the
/// user collection.
class UserModel extends FirebaseFirestoreDB<User> {
  /// Default constructor.
  UserModel()
      : super("accounts", [
          "firstName",
          "lastName",
          "profilePicture",
          "sex",
          "dateOfBirth",
          "favoriteCommerces",
          "admin",
          "pro",
        ]);

  @override
  User getTElement(DocumentSnapshot value) {
    return User(
        id: value.id,
        firstName: value['firstName'],
        lastName: value['lastName'],
        profilePicture: value['profilePicture'],
        sex: Sex.values[value['sex']],
        favoriteCommerceIds: List<String>.from(value['favoriteCommerces']),
        dateOfBirth: convertStringToDatetime(value['dateOfBirth']),
        adminAccount: value['admin'],
        proAccount: value['pro']);
  }

  @override
  Map<String, dynamic> getElementData(User object) {
    return {
      'firstName': object.firstName,
      'lastName': object.lastName,
      'profilePicture': object.profilePicture,
      'sex': object.sex.index,
      'dateOfBirth': convertDatetimeToString(object.dateOfBirth),
      'favoriteCommerces': object.favoriteCommerceIds,
      'admin': object.adminAccount,
      'pro': object.proAccount,
    };
  }
}
