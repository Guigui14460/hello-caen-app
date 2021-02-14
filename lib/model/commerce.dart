import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'comment.dart';
import 'database/commerce_type_model.dart';
import 'database/user_model.dart';

/// Represents a commerce.
class Commerce {
  // ID of the object in database.
  String id;

  /// Name of the commerce.
  String name;

  /// Description of the commerce.
  String description;

  double latitude;
  double longitude;

  /// Owner of the commerce.
  String ownerId;

  /// Time tables of the merchant.
  String timetables;

  /// Type of commerce.
  String typeId;

  /// Link for the image representing the commerce.
  String imageLink;

  /// Constructor.
  Commerce(
      {this.id,
      @required this.ownerId,
      @required this.name,
      @required this.description,
      @required this.latitude,
      @required this.longitude,
      @required this.timetables,
      @required this.typeId,
      @required this.imageLink});

  DocumentReference getOwnerRef() {
    return UserModel().getDocumentReference(this.ownerId);
  }

  DocumentReference getTypeRef() {
    return CommerceTypeModel().getDocumentReference(this.typeId);
  }

  /// Gets the mean of all ratings.
  double getRating(List<Comment> comments) {
    if (comments.length == 0) {
      return double.nan;
    }
    double rating = 0;
    for (int i = 0; i < comments.length; i++) {
      rating += comments[i].rating;
    }
    rating /= comments.length;
    return rating;
  }

  /// Gets the image widget.
  ImageProvider getImage() {
    return NetworkImage(this.imageLink);
  }
}
