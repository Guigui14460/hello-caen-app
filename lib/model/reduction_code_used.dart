import 'package:flutter/material.dart';

class ReductionCodeUsed {
  String id;
  final String userId, reductionCodeId;
  final DateTime whenUsed;

  ReductionCodeUsed(
      {this.id,
      @required this.userId,
      @required this.reductionCodeId,
      @required this.whenUsed});
}
