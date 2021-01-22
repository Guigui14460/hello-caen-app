import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../stores/stores_screen.dart';
import '../../../components/app_bar.dart';
import '../../../components/default_button.dart';
import '../../../services/data_cache.dart';
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
          body: Scaffold(
            appBar : MyAppBar(),
            body :SingleChildScrollView(
              child:Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.99,
                    height: MediaQuery.of(context).size.width * 0.6,
                    color: Colors.amber,
                    child: Container(
                      child :Column(
                          children: [
                            SizedBox(height: 10),
                            Row( children: [Container(width: MediaQuery.of(context).size.width * 0.40,height: MediaQuery.of(context).size.width * 0.15, color: Colors.red), ]   ),
                            SizedBox(height: 10),
                            SingleChildScrollView( scrollDirection: Axis.horizontal,child:Row( children: [Container(width: MediaQuery.of(context).size.width * 0.45,height: MediaQuery.of(context).size.width * 0.35, color: Colors.red),SizedBox(width: 10),Container(width: MediaQuery.of(context).size.width * 0.45,height: MediaQuery.of(context).size.width * 0.35, color: Colors.red),SizedBox(width: 10),Container(width: MediaQuery.of(context).size.width * 0.45,height: MediaQuery.of(context).size.width * 0.35, color: Colors.red), ]),),
                        ],
                      )
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.99,
                    height: MediaQuery.of(context).size.width * 0.6,
                    color: Colors.amber,
                    child: Container(
                        child :Column(
                          children: [
                            SizedBox(height: 10),
                            Row( children: [Container(width: MediaQuery.of(context).size.width * 0.40,height: MediaQuery.of(context).size.width * 0.15, color: Colors.red), ]   ),
                            SizedBox(height: 10),
                            SingleChildScrollView( scrollDirection: Axis.horizontal,child:Row( children: [Container(width: MediaQuery.of(context).size.width * 0.45,height: MediaQuery.of(context).size.width * 0.35, color: Colors.red),SizedBox(width: 10),Container(width: MediaQuery.of(context).size.width * 0.45,height: MediaQuery.of(context).size.width * 0.35, color: Colors.red),SizedBox(width: 10),Container(width: MediaQuery.of(context).size.width * 0.45,height: MediaQuery.of(context).size.width * 0.35, color: Colors.red), ]),),
                          ],
                        )
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.99,
                    height: MediaQuery.of(context).size.width * 0.6,
                    color: Colors.amber,
                    child: Container(
                        child :Column(
                          children: [
                            SizedBox(height: 10),
                            Row( children: [Container(width: MediaQuery.of(context).size.width * 0.40,height: MediaQuery.of(context).size.width * 0.15, color: Colors.red), ]   ),
                            SizedBox(height: 10),
                            SingleChildScrollView( scrollDirection: Axis.horizontal,child:Row( children: [Container(width: MediaQuery.of(context).size.width * 0.45,height: MediaQuery.of(context).size.width * 0.35, color: Colors.red),SizedBox(width: 10),Container(width: MediaQuery.of(context).size.width * 0.45,height: MediaQuery.of(context).size.width * 0.35, color: Colors.red),SizedBox(width: 10),Container(width: MediaQuery.of(context).size.width * 0.45,height: MediaQuery.of(context).size.width * 0.35, color: Colors.red), ]),),
                          ],
                        )
                    ),
                  )
              ]
            ),
          )
        )
      )
      );

  }
}
