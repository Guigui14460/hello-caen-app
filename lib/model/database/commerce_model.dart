import 'package:cloud_firestore/cloud_firestore.dart';

import 'comment_model.dart';
import 'firebase_firestore_db.dart';
import 'reduction_code_model.dart';
import '../commerce.dart';
import '../reduction_code.dart';
import '../../utils.dart';

/// Model used to communicate with the database for the
/// commerce collection.
class CommerceModel extends FirebaseFirestoreDB<Commerce> {
  /// Constructor.
  CommerceModel()
      : super("commerces", [
          "name",
          "location",
          "dateAdded",
          "dateModified",
          "timetables",
          "type",
          "comments",
          "imageLink",
          "owner",
        ]);

  @override
  Map<String, dynamic> getElementData(Commerce object) {
    return {
      "name": object.name,
      "location": object.location,
      "dateAdded": convertDatetimeToString(object.dateAdded),
      "dateModified": convertDatetimeToString(object.dateModified),
      "timetables": object.timetables,
      "type": object.typeId,
      "comments": object.commentIds,
      "imageLink": object.imageLink,
      "owner": object.ownerId,
    };
  }

  @override
  Commerce getTElement(DocumentSnapshot value) {
    return new Commerce(
      id: value.id,
      name: value['name'],
      location: value['location'],
      dateAdded: convertStringToDatetime(value['dateAdded']),
      dateModified: convertStringToDatetime(value['dateModified']),
      timetables: value['timetables'],
      typeId: value['type'],
      commentIds: List<String>.from(value['comments']),
      imageLink: value['imageLink'],
      ownerId: value['owner'],
    );
  }

  @override
  Future<bool> delete(String id) async {
    Commerce commerce = await this.getById(id);
    CommentModel model = CommentModel();
    ReductionCodeModel model2 = ReductionCodeModel();
    List<ReductionCode> codes = await model
        .whereLinked("commerce", isEqualTo: id)
        .executeCurrentLinkedQueryRequest();
    List<bool> results = await Future.wait(commerce.commentIds.map((element) {
          return model.delete(element);
        }).toList() +
        codes.map((element) {
          return model2.delete(element.id);
        }).toList());
    for (bool r in results) {
      if (r == false) {
        return Future.value(false);
      }
    }
    return super.delete(id);
  }
}
