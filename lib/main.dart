import 'package:flutter/material.dart';
import 'package:hello_caen/constants.dart';
import 'package:hello_caen/routes.dart';
import 'package:hello_caen/screens/splash/splash_screen.dart';

void main() {
  runApp(HelloCaenApplication());
}

class HelloCaenApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hello Caen',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          headline1: TextStyle(color: primaryColor),
          bodyText1: TextStyle(color: textColor),
        ),
        appBarTheme: AppBarTheme(backgroundColor: Colors.white),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.routeName,
      routes: routes,
    );
  }
}
