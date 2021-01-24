import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'form.dart';
import '../../../model/user_account.dart';
import '../../../services/size_config.dart';
import '../../../services/user_manager.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserManager>(context).getLoggedInUser();
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
            vertical: getProportionateScreenHeight(10)),
        child: Column(
          children: [
            Text(
              "Mettez votre compte à jour",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: getProportionateScreenWidth(30)),
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            ParametersForm(user: user),
          ],
        ),
      ),
    );
  }
}
