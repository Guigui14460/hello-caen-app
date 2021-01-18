import 'package:flutter/material.dart';

import 'commerce.dart';
import 'database/commerce_model.dart';

/// Represents a reduction code.
class ReductionCode {
  // ID of the object in database.
  String id;

  /// Commerce associated.
  final String commerceId;
  Commerce commerce;

  /// Date of beginning.
  DateTime beginDate;

  /// Date of ending.
  DateTime endDate;

  /// Notify all user or only if commerce
  /// is in favorites.
  bool notifyAllUser = false; // premium possible avec ça

  /// Max number of available codes.
  int maxAvailableCodes;

  /// Number of used codes.
  int usedCodes;

  /// Access conditions.
  String conditions;

  /// Use the percentage or static reduction.
  bool usePercentage;

  /// Reduction amount itself.
  int reductionAmount;

  /// Constructor.
  ReductionCode({
    this.id,
    this.notifyAllUser,
    this.commerce,
    @required this.commerceId,
    @required this.beginDate,
    @required this.endDate,
    @required this.maxAvailableCodes,
    @required this.usedCodes,
    @required this.conditions,
    @required this.usePercentage,
    @required this.reductionAmount,
  });

  /// Initializes commerce associated to this
  /// code.
  void init() async {
    await Future.wait([
      CommerceModel()
          .getById(this.commerceId)
          .then((value) => this.commerce = value)
    ]);
  }

  /// Gets the QR Code image generated for this
  /// code.
  Image getQRCodeWidget() {
    return null;
  }
}
