import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_firestore_db.dart';
import '../reduction_code_used.dart';
import '../../utils.dart';

/// Model used to communicate with the database for the
/// reduction code used collection.
class ReductionCodeUsedModel extends FirebaseFirestoreDB<ReductionCodeUsed> {
  /// Default constructor.
  ReductionCodeUsedModel()
      : super("reduction-codes-used", [
          "userId",
          "reductionCodeId",
          "whenUsed",
        ]);

  @override
  ReductionCodeUsed getTElement(DocumentSnapshot value) {
    return ReductionCodeUsed(
      id: value.id,
      reductionCodeId: value['reductionCodeId'],
      userId: value['userId'],
      whenUsed: convertStringToDatetime(value['whenUsed'], full: true),
    );
  }

  @override
  Map<String, dynamic> getElementData(ReductionCodeUsed object) {
    return {
      'userId': object.userId,
      'whenUsed': convertDatetimeToString(object.whenUsed, full: true),
      'reductionCodeId': object.reductionCodeId,
    };
  }
}
