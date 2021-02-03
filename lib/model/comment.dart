import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'sub_comment.dart';
import 'user_account.dart';
import 'database/commerce_model.dart';
import 'database/user_model.dart';
import '../utils.dart';

/// Represents a comment.
class Comment {
  // ID of the object in database.
  String id;

  /// Date of creation.
  final DateTime dateAdded;

  String commerceId;

  /// Date of last modification.
  DateTime dateModified;

  /// Rating associated to the comment
  double rating;

  /// Main text.
  String text;

  /// Comment author.
  final String authorId;

  /// Constructor.
  Comment(
      {this.id,
      @required this.commerceId,
      @required this.dateAdded,
      @required this.dateModified,
      @required this.rating,
      @required this.text,
      @required this.authorId});

  DocumentReference getAuthorRef() {
    return UserModel().getDocumentReference(this.authorId);
  }

  DocumentReference getCommerceRef() {
    return CommerceModel().getDocumentReference(this.commerceId);
  }

  /// Builds the comment widget.
  Widget build(context, List<SubComment> subcomments) {
    return Column(
      children: [
        Row(
          children: [
            this._buildSmallProfile(),
            this._getDateAdded(),
            this._getDateModified(),
          ],
        ),
        this._getRatingBar(),
        Text(this.text),
        (subcomments.length > 0
            ? this._getSubComments(context, subcomments)
            : null),
      ],
    );
  }

  Widget _buildSmallProfile() {
    return FutureBuilder(
        future: UserModel().getById(id),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          return (snapshot.hasData
              ? snapshot.data.buildSmallProfile()
              : snapshot.hasError
                  ? Text("Erreur de chargement")
                  : Center(child: CircularProgressIndicator()));
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
  Widget _getSubComments(context, List<SubComment> subcomments) {
    return ExpansionTile(
      title: Text("Sous-commentaires"),
      initiallyExpanded: false,
      leading: Icon(Icons.comment),
      trailing: Icon(Icons.arrow_drop_down),
      children: [
        ListView.builder(
          itemCount: subcomments.length,
          itemBuilder: (context, index) {
            return subcomments[index].build(context);
          },
        ).build(context)
      ],
    );
  }
}
