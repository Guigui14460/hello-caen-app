import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'comment.dart';
import 'type_enterprise.dart';
import '../utils.dart';

class Enterprise {
  String name;
  String location;
  String timetables;
  TypeEnterprise type;
  List<Comment> comments;
  DateTime dateAdded;
  DateTime dateModified;
  String
      imageLink; // donnée via une image sur un site ou via un upload de fichier

  Enterprise(
      {@required this.name,
      @required this.location,
      @required this.timetables,
      @required this.type,
      @required this.comments,
      @required this.dateAdded,
      @required this.dateModified,
      @required this.imageLink});

  double _getRating() {
    double rating = 0;
    for (int i = 0; i < comments.length; i++) {
      rating += comments[i].rating;
    }
    rating /= comments.length;
    return rating;
  }

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

  String getLocation() {
    return this.location;
  }

  String getName() {
    return this.name;
  }

  TypeEnterprise getType() {
    return this.type;
  }

  Widget getDateAdded() {
    return Text(convertDatetimeToString(this.dateAdded));
  }

  Widget getDateModified() {
    return Text(convertDatetimeToString(this.dateModified));
  }

  Image getImage() {
    return Image.network(this.imageLink);
  }

  Widget getCommentsWidget(context) {
    return ListView.builder(
      itemCount: this.comments.length,
      itemBuilder: (context, index) {
        return comments[index].build(context);
      },
    ).build(context);
  }
}
