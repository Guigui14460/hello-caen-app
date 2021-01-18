import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'sub_comment.dart';
import 'user_account.dart';
import '../utils.dart';

/// Represents a comment.
class Comment {
  // ID of the object in database.
  String id;

  /// Date of creation.
  final DateTime dateAdded;

  /// Date of last modification.
  DateTime dateModified;

  /// Rating associated to the comment
  double rating;

  /// All subcomments of this comment.
  List<SubComment> subcomments = [];

  /// Main text.
  String text;

  /// Comment author.
  final User author;

  /// Constructor.
  Comment(
      {this.id,
      @required this.dateAdded,
      @required this.dateModified,
      @required this.rating,
      this.subcomments,
      @required this.text,
      @required this.author});

  /// Builds the comment widget.
  Widget build(context) {
    return Column(
      children: [
        Row(
          children: [
            this.author.buildSmallProfile(),
            this._getDateAdded(),
            this._getDateModified(),
          ],
        ),
        this._getRatingBar(),
        Text(this.text),
        (this.subcomments.length > 0 ? this._getSubComments(context) : null),
      ],
    );
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

  /// Gets the rating bar widget.
  Widget _getRatingBar() {
    return RatingBarIndicator(
      rating: this.rating,
      direction: Axis.horizontal,
      itemCount: 5,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
    );
  }

  /// Gets the widget which contains all subcomments.
  Widget _getSubComments(context) {
    return ExpansionTile(
      title: Text("Sous-commentaires"),
      initiallyExpanded: false,
      leading: Icon(Icons.comment),
      trailing: Icon(Icons.arrow_drop_down),
      children: [
        ListView.builder(
          itemCount: this.subcomments.length,
          itemBuilder: (context, index) {
            return subcomments[index].build(context);
          },
        ).build(context)
      ],
    );
  }
}
