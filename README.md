# Appli Hello Caen

## Flutter

### Installation de Flutter

https://flutter.dev/docs/get-started/install

### Documentation de Flutter et du langage Dart

https://flutter.dev/docs

https://api.dart.dev/stable/2.10.4/index.html

### Testage de l'application

https://flutter.dev/docs/cookbook/testing

### Déploiement de l'application

https://flutter.dev/docs/deployment/android

https://flutter.dev/docs/deployment/ios

## Tutoriels à regarder et expérimenter

https://www.youtube.com/playlist?list=PL4cUxeGkcC9jLYyp2Aoh6hcWuxFDX6PBJ

https://www.youtube.com/playlist?list=PL4cUxeGkcC9itfjle0ji1xOZ2cjRGY_WB

https://www.youtube.com/playlist?list=PL4cUxeGkcC9jUPIes_B8vRjn1_GaplOPQ

https://www.youtube.com/playlist?list=PL4cUxeGkcC9j--TKIdkb3ISfRbJeJYQwC

## Contenu de l'application

### Documenter le code de l'application

Lancer la commande suivante pour installer :

```bash
$ flutter pub global activate dartdoc
```

Puis celle-ci pour regénérer la documentation :

```bash
$ dartdoc
```

https://dart.dev/guides/language/effective-dart/documentation

### Liste des packages à utiliser

Google Maps (carte intéractive + API) : https://pub.dev/packages/google_maps_flutter

Géolocalisation : https://pub.dev/packages/geolocation ou https://pub.dev/packages/geolocator ou https://pub.dev/packages/flutter_background_geolocation (dernier à tester en priorité)

Localisation (**utilisé**) : https://pub.dev/packages/location

Base de données (Firebase) : https://pub.dev/packages/firebase_core
Envoie de notification à tous les utilisateurs via Firebase : https://pub.dev/packages/firebase_messaging

Sauvegarde des préférences sur appareil : https://pub.dev/packages/shared_preferences

Envoie de notifications locales : https://pub.dev/packages/flutter_local_notifications

Si besoin, un package pour rendre des widgets plus réutilisable : https://pub.dev/packages/provider

Scanner de code barre : https://pub.dev/packages/flutter_barcode_scanner/example

Générateur de code barre : https://pub.dev/packages/barcode/example

### Tutoriels pour avoir des idées sur le visuel

https://www.youtube.com/c/TheFlutterWay/videos

https://www.youtube.com/c/MarcusNg/videos

https://www.youtube.com/playlist?list=PLxUBb2A_UUy8OlaNZpS2mfL8xpHcnd_Af

https://mightytechno.com/create-hyperlink-for-text-in-flutter/

https://mightytechno.com/flutter-app-bar/

https://mightytechno.com/dark-light-theme-flutter-app/

Certains widgets qu'on pourrait utiliser (rappel : Material vient d'Android et Cupertino d'iOS mais chacun utilisable sur les 2 plateformes mobiles) : https://gallery.flutter.dev/#/

Mode sombre : https://www.youtube.com/watch?v=MnTEHs-ZP0E

Sidebar : https://www.youtube.com/watch?v=n2wtljWWnpU

Animation d'un collapse : https://stackoverflow.com/questions/49029841/how-to-animate-collapse-elements-in-flutter

Graphique pour les statistiques (pro et admin) : https://medium.com/flutter/beautiful-animated-charts-for-flutter-164940780b8c

Video Player : https://www.youtube.com/watch?v=XP-4BiWsuaQ

### Tutoriels pour avoir des idées pour le backend

https://www.youtube.com/watch?v=wV9bd56ypmQ

https://medium.com/comerge/implementing-push-notifications-in-flutter-apps-aef98451e8f1

https://carmine.dev/posts/flutternotifications/

https://stackoverflow.com/questions/62255486/flutter-how-to-keep-the-app-running-on-background

https://stackoverflow.com/questions/53450029/flutter-cross-platform-way-to-keep-application-running-in-the-backgroundexecuting-dart-in-the-background-with-flutter-plugins-and-geofencing-2b3e40a1a124

https://github.com/bkonyi/FlutterGeofencing

https://flutter.dev/docs/cookbook/networking/fetch-data

https://www.youtube.com/playlist?list=PL342JVRNQxEAcQdnNeN0JmMzfcm6VtLxS

Local storage : https://www.youtube.com/watch?v=auspHSmtVII, https://www.raywenderlich.com/7426050-firebase-tutorial-for-flutter-getting-started

Fetch data in the background : https://pub.dev/packages/background_fetch, https://medium.com/vrt-digital-studio/flutter-workmanager-81e0cfbd6f6e

Ajout de tâches répétitives en arrière-plan : https://github.com/fluttercommunity/flutter_workmanager

QR Code : https://medium.com/flutter-community/building-flutter-qr-code-generator-scanner-and-sharing-app-703e73b228d3

Video player : https://www.youtube.com/watch?v=7IG5kRFIMZw

Geolocalisation : https://medium.com/swlh/working-with-geolocation-and-geocoding-in-flutter-and-integration-with-maps-16fb0bc35ede et https://medium.com/flutter-community/exploring-google-maps-in-flutter-8a86d3783d24 et https://gist.github.com/deven98/9925ed6bf2cba0aa6d13d307075c59cb

#### Google Maps

https://github.com/marchdev-tk/flutter_google_maps

https://medium.com/flutter/google-maps-and-flutter-cfb330f9a245

https://blog.codemagic.io/creating-a-route-calculator-using-google-maps/
