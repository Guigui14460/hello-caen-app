import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../services/theme_manager.dart';

class QRCodeGenerator extends StatelessWidget {
  final String data;

  const QRCodeGenerator({Key key, @required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDarkModeEnabled =
        Provider.of<ThemeManager>(context, listen: false).isDarkMode();
    return QrImage(
      data: data,
      errorCorrectionLevel: QrErrorCorrectLevel.H,
      embeddedImage: AssetImage("assets/images/logo.png"),
      gapless: true,
      backgroundColor: Theme.of(context).backgroundColor,
      foregroundColor: isDarkModeEnabled ? Colors.white : Colors.black,
    );
  }
}
