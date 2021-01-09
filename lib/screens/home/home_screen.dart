import 'package:flutter/material.dart';

import 'components/home_body.dart';

/// Screen displayed by default for all users.
class HomeScreen extends StatelessWidget {
  /// Name of the route where is the screen.
  static final String routeName = "/home";

  @override
  Widget build(BuildContext context) {
    return HomeBody();
  }
}
