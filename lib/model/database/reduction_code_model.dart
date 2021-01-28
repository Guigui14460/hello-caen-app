import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_firestore_db.dart';
import '../reduction_code.dart';
import '../../utils.dart';

/// Model used to communicate with the database for the
/// reduction code collection.
class ReductionCodeModel extends FirebaseFirestoreDB<ReductionCode> {
  /// Default constructor.
  ReductionCodeModel()
      : super("reduction-codes", [
          "commerce",
          "name",
          "beginDate",
          "endDate",
          "notifyAllUser",
          "maxAvailableCodes",
          "userIdsWhoUsedCode",
          "conditions",
          "usePercentage",
          "reductionAmount",
        ]);

  @override
  ReductionCode getTElement(DocumentSnapshot value) {
    return ReductionCode(
      id: value.id,
      commerceId: value['commerce'],
      name: value['name'],
      beginDate: convertStringToDatetime(value['beginDate']),
      endDate: convertStringToDatetime(value['endDate']),
      notifyAllUser: value['notifyAllUser'],
      maxAvailableCodes: value['maxAvailableCodes'],
      userIdsWhoUsedCode: List<String>.from(value['userIdsWhoUsedCode']),
      conditions: value['conditions'],
      usePercentage: value['usePercentage'],
      reductionAmount: value['reductionAmount'],
    );
  }

  @override
  Map<String, dynamic> getElementData(ReductionCode object) {
    return {
      'commerce': object.commerceId,
      'beginDate': convertDatetimeToString(object.beginDate),
      'endDate': convertDatetimeToString(object.endDate),
      'notifyAllUser': object.notifyAllUser,
      'name': object.name,
      'maxAvailableCodes': object.maxAvailableCodes,
      'userIdsWhoUsedCode': object.userIdsWhoUsedCode,
      'conditions': object.conditions,
      'usePercentage': object.usePercentage,
      'reductionAmount': object.reductionAmount,
    };
  }
}
