import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/app_bar.dart';
import '../../model/commerce.dart';
import '../../services/size_config.dart';
import '../../services/theme_manager.dart';

class PreviewCommerceScreen extends StatelessWidget {
  static final String routeName = "/pro/commerce/preview";
  const PreviewCommerceScreen({this.commerce, Key key}) : super(key: key);
  final Commerce commerce;

  @override
  Widget build(BuildContext context) {
    ThemeManager themeManager = Provider.of<ThemeManager>(context);
    bool isDarkMode = themeManager.isDarkMode();

    return SafeArea(
        child: Scaffold(
      appBar: MyAppBar(
        actions: [
          isDarkMode ? Icon(Icons.brightness_2) : Icon(Icons.brightness_5),
          Icon(Icons.visibility_off)
        ],
        actionsCallback: [
          themeManager.toggleThemeMode,
          () => Navigator.pop(context)
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(20),
              vertical: getProportionateScreenHeight(10)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Preview",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: getProportionateScreenWidth(30)),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
