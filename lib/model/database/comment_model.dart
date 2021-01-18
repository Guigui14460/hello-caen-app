import 'package:cloud_firestore/cloud_firestore.dart';

import '../comment.dart';
import '../database/firebase_firestore_db.dart';
import '../../utils.dart';

/// Model used to communicate with the database for the
/// comment collection.
class CommentModel extends FirebaseFirestoreDB<Comment> {
  /// Constructor.
  CommentModel() : super("comments");

  @override
  Map<String, dynamic> getElementData(Comment object) {
    return {
      "text": object.text,
      "author": object.author,
      "dateAdded": convertDatetimeToString(object.dateAdded),
      "dateModified": convertDatetimeToString(object.dateModified),
      "subcomments": object.subcomments,
      "rating": object.rating,
    };
  }

  @override
  Comment getTElement(DocumentSnapshot value) {
    return new Comment(
      text: value['text'],
      author: value['author'],
      dateAdded: convertStringToDatetime(value['dateAdded']),
      dateModified: convertStringToDatetime(value['dateModified']),
      subcomments: value['subcomments'],
      rating: value['rating'],
    );
  }
}
