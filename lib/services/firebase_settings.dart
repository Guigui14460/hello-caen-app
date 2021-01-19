import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Class which define useful firebase instances.
/// Usage of the singleton pattern design.
class FirebaseSettings {
  /// Singleton instance of the class.
  static FirebaseSettings instance;

  /// The firebase app instance.
  FirebaseApp _app;

  /// The firebase database instance.
  // FirebaseDatabase _database;

  /// The firebase firestore instance.
  FirebaseFirestore _firestore;

  /// The firebase storage.
  FirebaseStorage _storage;

  /// The firebase cloud messaging.
  FirebaseMessaging _messaging;

  /// Constructor of the instance.
  /// [app] the firebase app instance.
  FirebaseSettings._(FirebaseApp app) {
    this._app = app;
    // this._database = FirebaseDatabase(app: app);
    this._firestore = FirebaseFirestore.instance;
    this._storage = FirebaseStorage.instance;
    this._messaging = FirebaseMessaging();
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
  // FirebaseDatabase getDatabase() {
  //   return this._database;
  // }

  /// Gets the firebase firestore instance.
  FirebaseFirestore getFirestore() {
    return this._firestore;
  }

  /// Gets the firebase storage instance.
  FirebaseStorage getStorage() {
    return this._storage;
  }

  /// Gets the firebase cloud messaging instance.
  FirebaseMessaging getMessaging() {
    return this._messaging;
  }

  /// Uploads a file in the firebase storage at [mainDirectory]/[fileName]
  /// location.
  Future<UploadTask> uploadFile(PickedFile file, BuildContext context,
      String mainDirectory, String fileName,
      {String contentType = "image/jpeg"}) async {
    if (file == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("No file was selected")));
      return null;
    }

    Reference ref = this._storage.ref().child(mainDirectory).child(fileName);
    final SettableMetadata metadata = SettableMetadata(
        customMetadata: {'picked-file-path': file.path},
        contentType: contentType);
    Future.value(ref.putFile(File(file.path), metadata));
  }
}
