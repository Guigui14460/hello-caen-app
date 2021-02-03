import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'storage_manager.dart';
import '../model/database/user_model.dart';
import '../model/user_account.dart' as account;
import '../services/firebase_settings.dart';

/// Manages the current user of the application.
/// Extends [ChangeNotifier] to use it like a provider.
class UserManager with ChangeNotifier {
  /// Key used in the local storage.
  static String storageKey = "user_id";

  /// Current logged in user.
  account.User _currentLoggedInUser;

  /// Gets the current logged in user.
  account.User getLoggedInUser() => _currentLoggedInUser;
  void updateLoggedInUser(account.User user) {
    _currentLoggedInUser = user;
    notifyListeners();
  }

  UserManager() {
    StorageManager.exists(storageKey).then((exists) {
      if (exists) {
        StorageManager.readData(storageKey).then((uid) {
          UserModel().getById(uid).then((value) {
            _currentLoggedInUser = value;
          });
        });
      } else {
        _currentLoggedInUser = account.User.getAnonymousUser();
      }
    });
  }

  Future<void> signIn(String uid) async {
    await StorageManager.saveData(storageKey, uid);
  }

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    UserCredential results = await FirebaseSettings.instance
        .getAuth()
        .signInWithEmailAndPassword(
          email: email,
          password: password,
        )
        .catchError((error) {
      print(error);
    });
    print(results);
    if (results.user != null) {
      print(results.user.uid);
      await UserModel().getById(results.user.uid).then((value) {
        _currentLoggedInUser = value;
      });
      await signIn(results.user.uid);

      notifyListeners();
    }
    return results;
  }

  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password) async {
    UserCredential results = await FirebaseSettings.instance
        .getAuth()
        .createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
    if (results.user != null) {
      account.User user = account.User.createEmptyUser(results.user.uid);
      await UserModel().createWithId(results.user.uid, user).then((value) {
        _currentLoggedInUser = value;
      });
      await signIn(results.user.uid);
      notifyListeners();
    }
    return results;
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn(scopes: [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ]).signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    UserCredential results = await FirebaseSettings.instance
        .getAuth()
        .signInWithCredential(credential);
    if (results.user != null) {
      bool exists = await UserModel().exists(results.user.uid);
      if (!exists) {
        await UserModel().createWithId(
            results.user.uid,
            account.User.createEmptyUser(results.user.uid,
                pictureUrl: results.user.photoURL,
                displayName: results.user.displayName));
      }
      await UserModel().getById(results.user.uid).then((value) {
        _currentLoggedInUser = value;
      });
      await signIn(results.user.uid);

      notifyListeners();
    }
    return results;
  }

  Future<UserCredential> signInWithFacebook() async {
    final AccessToken result = await FacebookAuth.instance.login();
    final FacebookAuthCredential credential =
        FacebookAuthProvider.credential(result.token);
    UserCredential results = await FirebaseSettings.instance
        .getAuth()
        .signInWithCredential(credential);
    if (results.user != null) {
      bool exists = await UserModel().exists(results.user.uid);
      if (!exists) {
        await UserModel().createWithId(
            results.user.uid,
            account.User.createEmptyUser(results.user.uid,
                pictureUrl: results.user.photoURL,
                displayName: results.user.displayName));
      }
      await UserModel().getById(results.user.uid).then((value) {
        _currentLoggedInUser = value;
      });
      await signIn(results.user.uid);
      notifyListeners();
    }
    return results;
  }

  /// Verifies if a user is connected and is not an
  /// anonymous user.
  bool isLoggedIn() {
    if (_currentLoggedInUser == null) {
      return false;
    }
    return !_currentLoggedInUser.isAnonymous();
  }

  /// Log out the current logged in user.
  Future<void> logoutUser() async {
    await FirebaseSettings.instance.getAuth().signOut();
    await StorageManager.deleteData(storageKey);
    _currentLoggedInUser = account.User.getAnonymousUser();
    notifyListeners();
  }

  Future<void> deleteUser() async {
    User user = FirebaseSettings.instance.getAuth().currentUser;
    await UserModel().delete(user.uid);
    await user.delete().then((value) async {
      await StorageManager.deleteData(storageKey);
      _currentLoggedInUser = account.User.getAnonymousUser();
    }).catchError((error) {
      UserModel().createWithId(user.uid, _currentLoggedInUser);
      throw new Exception("Need more fresh sign in");
    });
    notifyListeners();
  }
}
