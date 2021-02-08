import 'package:cloud_firestore/cloud_firestore.dart';

import 'commerce_model.dart';
import 'firebase_firestore_db.dart';
import '../commerce.dart';

class PaginatedCommerceModel {
  List<Commerce> loadedCommerces = [];
  DocumentSnapshot _lastCommerceSnapshot;
  FirebaseFirestoreDB<Commerce> model = CommerceModel();

  bool isLoading = false;
  bool hasMore = true;
  int documentLimit = 2;

  Future<void> getCommerces() async {
    if (!hasMore) {
      print("No more");
      return;
    }
    if (isLoading) {
      return;
    }
    isLoading = true;

    QuerySnapshot query;
    if (_lastCommerceSnapshot == null) {
      query = await model.reference.orderBy('name').limit(documentLimit).get();
    } else {
      query = await model.reference
          .orderBy('name')
          .startAfterDocument(_lastCommerceSnapshot)
          .limit(documentLimit)
          .get();
    }
    if (query.docs.length < documentLimit) {
      hasMore = false;
    }
    _lastCommerceSnapshot = query.docs[query.docs.length - 1];
    loadedCommerces.addAll(query.docs.map((e) => model.getTElement(e)));

    isLoading = false;
  }

  Future<void> refresh() async {
    if (isLoading) {
      return;
    }
    isLoading = true;

    QuerySnapshot query;
    if (loadedCommerces.length == 0) {
      query = await model.reference.orderBy('name').limit(documentLimit).get();
      loadedCommerces = query.docs.map((e) => model.getTElement(e)).toList();
    } else {
      query = await model.reference.orderBy('name').get();
      loadedCommerces = query.docs.map((e) => model.getTElement(e)).toList();
    }

    isLoading = false;
  }
}
