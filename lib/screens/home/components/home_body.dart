import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../stores/stores_screen.dart';
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
  String _location = "No Location";

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context); // if the user doesn't come from SplashScreen
    ThemeManager themeManager = Provider.of<ThemeManager>(context);

    return SafeArea(
      child: Scaffold(
          appBar: MyAppBar(),
          body: GridView.count(
            primary: false,
            padding: const EdgeInsets.all(10),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            childAspectRatio: 0.87,
            children: [
              DefaultButton(
                  text: "Localisation ",
                  press: () => {
                        LocationService.getInstance().getLocationData(),
                        setState(() {
                          _location = LocationService.getInstance()
                              .userLocation
                              .toString();
                          print(_location);
                        }),
                      },
                  longPress: () => {}),
              DefaultButton(
                  text: "Changer de mode",
                  press: () => {themeManager.toggleThemeMode()},
                  longPress: () => {}),
              Container(
                  child: IconButton(
                icon: ImageIcon(NetworkImage(
                    "https://i.pinimg.com/originals/4e/24/f5/4e24f523182e09376bfe8424d556610a.png")),
                iconSize: 96,
                onPressed: () => {
                  Navigator.popAndPushNamed(context, StoresScreen.routeName)
                },
              )),
              Container(
                  child: DefaultButton(
                      press: () => {themeManager.toggleThemeMode()},
                      longPress: () => {},
                      text: "Bons Plans")),
              Container(
                  child: DefaultButton(
                      press: () => {themeManager.toggleThemeMode()},
                      longPress: () => {},
                      text: "Filler")),
              Container(
                  child: DefaultButton(
                      press: () => {themeManager.toggleThemeMode()},
                      longPress: () => {},
                      text: "Filler")),
            ],
          )),
    );
  }
}
