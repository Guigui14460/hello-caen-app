import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'database/commerce_model.dart';

/// Represents a reduction code.
class ReductionCode {
  // ID of the object in database.
  String id;

  final String name;

  /// Commerce associated.
  final String commerceId;

  /// Date of beginning.
  DateTime beginDate;

  /// Date of ending.
  DateTime endDate;

  /// Notify all user or only if commerce
  /// is in favorites.
  bool notifyAllUser = false; // premium possible avec ça

  /// Max number of available codes.
  int maxAvailableCodes;

  /// Access conditions.
  String conditions;

  /// Use the percentage or static reduction.
  bool usePercentage;

  /// Reduction amount itself.
  double reductionAmount;

  /// Constructor.
  ReductionCode({
    this.id,
    this.notifyAllUser,
    @required this.name,
    @required this.commerceId,
    @required this.beginDate,
    @required this.endDate,
    @required this.maxAvailableCodes,
    @required this.conditions,
    @required this.usePercentage,
    @required this.reductionAmount,
  });

  DocumentReference getCommerceRef() {
    return CommerceModel().getDocumentReference(this.commerceId);
  }
}
