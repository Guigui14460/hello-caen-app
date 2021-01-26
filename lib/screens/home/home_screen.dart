import 'package:flutter/material.dart';

import 'components/home_body.dart';
import '../../services/size_config.dart';

/// Screen displayed by default for all users.
class HomeScreen extends StatelessWidget {
  /// Name of the route where is the screen.
  static final String routeName = "/home";

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return HomeBody();
  }
}
