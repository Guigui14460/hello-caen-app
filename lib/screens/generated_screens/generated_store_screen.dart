import 'package:flutter/material.dart';
import 'package:hello_caen/model/commerce.dart';
import 'package:hello_caen/model/database/commerce_model.dart';
import '../../services/size_config.dart';
import 'components/generated_store_page.dart';
/// Screen displayed by default for all users.
class GeneratedStoreScreen extends StatelessWidget {
  /// Name of the route where is the screen.
  static final String routeName = "/GeneratedStore";

  final Commerce data;

  const GeneratedStoreScreen({Key key, this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GeneratedStorePage(data :this.data);
  }
}