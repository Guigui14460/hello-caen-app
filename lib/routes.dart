import 'package:flutter/material.dart';

import 'screens/account_profile/account_profile_screen.dart';
import 'screens/explanations/explanations_screen.dart';
import 'screens/forgot_password/forgot_password_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/sign_in/sign_in_screen.dart';
import 'screens/sign_up/sign_up_screen.dart';
import 'screens/stores/stores_screen.dart';

/// All routes used in our app.
final Map<String, WidgetBuilder> routes = {
  ExplanationsScreen.routeName: (context) => ExplanationsScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  StoresScreen.routeName: (context) => StoresScreen(),
  AccountProfileScreen.routeName: (context) => AccountProfileScreen(),
};
