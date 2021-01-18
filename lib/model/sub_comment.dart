import 'package:flutter/material.dart';

import 'user_account.dart';
import '../utils.dart';

class SubComment {
  // ID of the object in database.
  String id;

  /// Main text.
  String text;

  /// Date of creation.
  final DateTime dateAdded;

  /// Date of last modification.
  DateTime dateModified;

  /// Comment author.
  final User author;

  /// Constructor.
  SubComment(
      {this.id,
      @required this.text,
      @required this.author,
      @required this.dateAdded,
      @required this.dateModified});

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
        Text(this.text),
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
}
