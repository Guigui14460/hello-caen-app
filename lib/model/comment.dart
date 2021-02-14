import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'database/commerce_model.dart';
import 'database/user_model.dart';

/// Represents a comment.
class Comment {
  // ID of the object in database.
  String id;

  /// Date of creation.
  final DateTime dateAdded;

  String commerceId;

  /// Date of last modification.
  DateTime dateModified;

  /// Rating associated to the comment
  double rating;

  /// Main text.
  String text;

  /// Comment author.
  final String authorId;

  /// Constructor.
  Comment(
      {this.id,
      @required this.commerceId,
      @required this.dateAdded,
      @required this.dateModified,
      @required this.rating,
      @required this.text,
      @required this.authorId});

  DocumentReference getAuthorRef() {
    return UserModel().getDocumentReference(this.authorId);
  }

  DocumentReference getCommerceRef() {
    return CommerceModel().getDocumentReference(this.commerceId);
  }
}
