import 'package:flutter/material.dart';
import 'package:hello_caen/screens/account_profile/account_profile_screen.dart';

import 'screens/home/home_screen.dart';
import 'screens/sign_in/sign_in_screen.dart';
import 'screens/explanations/explanations_screen.dart';

/// All routes used in our app.
final Map<String, WidgetBuilder> routes = {
  ExplanationsScreen.routeName: (context) => ExplanationsScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  AccountProfileScreen.routeName: (context) => AccountProfileScreen(),
};
