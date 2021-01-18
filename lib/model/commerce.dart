import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'comment.dart';
import 'commerce_type.dart';
import 'user_account.dart';
import '../utils.dart';
import 'database/comment_model.dart';
import 'database/user_model.dart';

/// Represents a commerce.
class Commerce {
  // ID of the object in database.
  String id;

  /// Name of the commerce.
  String name;

  /// Location
  String location;

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
  CommerceType type;

  /// All comments related to this commerce.
  List<Comment> comments;
  List<String> commentIds;

  /// Link for the image representing the commerce.
  String imageLink;

  /// Constructor.
  Commerce(
      {this.id,
      @required this.ownerId,
      @required this.name,
      @required this.location,
      @required this.timetables,
      @required this.type,
      @required this.commentIds,
      @required this.dateAdded,
      @required this.dateModified,
      @required this.imageLink});

  /// Initializes all comments associated to this commerce and
  /// the owner user.
  void init() async {
    await Future.wait<void>([
      CommentModel()
          .getMultipleByIds(this.commentIds)
          .then((value) => this.comments = value),
      UserModel().getById(this.ownerId).then((value) => this.owner = value),
    ]);
  }

  /// Gets the mean of all ratings.
  double _getRating() {
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
      rating: this._getRating(),
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
