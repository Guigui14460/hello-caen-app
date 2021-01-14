import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'sub_comment.dart';
import 'user_account.dart';
import '../utils.dart';

class Comment {
  DateTime dateAdded;
  DateTime dateModified;
  double rating;
  List<SubComment> subcomments;
  String text;
  User author;

  Comment(
      {@required this.dateAdded,
      @required this.dateModified,
      @required this.rating,
      @required this.subcomments,
      @required this.text,
      @required this.author});

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
        this._getSubComments(context),
      ],
    );
  }

  Widget _getDateAdded() {
    return Text(convertDatetimeToString(this.dateAdded));
  }

  Widget _getDateModified() {
    return Text(
      "Modifié le " + convertDatetimeToString(this.dateModified),
      style: TextStyle(fontSize: 10),
    );
  }

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
