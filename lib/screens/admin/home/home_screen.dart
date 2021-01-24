import 'package:flutter/material.dart';

class AdminHomeScreen extends StatelessWidget {
  static String routeName = "/admin/home";
  const AdminHomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Admin Home"),
    );
  }
}
