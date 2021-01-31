import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_firestore_db.dart';
import 'reduction_code_used_model.dart';
import '../reduction_code_used.dart';
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
      conditions: value['conditions'],
      usePercentage: value['usePercentage'],
      reductionAmount: double.parse("${value['reductionAmount']}"),
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
      'conditions': object.conditions,
      'usePercentage': object.usePercentage,
      'reductionAmount': object.reductionAmount,
    };
  }

  @override
  Future<bool> delete(String id) async {
    ReductionCodeUsedModel model = ReductionCodeUsedModel();
    List<ReductionCodeUsed> used =
        await model.where("reductionCodeId", isEqualTo: id);
    List<bool> results = await Future.wait(used.map((e) => model.delete(e.id)));
    for (bool r in results) {
      if (r == false) {
        return Future.value(false);
      }
    }
    return super.delete(id);
  }
}
