import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_firestore_db.dart';
import '../sub_comment.dart';

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
          "comment",
        ]);

  @override
  Map<String, dynamic> getElementData(SubComment object) {
    return {
      "text": object.text,
      "author": object.getAuthorRef(),
      "dateAdded": Timestamp.fromDate(object.dateAdded),
      "dateModified": Timestamp.fromDate(object.dateModified),
      "comment": object.getCommerceRef(),
    };
  }

  @override
  SubComment getTElement(DocumentSnapshot value) {
    return new SubComment(
      id: value.id,
      text: value['text'].id,
      authorId: value['author'],
      dateAdded: value['dateAdded'].toDate(),
      dateModified: value['dateModified'].toDate(),
      commentId: value['comment'].id,
    );
  }
}
