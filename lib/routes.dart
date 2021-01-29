import 'package:flutter/material.dart';

import 'screens/explanations/explanations_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/sign_in/sign_in_screen.dart';
import 'screens/sign_up/sign_up_screen.dart';
import 'screens/forgot_password/forgot_password_screen.dart';
import 'screens/account_parameters/account_parameters_screen.dart';
import 'screens/reduction_code_detail/reduction_code_detail_screen.dart';
import 'screens/reduction_code_detail/reduction_code_detail_qr_code_screen.dart';

import 'screens/pro/home_screen.dart';
import 'screens/pro/preview_page.dart';
import 'screens/pro/update_commerce_screen.dart';
import 'screens/pro/update_reduction_code_screen.dart';

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
  ReductionCodeDetailScreen.routeName: (context) => ReductionCodeDetailScreen(),
  QRCodeReductionCodeDetailScreen.routeName: (context) =>
      QRCodeReductionCodeDetailScreen(),

  // pro screens
  ProHomeScreen.routeName: (context) => ProHomeScreen(),
  UpdateCommerceScreen.routeName: (context) => UpdateCommerceScreen(),
  UpdateReductionCodeScreen.routeName: (context) => UpdateReductionCodeScreen(),
  PreviewCommerceScreen.routeName: (context) => PreviewCommerceScreen(),
  UpdateReductionCodeScreen.routeName: (context) => UpdateReductionCodeScreen(),

  // admin screens
  AdminHomeScreen.routeName: (context) => AdminHomeScreen(),
};
