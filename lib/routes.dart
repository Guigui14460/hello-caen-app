import 'package:flutter/material.dart';

import 'screens/explanations/explanations_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/sign_in/sign_in_screen.dart';
import 'screens/sign_up/sign_up_screen.dart';
import 'screens/forgot_password/forgot_password_screen.dart';
import 'screens/account_parameters/account_parameters_screen.dart';

import 'screens/pro/home/home_screen.dart';
import 'screens/pro/stores/preview_commerce.dart';
import 'screens/pro/stores/update_commerce_screen.dart';

import 'screens/admin/home/home_screen.dart';

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
  UpdateCommerceScreen.routeName: (context) => UpdateCommerceScreen(),
  PreviewCommerceScreen.routeName: (context) => PreviewCommerceScreen(),

  // admin screens
  AdminHomeScreen.routeName: (context) => AdminHomeScreen(),
};
