import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'db_model.dart';
import '../../services/firebase_settings.dart';

/// Abstract class which allows to communicate with the firestore
/// cloud provided by Firebase.
/// [T] represents the real object class associated to the
/// model of the collection.
abstract class FirebaseFirestoreDB<T> with DBModel<T> {
  /// Name of the database collection.
  String collectionName;

  /// Reference of the database collection.
  CollectionReference reference;

  /// Constructor of the database.
  /// [collectionName] is the name of the collection.
  FirebaseFirestoreDB(String collectionName) {
    this.collectionName = collectionName;
    this.reference =
        FirebaseSettings.instance.getFirestore().collection(collectionName);
  }

  @override
  bool exists(String id) {
    bool exists = false;
    reference.doc(id).get().then((document) {
      if (document.exists)
        exists = true;
      else
        exists = false;
    }).catchError((error) => print(error));
    return exists;
  }

  @override
  List<T> getAll() {
    List<T> list = [];
    reference
        .get()
        .then((value) => {
              value.docs.forEach((element) {
                list.add(getTElement(element));
              })
            })
        .catchError((error) => print(error));
    return list;
  }

  @override
  T getById(String id) {
    T object;
    reference
        .doc(id)
        .get()
        .then((value) => object = getTElement(value))
        .catchError((error) => print(error));
    return object;
  }

  /// Gets [T] element from the [value] provided by
  /// [getAll] and [getById] methods.
  @protected
  T getTElement(DocumentSnapshot value);

  @override
  T create(T object) {
    T results = object;
    reference.add(getElementData(object)).catchError((error) {
      results = null;
      print(error);
    });
    return results;
  }

  @override
  bool update(String id, T object) {
    bool ok = true;
    reference.doc(id).update(getElementData(object)).catchError((error) {
      ok = false;
      print(error);
    });
    return ok;
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

  /// Gets data from the [object].
  /// Used in [create] and [update] methods.
  @protected
  Map<String, dynamic> getElementData(T object);
}
