import 'package:flutter/material.dart';

import 'components/account_profile_body.dart';

/// Screen displayed by default for all users.
class AccountProfileScreen extends StatelessWidget {
  /// Name of the route where is the screen.
  static final String routeName = "/account-profile";

  @override
  Widget build(BuildContext context) {
    return AccountProfileBody();
  }
}
