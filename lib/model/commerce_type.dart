import 'package:flutter/material.dart';

/// Represents a type of commerce.
class CommerceType {
  /// Name of the type.
  String name;

  /// Constructor.
  CommerceType({@required this.name});

  String getName() => this.name;
  void setName(String value) => this.name = value;
}
