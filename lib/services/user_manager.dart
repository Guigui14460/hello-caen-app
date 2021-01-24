import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../model/database/user_model.dart';
import '../model/user_account.dart' as myuser;
import '../services/firebase_settings.dart';

/// Manages the current user of the application.
/// Extends [ChangeNotifier] to use it like a provider.
class UserManager with ChangeNotifier {
  /// Key used in the local storage.
  static String storageKey = "user_id";

  static UserManager instance = UserManager();

  /// Current logged in user.
  myuser.User _currentLoggedInUser;

  /// Gets the current logged in user.
  myuser.User getLoggedInUser() => instance._currentLoggedInUser;

  Future<void> init() async {
    if (instance == null) {
      instance = UserManager();
      var userLoggedIn = FirebaseSettings.instance.getAuth().currentUser;
      if (userLoggedIn != null) {
        instance._currentLoggedInUser =
            await UserModel().getById(userLoggedIn.uid);
      }
    }
  }

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    UserCredential results =
        await FirebaseSettings.instance.getAuth().signInWithEmailAndPassword(
              email: email,
              password: password,
            );
    if (results.user != null) {
      await UserModel().getById(results.user.uid).then((value) {
        instance._currentLoggedInUser = value;
      });
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
      await UserModel()
          .getById(results.user.uid)
          .then((value) => instance._currentLoggedInUser = value);
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
      instance._currentLoggedInUser =
          await UserModel().getById(results.user.uid);
      notifyListeners();
    }
    return results;
  }

  Future<UserCredential> signInWithFacebook() async {
    // get user data https://pub.dev/packages/flutter_facebook_auth#android
    final AccessToken result = await FacebookAuth.instance.login();
    final FacebookAuthCredential credential =
        FacebookAuthProvider.credential(result.token);
    UserCredential results = await FirebaseSettings.instance
        .getAuth()
        .signInWithCredential(credential);
    if (results.user != null) {
      instance._currentLoggedInUser =
          await UserModel().getById(results.user.uid);
      notifyListeners();
    }
    return results;
  }

  /// Verifies if a user is connected and is not an
  /// anonymous user.
  bool isLoggedIn() {
    if (instance._currentLoggedInUser == null) {
      return false;
    }
    return !instance._currentLoggedInUser.isAnonymous();
  }

  /// Log out the current logged in user.
  Future<void> logoutUser() async {
    await FirebaseSettings.instance.getAuth().signOut();
    instance._currentLoggedInUser = myuser.User.getAnonymousUser();
    notifyListeners();
  }

  Future<void> deleteUser() async {
    await FirebaseSettings.instance.getAuth().currentUser.delete();
    instance._currentLoggedInUser = myuser.User.getAnonymousUser();
    notifyListeners();
  }
}
