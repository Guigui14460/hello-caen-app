import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'comment.dart';
import 'commerce_type.dart';
import 'user_account.dart';
import 'database/commerce_type_model.dart';
import 'database/user_model.dart';
import '../utils.dart';

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
  User owner;

  /// Date of creation.
  final DateTime dateAdded;

  /// Date of last modification.
  DateTime dateModified;

  /// Time tables of the merchant.
  String timetables;

  /// Type of commerce.
  String typeId;
  CommerceType type;

  /// All comments related to this commerce.
  List<String> commentIds = [];

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
      this.commentIds,
      @required this.dateAdded,
      this.dateModified,
      @required this.imageLink});

  /// Initializes all comments associated to this commerce and
  /// the owner user.
  Future<void> init() async {
    await Future.wait<void>([
      UserModel().getById(this.ownerId).then((value) => this.owner = value),
      CommerceTypeModel()
          .getById(this.typeId)
          .then((value) => this.type = value),
    ]);
  }

  void addComment(Comment comment) {
    this.commentIds.add(comment.id);
  }

  void updateComment(Comment comment) {
    int index = this.commentIds.indexWhere((element) => element == comment.id);
    this.commentIds[index] = comment.id;
  }

  void removeComment(Comment comment) {
    this.commentIds.remove(comment.id);
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

  /// Gets the rating bar widget.
  Widget getRatingBar(List<Comment> comments) {
    return RatingBarIndicator(
      rating: this.getRating(comments),
      direction: Axis.horizontal,
      itemCount: 5,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
    );
  }

  /// Gets the added date in the database widget.
  Widget getDateAdded() {
    return Text(convertDatetimeToString(this.dateAdded));
  }

  /// Gets the last modified date widget.
  Widget getDateModified() {
    return Text(convertDatetimeToString(this.dateModified));
  }

  /// Gets the image widget.
  Image getImage() {
    return Image.network(this.imageLink);
  }

  /// Gets all comments related to commerce in a
  /// widget.
  Widget getCommentsWidget(BuildContext context, List<Comment> comments) {
    return ListView.builder(
      itemCount: comments.length,
      itemBuilder: (context, index) {
        return comments[index].build(context);
      },
    ).build(context);
  }
}
