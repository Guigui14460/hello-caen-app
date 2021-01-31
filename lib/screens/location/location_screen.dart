import 'package:flutter/material.dart';

import 'components/location_body.dart';
import 'components/location_store_list.dart';


/// Screen displayed by default for all users.
class LocationScreen extends StatelessWidget {
  /// Name of the route where is the screen.
  static final String routeName = "/location";

  @override
  Widget build(BuildContext context) {

    return LocationStoreList();

  }
}
