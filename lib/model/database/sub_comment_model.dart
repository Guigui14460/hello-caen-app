import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_firestore_db.dart';
import '../sub_comment.dart';
import '../../utils.dart';

/// Model used to communicate with the database for the
/// sub-comment collection.
class SubCommentModel extends FirebaseFirestoreDB<SubComment> {
  /// Constructor.
  SubCommentModel()
      : super("subcomments", [
          "text",
          "author",
          "dateAdded",
          "dateModified",
        ]);

  @override
  Map<String, dynamic> getElementData(SubComment object) {
    return {
      "text": object.text,
      "author": object.authorId,
      "dateAdded": convertDatetimeToString(object.dateAdded),
      "dateModified": convertDatetimeToString(object.dateModified),
    };
  }

  @override
  SubComment getTElement(DocumentSnapshot value) {
    return new SubComment(
      id: value.id,
      text: value['text'],
      authorId: value['author'],
      dateAdded: convertStringToDatetime(value['dateAdded']),
      dateModified: convertStringToDatetime(value['dateModified']),
    );
  }
}
