import 'package:cloud_firestore/cloud_firestore.dart';

import 'comment_model.dart';
import 'commerce_type_model.dart';
import 'firebase_firestore_db.dart';
import 'reduction_code_model.dart';
import 'user_model.dart';
import '../commerce.dart';
import '../reduction_code.dart';

/// Model used to communicate with the database for the
/// commerce collection.
class CommerceModel extends FirebaseFirestoreDB<Commerce> {
  /// Constructor.
  CommerceModel()
      : super("commerces", [
          "name",
          "description",
          "location",
          "timetables",
          "type",
          "imageLink",
          "owner",
        ]);

  @override
  Map<String, dynamic> getElementData(Commerce object) {
    return {
      "name": object.name,
      "description": object.description,
      "location": GeoPoint(object.latitude, object.longitude),
      "timetables": object.timetables,
      "type": CommerceTypeModel().getDocumentReference(object.typeId),
      "imageLink": object.imageLink,
      "owner": UserModel().getDocumentReference(object.ownerId),
    };
  }

  @override
  Commerce getTElement(DocumentSnapshot value) {
    return new Commerce(
      id: value.id,
      name: value['name'],
      description: value['description'],
      latitude: value['location'].latitude,
      longitude: value['location'].longitude,
      timetables: value['timetables'],
      typeId: value['type'].id,
      imageLink: value['imageLink'],
      ownerId: value['owner'].id,
    );
  }

  @override
  Future<bool> delete(String id) async {
    CommentModel model = CommentModel();
    ReductionCodeModel model2 = ReductionCodeModel();
    List<ReductionCode> codes = await model2
        .whereLinked("commerce", isEqualTo: this.getDocumentReference(id))
        .executeCurrentLinkedQueryRequest();
    List<bool> results = await Future.wait((await model.where("commerce",
                isEqualTo: this.getDocumentReference(id)))
            .map((element) {
          return model.delete(element.id);
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
