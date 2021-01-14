import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/app_bar.dart';
import '../../../components/default_button.dart';
import '../../../services/location_service.dart';
import '../../../services/theme_manager.dart';
import '../../../services/size_config.dart';

/// Class to build all widgets of the [HomeScreen].
class HomeBody extends StatefulWidget {
  HomeBody({Key key}) : super(key: key);

  @override
  _HomeBodyState createState() => _HomeBodyState();
}

/// [State] of the [HomeBody].
class _HomeBodyState extends State<HomeBody> {
  Widget _location = Text("No Location");

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context); // if the user doesn't come from SplashScreen
    ThemeManager themeManager = Provider.of<ThemeManager>(context);

    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DefaultButton(
                height: 50,
                text: "Localisation",
                press: () => {
                      LocationService.getInstance().getLocationData(),
                      setState(() {
                        _location = LocationService.getInstance().getText();
                      }),
                    },
                longPress: () => {}),
            (_location != null ? _location : Text("No location")),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Changer le mode"),
                Switch(
                    value: themeManager.isDarkMode(),
                    onChanged: (toggle) {
                      setState(() {
                        themeManager.toggleThemeMode();
                      });
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
