import 'package:cloud_firestore/cloud_firestore.dart';

import '../database/db_model.dart';
import '../user_account.dart';
import '../../services/firebase_settings.dart';
import '../../utils.dart';

/// Model used to communicate with the database for the
/// user collection.
class UserModel with DBModel<User> {
  static CollectionReference reference =
      FirebaseSettings.instance.getFirestore().collection("users");

  @override
  User create(User object) {
    User results = object;
    reference.add({
      'firstName': object.getFirstName(),
      'lastName': object.getLastName(),
      'profilePicture': object.getProfilePicture(),
      'sex': object.getSex(),
      'dateOfBirth': convertDatetimeToString(object.getDateOfBirth()),
      'favoriteEnterprises': object.getFavoriteEnterprises().join(","),
    }).catchError((error) {
      results = null;
      print(error);
    });
    return results;
  }

  @override
  bool delete(String id) {
    bool ok = true;
    reference.doc(id).delete().catchError((error) {
      print(error);
      ok = false;
    });
    return ok;
  }

  @override
  List<User> getAll() {
    List<User> list = [];
    reference
        .get()
        .then((value) => {
              value.docs.forEach((element) {
                User user = User(
                    firstName: element['firstName'],
                    lastName: element['lastName'],
                    profilePicture: element['profilePicture'],
                    sex: element['sex'],
                    favoriteEnterprises:
                        element['favoriteEnterprises'].toString().split(","),
                    dateOfBirth:
                        convertStringToDatetime(element['dateOfBirth']));
                list.add(user);
              })
            })
        .catchError((error) => print(error));
    return list;
  }

  @override
  User getById(String id) {
    User user;
    reference
        .doc(id)
        .get()
        .then((value) => {
              user = User(
                  firstName: value['firstName'],
                  lastName: value['lastName'],
                  profilePicture: value['profilePicture'],
                  sex: value['sex'],
                  favoriteEnterprises:
                      value['favoriteEnterprises'].toString().split(","),
                  dateOfBirth: convertStringToDatetime(value['dateOfBirth']))
            })
        .catchError((error) => print(error));
    return user;
  }

  @override
  bool update(String id, User object) {
    bool ok = true;
    reference.doc(id).update({
      'firstName': object.getFirstName(),
      'lastName': object.getLastName(),
      'profilePicture': object.getProfilePicture(),
      'sex': object.getSex(),
      'dateOfBirth': convertDatetimeToString(object.getDateOfBirth()),
      'favoriteEnterprises': object.getFavoriteEnterprises().join(","),
    }).catchError((error) {
      ok = false;
      print(error);
    });
    return ok;
  }

  @override
  bool exists(String id) {
    bool exists = false;
    reference.doc(id).get().then((doc) {
      if (doc.exists)
        exists = true;
      else
        exists = false;
    }).catchError((error) => print(error));
    return exists;
  }
}
