import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_caen/components/default_button.dart';
import 'package:provider/provider.dart';

import '../../components/app_bar.dart';
import '../../components/custom_dialog.dart';
import '../../model/reduction_code.dart';
import '../../model/user_account.dart';
import '../../services/size_config.dart';
import '../../services/user_manager.dart';

class ReductionCodeDetailScreen extends StatelessWidget {
  static final String routeName = "/reduction-codes/detail";
  final ReductionCode code;

  const ReductionCodeDetailScreen({Key key, @required this.code})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    User user =
        Provider.of<UserManager>(context, listen: false).getLoggedInUser();
    return SafeArea(
        child: Scaffold(
      appBar: MyAppBar(
          actions: [Icon(Icons.info_outline)],
          actionsCallback: [() => _infoDialog(context)]),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
            vertical: getProportionateScreenHeight(10),
          ),
          child: Column(
            children: [
              SizedBox(height: getProportionateScreenHeight(28)),
              Text(
                code.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: getProportionateScreenWidth(40)),
              ),
              DefaultButton(
                  text: "Voir le QR code",
                  press: () => Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) =>
                              ReductionCodeDetailScreen(code: code))),
                  longPress: () {}),
            ],
          ),
        ),
      ),
    ));
  }

  _infoDialog(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogBox(
            title: "Information",
            description:
                "Ce code de réduction ne peut être utilisé qu'une seule et unique fois par ce compte.",
            text: "OK",
            onPressed: () {
              Navigator.pop(context);
            },
          );
        });
  }
}
