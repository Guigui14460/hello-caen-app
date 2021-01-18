import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'comment.dart';
import 'commerce_type.dart';
import '../utils.dart';

/// Represents a commerce.
class Commerce {
  // ID of the object in database.
  String id;

  /// Name of the commerce.
  String name;

  /// Location
  String location;

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

  /// Link for the image representing the commerce.
  String
      imageLink; // donnée via une image sur un site ou via un upload de fichier

  /// Constructor.
  Commerce(
      {this.id,
      @required this.name,
      @required this.location,
      @required this.timetables,
      @required this.type,
      @required this.comments,
      @required this.dateAdded,
      @required this.dateModified,
      @required this.imageLink});

  /// Gets the mean of all ratings.
  double _getRating() {
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
        return comments[index].build(context);
      },
    ).build(context);
  }
}
