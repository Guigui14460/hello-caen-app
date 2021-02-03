import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'user_account.dart';
import 'database/commerce_model.dart';
import 'database/user_model.dart';
import '../utils.dart';

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

  /// Builds the comment widget.
  Widget build(context) {
    return FutureBuilder(
        future: UserModel().getById(id),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          return Column(
            children: [
              Row(
                children: [
                  snapshot.data.buildSmallProfile(),
                  this._getDateAdded(),
                  this._getDateModified(),
                ],
              ),
              Text(this.text),
            ],
          );
        });
  }

  /// Gets the added date widget.
  Widget _getDateAdded() {
    return Text(convertDatetimeToString(this.dateAdded));
  }

  /// Gets the modified date widget.
  Widget _getDateModified() {
    return Text(
      "Modifié le " + convertDatetimeToString(this.dateModified),
      style: TextStyle(fontSize: 10),
    );
  }
}
