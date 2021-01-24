import 'package:flutter/material.dart';
import 'package:hello_caen/screens/account_parameters/account_parameters_screen.dart';
import 'package:hello_caen/screens/admin/home/home_screen.dart';
import 'package:hello_caen/screens/pro/home/home_screen.dart';

import 'screens/explanations/explanations_screen.dart';
import 'screens/forgot_password/forgot_password_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/sign_in/sign_in_screen.dart';
import 'screens/sign_up/sign_up_screen.dart';
import 'screens/stores/stores_screen.dart';

/// All routes used in our app.
final Map<String, WidgetBuilder> routes = {
  // screens see only once
  ExplanationsScreen.routeName: (context) => ExplanationsScreen(),

  // all users screens
  HomeScreen.routeName: (context) => HomeScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  AccountParametersScreen.routeName: (context) => AccountParametersScreen(),

  // pro screens
  ProHomeScreen.routeName: (context) => ProHomeScreen(),

  // admin screens
  AdminHomeScreen.routeName: (context) => AdminHomeScreen(),

  // to delete
  StoresScreen.routeName: (context) => StoresScreen(),
};
