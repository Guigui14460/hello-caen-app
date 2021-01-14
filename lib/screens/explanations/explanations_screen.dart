import 'package:flutter/material.dart';

import '../../services/size_config.dart';
import 'components/explanations_body.dart';

/// Screen displayed when the user comes to the first time
/// on the app. This is a mini-tutorial.
class ExplanationsScreen extends StatelessWidget {
  /// Name of the route where is the screen.
  static final String routeName = "/explanations";

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      child: Scaffold(
        body: ExplanationsBody(),
      ),
    );
  }
}
