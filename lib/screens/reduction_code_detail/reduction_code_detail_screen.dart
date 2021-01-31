import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'reduction_code_detail_qr_code_screen.dart';
import '../../components/app_bar.dart';
import '../../components/custom_dialog.dart';
import '../../components/default_button.dart';
import '../../model/reduction_code.dart';
import '../../model/reduction_code_used.dart';
import '../../model/database/reduction_code_used_model.dart';
import '../../screens/sign_in/sign_in_screen.dart';
import '../../services/size_config.dart';
import '../../services/theme_manager.dart';
import '../../services/user_manager.dart';

class ReductionCodeDetailScreen extends StatefulWidget {
  static final String routeName = "/reduction-codes/detail";
  final ReductionCode code;

  const ReductionCodeDetailScreen({Key key, @required this.code})
      : super(key: key);

  @override
  _ReductionCodeDetailScreenState createState() =>
      _ReductionCodeDetailScreenState();
}

class _ReductionCodeDetailScreenState extends State<ReductionCodeDetailScreen> {
  List<ReductionCodeUsed> _used = [];

  @override
  void initState() {
    ReductionCodeUsedModel()
        .where("reductionCodeId", isEqualTo: widget.code.id)
        .then((value) {
      setState(() {
        _used = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserManager userManager = Provider.of<UserManager>(context);
    bool isDarkMode = Provider.of<ThemeManager>(context).isDarkMode();
    int codeAvailableLeft = widget.code.maxAvailableCodes - _used.length;
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
                SizedBox(height: getProportionateScreenHeight(30)),
                Text(
                  widget.code.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: getProportionateScreenWidth(40)),
                ),
                SizedBox(height: getProportionateScreenHeight(30)),
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
                              _displayDate(widget.code.beginDate),
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
                              _displayDate(widget.code.endDate),
                              style: TextStyle(
                                  fontSize: getProportionateScreenWidth(18.5)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: getProportionateScreenHeight(20)),
                    Row(
                      children: [
                        Text(
                          "Montant de la réduction : ",
                          style: TextStyle(
                              fontSize: getProportionateScreenWidth(18.5),
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${widget.code.reductionAmount} " +
                              (widget.code.usePercentage ? "%" : "€"),
                          style: TextStyle(
                              fontSize: getProportionateScreenWidth(18.5)),
                        ),
                      ],
                    ),
                    SizedBox(height: getProportionateScreenHeight(20)),
                    Text(
                      "Conditions :",
                      style: TextStyle(
                          fontSize: getProportionateScreenWidth(18.5),
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      widget.code.conditions,
                      style:
                          TextStyle(fontSize: getProportionateScreenWidth(14)),
                    ),
                    SizedBox(height: getProportionateScreenHeight(20)),
                    _getCommerceButton(
                        title: "Voir le commerce",
                        iconData: Icons.store_rounded,
                        isDarkMode: isDarkMode,
                        onTap: () {}),
                    // Navigator.push(
                    //         context,
                    //         CupertinoPageRoute(
                    //             builder: (context) =>
                    //                 CommerceDetailScreen()))),
                    SizedBox(height: getProportionateScreenHeight(20)),
                    Text(
                      (codeAvailableLeft == 0
                          ? "Plus de code disponible"
                          : "Il ${codeAvailableLeft <= (widget.code.maxAvailableCodes * 0.2).ceil() ? "ne reste que" : "reste"} $codeAvailableLeft codes disponibles !"),
                      style: TextStyle(
                        color: codeAvailableLeft <=
                                (widget.code.maxAvailableCodes * 0.2).ceil()
                            ? Colors.red
                            : Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: getProportionateScreenWidth(17),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                (userManager.isLoggedIn() && codeAvailableLeft != 0
                    ? DefaultButton(
                        text: "Voir le QR code",
                        height: getProportionateScreenHeight(50),
                        press: () => Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) =>
                                    QRCodeReductionCodeDetailScreen(
                                        code: widget.code))),
                        longPress: () {})
                    : (codeAvailableLeft == 0
                        ? SizedBox()
                        : DefaultButton(
                            text: "Connectez-vous pour\n accéder au QR code",
                            height: getProportionateScreenHeight(70),
                            press: () => Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => SignInScreen())),
                            longPress: () {}))),
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

  Widget _getCommerceButton(
      {String title,
      IconData iconData,
      VoidCallback onTap,
      Color lightModeBackgroundcolor = const Color(0xffe3e3e3),
      Color darkModeBackgroundcolor = const Color(0xff515151),
      Color lightModeForegroundcolor = Colors.black,
      Color darkModeForegroundcolor = Colors.white,
      bool isDarkMode = false,
      bool showRightArrow = true}) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color:
              isDarkMode ? darkModeBackgroundcolor : lightModeBackgroundcolor,
        ),
        width: double.infinity,
        height: getProportionateScreenHeight(50),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: (showRightArrow
              ? Row(
                  children: [
                    Row(
                      children: [
                        Icon(
                          iconData,
                          color: isDarkMode
                              ? darkModeForegroundcolor
                              : lightModeForegroundcolor,
                        ),
                        SizedBox(width: getProportionateScreenWidth(10)),
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: getProportionateScreenHeight(17),
                            color: isDarkMode
                                ? darkModeForegroundcolor
                                : lightModeForegroundcolor,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Icon(
                      Icons.keyboard_arrow_right,
                      color: isDarkMode
                          ? darkModeForegroundcolor
                          : lightModeForegroundcolor,
                    ),
                  ],
                )
              : Row(
                  children: [
                    Icon(
                      iconData,
                      color: isDarkMode
                          ? darkModeForegroundcolor
                          : lightModeForegroundcolor,
                    ),
                    SizedBox(width: getProportionateScreenWidth(10)),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: getProportionateScreenHeight(17),
                        color: isDarkMode
                            ? darkModeForegroundcolor
                            : lightModeForegroundcolor,
                      ),
                    ),
                  ],
                )),
        ),
      ),
      onTap: onTap,
    );
  }
}
