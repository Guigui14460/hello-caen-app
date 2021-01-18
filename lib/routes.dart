import 'package:flutter/material.dart';

import 'screens/home/home_screen.dart';
import 'screens/sign_in/sign_in_screen.dart';


import 'screens/stores/stores_screen.dart';

import 'screens/explanations/explanations_screen.dart';


/// All routes used in our app.
final Map<String, WidgetBuilder> routes = {
  ExplanationsScreen.routeName: (context) => ExplanationsScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  StoresScreen.routeName: (context) => StoresScreen(),
};
