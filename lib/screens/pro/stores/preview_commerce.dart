import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../components/app_bar.dart';
import '../../../model/commerce_type.dart';
import '../../../services/size_config.dart';
import '../../../services/theme_manager.dart';

class PreviewCommerceScreen extends StatelessWidget {
  static final String routeName = "/pro/commerce/preview";

  final String description, name, timetables, imageLink;
  final double latitude, longitude;
  final CommerceType type;
  final PickedFile image;
  const PreviewCommerceScreen(
      {this.name,
      this.description,
      this.latitude,
      this.longitude,
      this.imageLink,
      this.image,
      this.type,
      this.timetables,
      Key key})
      : super(key: key);

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
