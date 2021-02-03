import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'database/reduction_code_model.dart';
import 'database/user_model.dart';

class ReductionCodeUsed {
  String id;
  final String userId, reductionCodeId;
  final DateTime whenUsed;

  ReductionCodeUsed(
      {this.id,
      @required this.userId,
      @required this.reductionCodeId,
      @required this.whenUsed});

  DocumentReference getUserRef() {
    return UserModel().getDocumentReference(this.userId);
  }

  DocumentReference getReductionCodeRef() {
    return ReductionCodeModel().getDocumentReference(this.reductionCodeId);
  }
}
