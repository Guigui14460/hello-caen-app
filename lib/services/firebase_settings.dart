import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

/// Class which define useful firebase instances.
/// Usage of the singleton pattern design.
class FirebaseSettings {
  /// Singleton instance of the class.
  static FirebaseSettings instance;

  /// The firebase app instance.
  FirebaseApp _app;

  /// The firebase database instance
  FirebaseDatabase _database;

  /// The firebase firestore instance
  FirebaseFirestore _firestore;

  /// Constructor of the instance.
  /// [app] the firebase app instance
  FirebaseSettings._(FirebaseApp app) {
    this._app = app;
    this._database = FirebaseDatabase(app: app);
    this._firestore = FirebaseFirestore.instance;
  }

  /// Gets the firebase settings single instance.
  /// Returns [null] if an error is occured.
  static Future<FirebaseSettings> createInstance(FirebaseApp app) async {
    if (FirebaseSettings.instance == null) {
      FirebaseSettings.instance = new FirebaseSettings._(app);
    }
    return FirebaseSettings.instance;
  }

  /// Gets the firebase app instance itself.
  FirebaseApp getApp() {
    return this._app;
  }

  /// Gets the firebase database instance itself.
  FirebaseDatabase getDatabase() {
    return this._database;
  }

  /// Gets the firebase firestore instance.
  FirebaseFirestore getFirestore() {
    return this._firestore;
  }
}
