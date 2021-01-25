import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_firestore_db.dart';
import 'sub_comment_model.dart';
import '../comment.dart';
import '../../utils.dart';

/// Model used to communicate with the database for the
/// comment collection.
class CommentModel extends FirebaseFirestoreDB<Comment> {
  /// Constructor.
  CommentModel()
      : super("comments", [
          "text",
          "author",
          "dateAdded",
          "dateModified",
          "subcomments",
          "rating",
        ]);

  @override
  Map<String, dynamic> getElementData(Comment object) {
    return {
      "text": object.text,
      "author": object.authorId,
      "dateAdded": convertDatetimeToString(object.dateAdded),
      "dateModified": convertDatetimeToString(object.dateModified),
      "subcomments": object.subcommentIds,
      "rating": object.rating,
    };
  }

  @override
  Comment getTElement(DocumentSnapshot value) {
    return new Comment(
      id: value.id,
      text: value['text'],
      authorId: value['author'],
      dateAdded: convertStringToDatetime(value['dateAdded']),
      dateModified: convertStringToDatetime(value['dateModified']),
      subcommentIds: value['subcomments'],
      rating: value['rating'],
    );
  }

  @override
  Future<bool> delete(String id) async {
    Comment comment = await this.getById(id);
    SubCommentModel model = SubCommentModel();
    List<bool> results = await Future.wait(comment.subcommentIds.map((element) {
      return model.delete(element);
    }));
    for (bool r in results) {
      if (r == false) {
        return Future.value(false);
      }
    }
    return super.delete(id);
  }
}
