import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_firestore_db.dart';
import '../commerce_type.dart';

/// Model used to communicate with the database for the
/// commerce type collection.
class CommerceTypeModel extends FirebaseFirestoreDB<CommerceType> {
  /// Default constructor.
  CommerceTypeModel() : super("commerce-types");

  @override
  CommerceType getTElement(DocumentSnapshot value) {
    return CommerceType(name: value['name']);
  }

  @override
  Map<String, dynamic> getElementData(CommerceType object) {
    return {
      'name': object.getName(),
    };
  }
}
