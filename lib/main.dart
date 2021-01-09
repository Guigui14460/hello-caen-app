import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'routes.dart';
import 'settings.dart';
import 'screens/splash/splash_screen.dart';
import 'services/firebase_settings.dart';
import 'services/theme_manager.dart';

/// Entry point function.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  runApp(ChangeNotifierProvider<ThemeManager>(
    create: (_) => ThemeManager(),
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
      initialRoute: SplashScreen.routeName,
      routes: routes,
    );
  }
}
