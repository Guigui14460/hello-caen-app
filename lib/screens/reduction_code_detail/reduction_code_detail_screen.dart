import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'reduction_code_detail_qr_code_screen.dart';
import '../../components/app_bar.dart';
import '../../components/custom_dialog.dart';
import '../../components/default_button.dart';
import '../../model/reduction_code.dart';
import '../../screens/sign_in/sign_in_screen.dart';
import '../../services/size_config.dart';
import '../../services/user_manager.dart';

class ReductionCodeDetailScreen extends StatelessWidget {
  static final String routeName = "/reduction-codes/detail";
  final ReductionCode code;

  const ReductionCodeDetailScreen({Key key, @required this.code})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserManager userManager = Provider.of<UserManager>(context);
    int codeAvailableLeft =
        code.maxAvailableCodes - code.userIdsWhoUsedCode.length;
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
          child: SizedBox(
            width: double.infinity,
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
                SizedBox(height: getProportionateScreenHeight(40)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Commence le ",
                              style: TextStyle(
                                  fontSize: getProportionateScreenWidth(18.5),
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              _displayDate(code.beginDate),
                              style: TextStyle(
                                  fontSize: getProportionateScreenWidth(18.5)),
                            ),
                          ],
                        ),
                        SizedBox(height: getProportionateScreenHeight(3)),
                        Row(
                          children: [
                            Text(
                              "Se finit le ",
                              style: TextStyle(
                                  fontSize: getProportionateScreenWidth(18.5),
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              _displayDate(code.endDate),
                              style: TextStyle(
                                  fontSize: getProportionateScreenWidth(18.5)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: getProportionateScreenHeight(40)),
                    Row(
                      children: [
                        Text(
                          "Montant de la réduction : ",
                          style: TextStyle(
                              fontSize: getProportionateScreenWidth(18.5),
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${code.reductionAmount} " +
                              (code.usePercentage ? "%" : "€"),
                          style: TextStyle(
                              fontSize: getProportionateScreenWidth(18.5)),
                        ),
                      ],
                    ),
                    SizedBox(height: getProportionateScreenHeight(40)),
                    Text(
                      "Conditions :",
                      style: TextStyle(
                          fontSize: getProportionateScreenWidth(18.5),
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      code.conditions,
                      style:
                          TextStyle(fontSize: getProportionateScreenWidth(14)),
                    ),
                    SizedBox(height: getProportionateScreenHeight(130)),
                    Text(
                      "Il ${codeAvailableLeft < code.maxAvailableCodes * 0.2 ? "ne reste que" : "reste"} $codeAvailableLeft codes disponibles !",
                      style: TextStyle(
                        color: codeAvailableLeft < code.maxAvailableCodes * 0.2
                            ? Colors.red
                            : Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: getProportionateScreenWidth(17),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                (userManager.isLoggedIn()
                    ? DefaultButton(
                        text: "Voir le QR code",
                        height: getProportionateScreenHeight(50),
                        press: () => Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) =>
                                    QRCodeReductionCodeDetailScreen(
                                        code: code))),
                        longPress: () {})
                    : DefaultButton(
                        text: "Connectez-vous pour\naccéder au QR code",
                        height: getProportionateScreenHeight(50),
                        press: () => Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => SignInScreen())),
                        longPress: () {})),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  String _displayDate(DateTime date) {
    return DateFormat.yMMMMd().format(date);
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
