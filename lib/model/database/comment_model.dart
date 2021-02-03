import 'package:cloud_firestore/cloud_firestore.dart';

import 'commerce_model.dart';
import 'firebase_firestore_db.dart';
import 'sub_comment_model.dart';
import 'user_model.dart';
import '../comment.dart';

/// Model used to communicate with the database for the
/// comment collection.
class CommentModel extends FirebaseFirestoreDB<Comment> {
  /// Constructor.
  CommentModel()
      : super("comments", [
          "text",
          "author",
          "commerce",
          "dateAdded",
          "dateModified",
          "rating",
        ]);

  @override
  Map<String, dynamic> getElementData(Comment object) {
    return {
      "text": object.text,
      "author": UserModel().getDocumentReference(object.authorId),
      "commerce": CommerceModel().getDocumentReference(object.commerceId),
      "dateAdded": Timestamp.fromDate(object.dateAdded),
      "dateModified": Timestamp.fromDate(object.dateModified),
      "rating": object.rating,
    };
  }

  @override
  Comment getTElement(DocumentSnapshot value) {
    return new Comment(
      id: value.id,
      text: value['text'],
      authorId: value['author'].id,
      commerceId: value['commerce'].id,
      dateAdded: value['dateAdded'].toDate(),
      dateModified: value['dateModified'].toDate(),
      rating: value['rating'],
    );
  }

  @override
  Future<bool> delete(String id) async {
    SubCommentModel subCommentModel = SubCommentModel();
    List<bool> results = await Future.wait((await subCommentModel
            .where("comment", isEqualTo: this.getDocumentReference(id)))
        .map((element) {
      return subCommentModel.delete(element.id);
    }));
    for (bool r in results) {
      if (r == false) {
        return Future.value(false);
      }
    }
    return super.delete(id);
  }
}
