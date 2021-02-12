import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'database/commerce_model.dart';
import 'database/user_model.dart';

class Rating {
  String id;
  double rating;
  final String commerceId;
  final String authorId;

  Rating({
    this.id,
    @required this.rating,
    @required this.commerceId,
    @required this.authorId,
  });

  DocumentReference getAuthorRef() {
    return UserModel().getDocumentReference(this.authorId);
  }

  DocumentReference getCommerceRef() {
    return CommerceModel().getDocumentReference(this.commerceId);
  }
}
