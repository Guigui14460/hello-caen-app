import 'dart:async';
import 'dart:io';

import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'routes.dart';
import 'settings.dart';
import 'screens/explanations/explanations_screen.dart';
import 'screens/home/home_screen.dart';
import 'services/firebase_settings.dart';
import 'services/location_service.dart';
import 'services/notification_service.dart';
import 'services/storage_manager.dart';
import 'services/theme_manager.dart';
import 'services/user_manager.dart';

String initialRoute = ExplanationsScreen.routeName;

/// Entry point function.
Future<void> main() async {
  // widgets initialization
  WidgetsFlutterBinding.ensureInitialized();
  await StorageManager.readData("firstConnection").then((value) {
    if (value == null) {
      StorageManager.saveData("firstConnection", false);
    } else {
      initialRoute = HomeScreen.routeName;
    }
  });

  // firebase initialization
  FirebaseApp app = await Firebase.initializeApp(
    options: Platform.isIOS || Platform.isMacOS
        ? FirebaseOptions(
            projectId: firebaseProjectId,
            appId: iosAppId,
            databaseURL: firebaseDBLink,
            storageBucket: firebaseStorageLink,
            apiKey: iosApiKey,
            messagingSenderId: firebaseMessagingSenderID,
          )
        : FirebaseOptions(
            projectId: firebaseProjectId,
            appId: androidAppId,
            databaseURL: firebaseDBLink,
            storageBucket: firebaseStorageLink,
            apiKey: androidApiKey,
            messagingSenderId: firebaseMessagingSenderID,
          ),
  );
  FirebaseSettings.createInstance(app);

  // timeago initialization
  timeago.setLocaleMessages('fr_short', timeago.FrShortMessages());
  timeago.setDefaultLocale("fr_short");

  // date format initialization
  await initializeDateFormatting('fr_FR', null);
  Intl.defaultLocale = "fr_FR";

  // local notification initialization
  await NotificationService.init();

  // location initialization
  await LocationService.init();

  // user initialization
  await UserManager.init();

  // app and managers
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<ThemeManager>.value(value: ThemeManager()),
      ChangeNotifierProvider<UserManager>.value(value: UserManager.instance),
      ChangeNotifierProvider<NotificationService>.value(
          value: NotificationService.instance),
      ChangeNotifierProvider<LocationService>.value(
          value: LocationService.instance),
    ],
    child: HelloCaenApplication(),
  ));
}

/// Application itself.
class HelloCaenApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hello Caen',
      theme: Provider.of<ThemeManager>(context).getTheme(),
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      routes: routes,
    );
  }
}
