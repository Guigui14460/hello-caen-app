import 'package:flutter/material.dart';

/// Represents a type of commerce.
class CommerceType {
  // ID of the object in database.
  String id;

  /// Name of the type.
  String name;

  /// Constructor.
  CommerceType({this.id, @required this.name});
}
