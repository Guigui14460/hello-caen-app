import 'package:cloud_firestore/cloud_firestore.dart';

import '../rating.dart';
import 'firebase_firestore_db.dart';

/// Model used to communicate with the database for the
/// comment collection.
class RatingModel extends FirebaseFirestoreDB<Rating> {
  /// Constructor.
  RatingModel()
      : super("ratings", [
          "rating",
          "commerce",
          "author",
        ]);

  @override
  Map<String, dynamic> getElementData(Rating object) {
    return {
      "rating": object.rating,
      "commerce": object.getCommerceRef(),
      "author": object.getAuthorRef(),
    };
  }

  @override
  Rating getTElement(DocumentSnapshot value) {
    return new Rating(
      id: value.id,
      commerceId: value['commerce'].id,
      authorId: value['author'].id,
      rating: value['rating'] + 0.0,
    );
  }
}
