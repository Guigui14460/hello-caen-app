import 'package:flutter/material.dart';

import 'components/body.dart';
import '../../components/app_bar.dart';
import '../../components/custom_dialog.dart';

class AccountParametersScreen extends StatelessWidget {
  static String routeName = "/accounts/update";
  final bool firstTime;

  const AccountParametersScreen({Key key, this.firstTime = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: MyAppBar(
        automaticBackArrow: !firstTime,
        actions: [Icon(Icons.info_outline_rounded)],
        actionsCallback: [() => _info(context)],
      ),
      body: Body(),
    ));
  }

  void _info(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogBox(
            title: "Info",
            description:
                "Vos informations ne sont pas révélées. Elles sont utilisées à des fins statistiques pour les commerçants. Seuls votre prénom et nom de famille seront visibles par les autres utilisateurs.",
            text: "OK",
            onPressed: () => Navigator.pop(context),
          );
        });
  }
}
