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
  Future<bool> exists(String id) async {
    bool exists = false;
    await reference.doc(id).get().then((document) {
      exists = document.exists;
    }).catchError((error) => print(error));
    return exists;
  }

  @override
  Future<List<T>> getAll() async {
    List<T> list = [];
    await reference
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
  Future<T> getById(String id) async {
    T object;
    await reference
        .doc(id)
        .get()
        .then((value) => object = getTElement(value))
        .catchError((error) => print(error));
    return object;
  }

  @override
  Future<List<T>> getMultipleByIds(List<String> ids) async {
    List<T> list = [];
    list = await Future.wait(ids.map(
        (id) => reference.doc(id).get().then((value) => getTElement(value))));
    return list;
  }

  /// Gets [T] element from the [value] provided by
  /// [getAll] and [getById] methods.
  @protected
  T getTElement(DocumentSnapshot value);

  @override
  Future<T> create(T object) async {
    T results = object;
    await reference.add(getElementData(object)).catchError((error) {
      results = null;
      print(error);
    });
    return results;
  }

  @override
  Future<T> createWithId(String id, T object) async {
    T results = object;
    await reference.doc(id).set(getElementData(object)).catchError((error) {
      results = null;
      print(error);
    });
    return results;
  }

  @override
  Future<bool> update(String id, T object) async {
    bool ok = true;
    await reference.doc(id).update(getElementData(object)).catchError((error) {
      ok = false;
      print(error);
    });
    return ok;
  }

  @override
  Future<bool> delete(String id) async {
    bool ok = true;
    await reference.doc(id).delete().catchError((error) {
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
