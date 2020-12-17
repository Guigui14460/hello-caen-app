import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
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
