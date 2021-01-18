import 'package:cloud_firestore/cloud_firestore.dart';

import '../commerce.dart';
import 'firebase_firestore_db.dart';
import '../../utils.dart';

/// Model used to communicate with the database for the
/// commerce collection.
class CommerceModel extends FirebaseFirestoreDB<Commerce> {
  /// Constructor.
  CommerceModel() : super("commerces");

  @override
  Map<String, dynamic> getElementData(Commerce object) {
    return {
      "name": object.name,
      "location": object.location,
      "dateAdded": convertDatetimeToString(object.dateAdded),
      "dateModified": convertDatetimeToString(object.dateModified),
      "timetables": object.timetables,
      "type": object.type,
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
      type: value['type'],
      commentIds: value['comments'],
      imageLink: value['imageLink'],
      ownerId: value['owner'],
    );
  }
}
