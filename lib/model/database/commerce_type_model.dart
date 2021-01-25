import 'package:cloud_firestore/cloud_firestore.dart';

import '../commerce.dart';
import 'commerce_model.dart';
import 'firebase_firestore_db.dart';
import '../commerce_type.dart';

/// Model used to communicate with the database for the
/// commerce type collection.
class CommerceTypeModel extends FirebaseFirestoreDB<CommerceType> {
  /// Default constructor.
  CommerceTypeModel() : super("commerce-types", ["name"]);

  @override
  CommerceType getTElement(DocumentSnapshot value) {
    return CommerceType(
      name: value['name'],
      id: value.id,
    );
  }

  @override
  Map<String, dynamic> getElementData(CommerceType object) {
    return {
      'name': object.name,
    };
  }

  @override
  Future<bool> delete(String id) async {
    CommerceModel model = CommerceModel();
    List<Commerce> commerces = await model
        .whereLinked("type", isEqualTo: id)
        .executeCurrentLinkedQueryRequest();
    List<bool> results = await Future.wait(commerces.map((element) {
      return model.delete(element.id);
    }));
    for (bool r in results) {
      if (r == false) {
        return Future.value(false);
      }
    }
    return super.delete(id);
  }
}
