import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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

  List<Comment> comments = [];

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
  double getRating() {
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

  /// Gets the rating bar widget.
  Widget getRatingBar() {
    return RatingBarIndicator(
      rating: this.getRating(),
      direction: Axis.horizontal,
      itemCount: 5,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
    );
  }

  /// Gets the image widget.
  Image getImage() {
    return Image.network(this.imageLink);
  }

  void setComments(List<Comment> comments) {
    this.comments = comments;
  }

  void addComment(Comment comment) {
    this.comments.add(comment);
  }

  void removeComment(Comment comment) {
    this.comments.remove(comment);
  }
}
