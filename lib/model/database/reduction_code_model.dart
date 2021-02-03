import 'package:cloud_firestore/cloud_firestore.dart';

import 'commerce_model.dart';
import 'firebase_firestore_db.dart';
import 'reduction_code_used_model.dart';
import '../reduction_code_used.dart';
import '../reduction_code.dart';

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
      commerceId: value['commerce'].id,
      name: value['name'],
      beginDate: value['beginDate'].toDate(),
      endDate: value['endDate'].toDate(),
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
      'commerce': CommerceModel().getDocumentReference(object.commerceId),
      'beginDate': Timestamp.fromDate(object.beginDate),
      'endDate': Timestamp.fromDate(object.endDate),
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
    List<ReductionCodeUsed> used = await model.where("reductionCode",
        isEqualTo: this.getDocumentReference(id));
    List<bool> results = await Future.wait(used.map((e) => model.delete(e.id)));
    for (bool r in results) {
      if (r == false) {
        return Future.value(false);
      }
    }
    return super.delete(id);
  }
}
