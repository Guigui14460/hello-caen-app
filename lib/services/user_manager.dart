import 'package:flutter/material.dart';

import '../model/database/user_model.dart';
import '../model/user_account.dart';
import '../services/storage_manager.dart';

/// Manages the current user of the application.
/// Extends [ChangeNotifier] to use it like a provider.
class UserManager with ChangeNotifier {
  /// Key used in the local storage.
  static String storageKey = "user_id";

  /// Current logged in user.
  User _currentLoggedInUser;

  /// Gets the current logged in user.
  User getLoggedInUser() => this._currentLoggedInUser;

  /// Constructor of the manager.
  /// If the [storageKey] is not in the local storage,
  /// we initialize an anonymous user.
  UserManager() {
    StorageManager.exists(storageKey).then((value) {
      if (value) {
        StorageManager.readData(storageKey).then((value) async {
          _currentLoggedInUser = await UserModel().getById(value);
        });
      } else {
        _currentLoggedInUser = User.getAnonymousUser();
      }
    });
    notifyListeners();
  }

  /// Verifies if a user is connected and is not an
  /// anonymous user.
  bool isLoggedIn() {
    if (this._currentLoggedInUser == null) {
      return false;
    }
    return !this._currentLoggedInUser.isAnonymous();
  }

  /// Log out the current logged in user and deletes
  /// the [storageKey] and associated data in the local
  /// storage.
  void logoutUser() {
    StorageManager.deleteData(storageKey).then((value) => null);
    _currentLoggedInUser = User.getAnonymousUser();
    notifyListeners();
  }
}
