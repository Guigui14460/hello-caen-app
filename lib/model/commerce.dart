import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'comment.dart';
import 'commerce_type.dart';
import 'user_account.dart';
import 'database/commerce_type_model.dart';
import 'database/comment_model.dart';
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
  List<Comment> comments = [];
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
      CommentModel()
          .getMultipleByIds(this.commentIds)
          .then((value) => this.comments = value),
      UserModel().getById(this.ownerId).then((value) => this.owner = value),
      CommerceTypeModel()
          .getById(this.typeId)
          .then((value) => this.type = value),
    ]);
  }

  void addComment(Comment comment) {
    this.commentIds.add(comment.id);
    this.comments.add(comment);
  }

  void updateComment(Comment comment) {
    int index = this.commentIds.indexWhere((element) => element == comment.id);
    this.commentIds[index] = comment.id;
    this.comments[index] = comment;
  }

  void removeComment(Comment comment) {
    this.commentIds.remove(comment.id);
    this.comments.remove(comment);
  }

  /// Gets the mean of all ratings.
  double getRating() {
    double rating = 0;
    for (int i = 0; i < this.comments.length; i++) {
      rating += this.comments[i].rating;
    }
    rating /= this.comments.length;
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
  Widget getCommentsWidget(context) {
    return ListView.builder(
      itemCount: this.comments.length,
      itemBuilder: (context, index) {
        return this.comments[index].build(context);
      },
    ).build(context);
  }
}
