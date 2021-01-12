import 'package:flutter/material.dart';

import 'user_account.dart';
import '../utils.dart';

class SubComment {
  String text;
  DateTime dateAdded;
  DateTime dateModified;
  User author;

  SubComment(
      {@required this.text,
      @required this.dateAdded,
      @required this.dateModified});

  Widget getText() {
    return Text(this.text);
  }

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

  Widget _getDateAdded() {
    return Text(convertDatetimeToString(this.dateAdded));
  }

  Widget _getDateModified() {
    return Text(
      "Modifié le " + convertDatetimeToString(this.dateModified),
      style: TextStyle(fontSize: 10),
    );
  }
}
