import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_firestore_db.dart';
import '../reduction_code_used.dart';

/// Model used to communicate with the database for the
/// reduction code used collection.
class ReductionCodeUsedModel extends FirebaseFirestoreDB<ReductionCodeUsed> {
  /// Default constructor.
  ReductionCodeUsedModel()
      : super("reduction-codes-used", [
          "user",
          "reductionCode",
          "whenUsed",
        ]);

  @override
  ReductionCodeUsed getTElement(DocumentSnapshot value) {
    return ReductionCodeUsed(
      id: value.id,
      reductionCodeId: value['reductionCode'].id,
      userId: value['user'].id,
      whenUsed: value['whenUsed'].toDate(),
    );
  }

  @override
  Map<String, dynamic> getElementData(ReductionCodeUsed object) {
    return {
      'user': object.getUserRef(),
      'whenUsed': Timestamp.fromDate(object.whenUsed),
      'reductionCode': object.getReductionCodeRef(),
    };
  }
}
