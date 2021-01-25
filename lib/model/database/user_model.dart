import 'package:cloud_firestore/cloud_firestore.dart';

import 'comment_model.dart';
import 'commerce_model.dart';
import 'sub_comment_model.dart';
import 'firebase_firestore_db.dart';
import '../comment.dart';
import '../commerce.dart';
import '../sex.dart';
import '../sub_comment.dart';
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

  @override
  Future<bool> delete(String id) async {
    SubCommentModel model = SubCommentModel();
    List<SubComment> subComments = await model
        .whereLinked("author", isEqualTo: id)
        .executeCurrentLinkedQueryRequest();
    CommentModel model2 = CommentModel();
    List<Comment> comments = await model2
        .whereLinked("author", isEqualTo: id)
        .executeCurrentLinkedQueryRequest();
    CommerceModel model3 = CommerceModel();
    List<Commerce> commerces = await model3
        .whereLinked("author", isEqualTo: id)
        .executeCurrentLinkedQueryRequest();

    List<bool> results = await Future.wait(commerces.map((element) {
      return model3.delete(element.id);
    }).toList());
    for (bool r in results) {
      if (r == false) {
        return Future.value(false);
      }
    }

    results = await Future.wait(comments.map((element) {
      return model2.delete(element.id);
    }).toList());
    for (bool r in results) {
      if (r == false) {
        return Future.value(false);
      }
    }

    results = await Future.wait(subComments.map((element) {
      return model3.delete(element.id);
    }).toList());
    for (bool r in results) {
      if (r == false) {
        return Future.value(false);
      }
    }

    return super.delete(id);
  }
}
