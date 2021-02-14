import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'database/commerce_model.dart';
import 'database/user_model.dart';

class SubComment {
  // ID of the object in database.
  String id;

  /// Main text.
  String text;

  /// Date of creation.
  final DateTime dateAdded;

  /// Date of last modification.
  DateTime dateModified;

  /// Comment author.
  final String authorId;

  final String commentId;

  /// Constructor.
  SubComment({
    this.id,
    @required this.text,
    @required this.authorId,
    @required this.dateAdded,
    @required this.dateModified,
    @required this.commentId,
  });

  DocumentReference getAuthorRef() {
    return UserModel().getDocumentReference(this.authorId);
  }

  DocumentReference getCommerceRef() {
    return CommerceModel().getDocumentReference(this.commentId);
  }
}
