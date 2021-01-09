import 'package:flutter/material.dart';

/// Class to create all widgets of the [SignInScreen].
class SignInBody extends StatefulWidget {
  @override
  _SignInBodyState createState() => _SignInBodyState();
}

/// State of the [SignInBody].
class _SignInBodyState extends State<SignInBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Column(
          children: [
            Text("Retourner à l'accueil"),
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Retourner"),
            ),
          ],
        ),
      ),
    );
  }
}
