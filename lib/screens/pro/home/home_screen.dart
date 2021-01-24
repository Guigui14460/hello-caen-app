import 'package:flutter/material.dart';

class ProHomeScreen extends StatelessWidget {
  static String routeName = "/pro/home";
  const ProHomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Pro Home"),
    );
  }
}
