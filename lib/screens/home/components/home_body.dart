import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hello_caen/screens/splash/splash_screen.dart';
import 'package:provider/provider.dart';

import '../../sign_in/sign_in_screen.dart';
import '../../../components/default_button.dart';
import '../../../services/firebase_settings.dart';
import '../../../services/location_service.dart';
import '../../../services/theme_manager.dart';
import '../../../services/size_config.dart';

/// Class to build all widgets of the [HomeScreen].
class HomeBody extends StatefulWidget {
  HomeBody({Key key}) : super(key: key);

  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  Widget _location = Text("No Location");

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context); // if the user doesn't come from SplashScreen

    Query query;
    try {
      query = FirebaseSettings.instance
          .getFirestore()
          .collection("test-collection");
      query.get().then((querySnapchot) => {
            querySnapchot.docs.forEach((document) {
              print(document['ok']);
              print(document['u']);
            })
          });
    } catch (e) {
      print(e);
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 65,
          elevation: 0.0,
          centerTitle: true,
          title: SizedBox(
            height: 60,
            child: SvgPicture.asset("assets/images/logo.svg"),
          ),
          leading: IconButton(
            icon: Icon(Icons.menu),
            color: Colors.black,
            onPressed: () {
              Navigator.popAndPushNamed(context, SplashScreen.routeName);
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              color: Colors.black,
              onPressed: () {
                Navigator.pushNamed(context, SignInScreen.routeName);
              },
            )
          ],
        ),
        body: Column(
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
            DefaultButton(
                height: 50,
                text: "Changer de mode",
                press: () => {
                      Provider.of<ThemeManager>(context, listen: false)
                          .toggleThemeMode()
                    },
                longPress: () => {}),
          ],
        ),
      ),
    );
  }
}
