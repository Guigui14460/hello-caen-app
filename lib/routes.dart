import 'package:flutter/material.dart';
import 'package:hello_caen/screens/home/home_screen.dart';
import 'package:hello_caen/screens/sign_in/sign_in_screen.dart';
import 'package:hello_caen/screens/splash/splash_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
};
