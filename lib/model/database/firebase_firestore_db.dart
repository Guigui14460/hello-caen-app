import 'package:cloud_firestore/cloud_firestore.dart';

import 'db_model.dart';
import 'firestore_db_linked_request.dart';
import '../../services/firebase_settings.dart';

/// Abstract class which allows to communicate with the firestore
/// cloud provided by Firebase.
/// [T] represents the real object class associated to the
/// model of the collection.
abstract class FirebaseFirestoreDB<T>
    with DBModel<T>, FirestoreDBLinkedRequest<T> {
  /// Name of the database collection.
  final String collectionName;

  /// Reference of the database collection.
  CollectionReference reference;

  final List<dynamic> fields;
  Query currentQuery;

  /// Constructor of the database.
  /// [collectionName] is the name of the collection.
  FirebaseFirestoreDB(this.collectionName, this.fields) {
    this.reference =
        FirebaseSettings.instance.getFirestore().collection(collectionName);
    this.currentQuery = this.reference;
  }

  DocumentReference getDocumentReference(String id) {
    return this.reference.doc(id);
  }

  List<dynamic> getAvailableField() {
    return this.fields;
  }

  Future<List<T>> where(dynamic field,
      {dynamic isEqualTo,
      dynamic isNotEqualTo,
      dynamic isLessThan,
      dynamic isLessThanOrEqualTo,
      dynamic isGreaterThan,
      dynamic isGreaterThanOrEqualTo,
      dynamic arrayContains,
      List<dynamic> arrayContainsAny,
      List<dynamic> whereIn,
      List<dynamic> whereNotIn,
      bool isNull}) async {
    List<T> list = [];
    await reference
        .where(field,
            isEqualTo: isEqualTo,
            isNotEqualTo: isNotEqualTo,
            isLessThan: isLessThan,
            isLessThanOrEqualTo: isLessThanOrEqualTo,
            isGreaterThan: isGreaterThan,
            isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
            arrayContains: arrayContains,
            arrayContainsAny: arrayContainsAny,
            isNull: isNull,
            whereIn: whereIn,
            whereNotIn: whereNotIn)
        .get()
        .then((data) {
      data.docs.forEach((element) {
        list.add(getTElement(element));
      });
    });
    return list;
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
  T getTElement(DocumentSnapshot value);

  @override
  Future<String> create(T object) async {
    String results;
    await reference.add(getElementData(object)).then((value) {
      results = value.id;
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
  Future<bool> updateFields(String id, T object, List<dynamic> fieldsToUpdate,
      List<dynamic> associatedFields) async {
    bool ok = true;
    Map<String, dynamic> updateData = {};
    for (int i = 0; i < fieldsToUpdate.length; i++) {
      dynamic field = fieldsToUpdate[i];
      if (!this.fields.contains(field)) {
        throw new Exception("Field arg not in the available fields");
      }
      updateData.putIfAbsent(field, () => associatedFields[i]);
    }
    await reference.doc(id).update(updateData).catchError((error) {
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
  Map<String, dynamic> getElementData(T object);

  @override
  FirestoreDBLinkedRequest<T> whereLinked(dynamic field,
      {dynamic isEqualTo,
      dynamic isNotEqualTo,
      dynamic isLessThan,
      dynamic isLessThanOrEqualTo,
      dynamic isGreaterThan,
      dynamic isGreaterThanOrEqualTo,
      dynamic arrayContains,
      List<dynamic> arrayContainsAny,
      List<dynamic> whereIn,
      List<dynamic> whereNotIn,
      bool isNull}) {
    if (!this.fields.contains(field)) {
      throw new Exception("Field arg not in the available fields");
    }
    this.currentQuery = this.currentQuery.where(field,
        isEqualTo: isEqualTo,
        isNotEqualTo: isNotEqualTo,
        isLessThan: isLessThan,
        isLessThanOrEqualTo: isLessThanOrEqualTo,
        isGreaterThan: isGreaterThan,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
        arrayContains: arrayContains,
        arrayContainsAny: arrayContainsAny,
        whereIn: whereIn,
        whereNotIn: whereNotIn,
        isNull: isNull);
    return this;
  }

  @override
  FirestoreDBLinkedRequest<T> limitLinked(int limit) {
    this.currentQuery = this.currentQuery.limit(limit);
    return this;
  }

  @override
  FirestoreDBLinkedRequest<T> limitToLastLinked(int limit) {
    this.currentQuery = this.currentQuery.limitToLast(limit);
    return this;
  }

  @override
  FirestoreDBLinkedRequest<T> orderByLinked(dynamic field,
      {bool descending = false}) {
    if (!this.fields.contains(field)) {
      throw new Exception("Field arg not in the available fields");
    }
    this.currentQuery =
        this.currentQuery.orderBy(field, descending: descending);
    return this;
  }

  @override
  Future<List<T>> executeCurrentLinkedQueryRequest() async {
    List<T> list = [];
    await this
        .currentQuery
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
  void cancalCurrentLinkedQueryRequest() {
    this.currentQuery = this.reference;
  }
}
