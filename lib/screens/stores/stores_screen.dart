import 'package:flutter/material.dart';

import '../../services/size_config.dart';
import 'components/stores_body.dart';

class StoresScreen extends StatelessWidget {
  /// Name of the route where is the screen.
  static final String routeName = "/stores";

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: StoresBody(),
      ),
    );
  }
}