import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:provider/provider.dart';

import 'routes.dart';
import 'settings.dart';
import 'screens/explanations/explanations_screen.dart';
import 'services/firebase_settings.dart';
import 'services/notification_service.dart';
import 'services/theme_manager.dart';

// import 'package:carp_background_location/carp_background_location.dart';

/// Entry point function.
Future<void> main() async {
  // widgets initialization
  WidgetsFlutterBinding.ensureInitialized();

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

  // local notification initialization
  NotificationService.init();

  // app and ThemeManager
  runApp(ChangeNotifierProvider<ThemeManager>(
    create: (_) => ThemeManager(),
    // child: MyApp(),
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
      initialRoute: ExplanationsScreen.routeName,
      routes: routes,
    );
  }
}

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// enum LocationStatus { UNKNOWN, RUNNING, STOPPED }

// String dtoToString(LocationDto dto) =>
//     'Location ${dto.latitude}, ${dto.longitude} at ${DateTime.fromMillisecondsSinceEpoch(dto.time ~/ 1)}';

// Widget dtoWidget(LocationDto dto) {
//   if (dto == null)
//     return Text("No location yet");
//   else
//     return Column(
//       children: <Widget>[
//         Text(
//           '${dto.latitude}, ${dto.longitude}',
//         ),
//         Text(
//           '@',
//         ),
//         Text('${DateTime.fromMillisecondsSinceEpoch(dto.time ~/ 1)}')
//       ],
//     );
// }

// class _MyAppState extends State<MyApp> {
//   LocationDto lastLocation;
//   DateTime lastTimeLocation;
//   LocationManager locationManager = LocationManager.instance;
//   Stream<LocationDto> dtoStream;
//   StreamSubscription<LocationDto> dtoSubscription;
//   LocationStatus _status = LocationStatus.UNKNOWN;

//   @override
//   void initState() {
//     super.initState();
//     // Subscribe to stream in case it is already running
//     locationManager.interval = 1;
//     locationManager.distanceFilter = 0;
//     locationManager.notificationTitle = 'CARP Location Example';
//     locationManager.notificationMsg = 'CARP is tracking your location';
//     dtoStream = locationManager.dtoStream;
//     dtoSubscription = dtoStream.listen(onData);
//   }

//   Future<void> onGetCurrentLocation() async {
//     LocationDto dto = await locationManager.getCurrentLocation();
//     print(dto);
//     print('Current location: $dto');
//   }

//   void onData(LocationDto dto) {
//     print(dtoToString(dto));
//     setState(() {
//       if (_status == LocationStatus.UNKNOWN) {
//         _status = LocationStatus.RUNNING;
//       }
//       lastLocation = dto;
//       lastTimeLocation = DateTime.now();
//     });
//   }

//   void start() async {
//     // Subscribe if it hasn't been done already
//     if (dtoSubscription != null) {
//       dtoSubscription.cancel();
//       print("cancel");
//     }
//     dtoSubscription = dtoStream.listen(onData);
//     await locationManager.start();
//     setState(() {
//       _status = LocationStatus.RUNNING;
//     });
//     LocationManager.instance.getCurrentLocation().then((value) => print(value));
//     print(lastLocation);
//   }

//   void stop() async {
//     setState(() {
//       _status = LocationStatus.STOPPED;
//     });
//     dtoSubscription.cancel();
//     await locationManager.stop();
//   }

//   Widget stopButton() {
//     Function f = stop;
//     String msg = 'STOP';

//     return SizedBox(
//       width: double.maxFinite,
//       child: RaisedButton(
//         child: Text(msg),
//         onPressed: f,
//       ),
//     );
//   }

//   Widget startButton() {
//     Function f = start;
//     String msg = 'START';
//     return SizedBox(
//       width: double.maxFinite,
//       child: RaisedButton(
//         child: Text(msg),
//         onPressed: f,
//       ),
//     );
//   }

//   Widget status() {
//     String msg = _status.toString().split('.').last;
//     return Text("Status: $msg");
//   }

//   Widget lastLoc() {
//     return Text(
//         lastLocation != null
//             ? dtoToString(lastLocation)
//             : 'Unknown last location',
//         textAlign: TextAlign.center);
//   }

//   Widget getButton() {
//     return RaisedButton(
//       child: Text("Get Current Location"),
//       onPressed: () async {
//         // await onGetCurrentLocation();
//         LocationManager.instance.getCurrentLocation().then((value) {
//           print(value);
//           print(value.latitude);
//           print(value.longitude);
//         });
//       },
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('CARP Background Location'),
//         ),
//         body: Container(
//           width: double.maxFinite,
//           padding: const EdgeInsets.all(22),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 startButton(),
//                 stopButton(),
//                 Divider(),
//                 status(),
//                 Divider(),
//                 dtoWidget(lastLocation),
//                 getButton()
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
