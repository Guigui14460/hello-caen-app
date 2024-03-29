import 'package:flutter/material.dart';

import 'explanations_content.dart';
import '../../home/home_screen.dart';
import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../services/size_config.dart';

/// Class to display all widgets of the [ExplanationsScreen] class.
class ExplanationsBody extends StatefulWidget {
  @override
  _ExplanationsBodyState createState() => _ExplanationsBodyState();
}

/// State of the [ExplanationsBody] class.
class _ExplanationsBodyState extends State<ExplanationsBody> {
  /// Data to display on the screen.
  List<Map<String, dynamic>> explanationsData = [
    {
      "text": "Bienvenue sur l\'application Hello CAEN.\nMarchez dans CAEN ...",
      "image": "assets/images/walk.svg",
      "imageSize": getProportionateScreenWidth(350),
    },
    {
      "text": "... activez les données mobiles\net la localisation ...",
      "image": "assets/images/activations.png",
      "imageSize": getProportionateScreenWidth(350),
    },
    {
      "text": "... et découvrez de nouveaux lieux\ntout en vous déplaçant !",
      "image": "assets/images/map2.svg",
      "imageSize": getProportionateScreenWidth(350),
    },
  ];

  /// Represents the current displayed explanations content.
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final DefaultButton button = DefaultButton(
      height: 50,
      fontSize: 20,
      text: 'Continuer',
      press: () {
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      },
      longPress: () {},
    );

    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Text(
                    "Hello CAEN",
                    style: TextStyle(
                      shadows: [
                        Shadow(color: Colors.blue[400], offset: Offset(3, 3)),
                        Shadow(
                            color: Colors.red[500], offset: Offset(1.5, 1.5)),
                      ],
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: getProportionateScreenHeight(42),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              flex: 2,
              child: PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    _currentPage = value;
                  });
                },
                itemCount: explanationsData.length,
                itemBuilder: (context, index) => ExplanationsContent(
                  text: explanationsData[index]["text"],
                  imageUrl: explanationsData[index]["image"],
                  imageWidth: explanationsData[index]["imageSize"],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(24),
                ),
                child: Column(
                  children: [
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        explanationsData.length,
                        (index) => buildDot(index: index),
                      ),
                    ),
                    Spacer(flex: 2),
                    (_currentPage == explanationsData.length - 1
                        ? button
                        : Visibility(
                            child: button,
                            maintainSize: true,
                            maintainAnimation: true,
                            maintainState: true,
                            visible: false,
                          )),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a dot which represents the different explanations contents.
  AnimatedContainer buildDot({@required int index}) {
    return AnimatedContainer(
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: (_currentPage == index ? 20 : 6),
      decoration: BoxDecoration(
        color: _currentPage == index ? ternaryColor : Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
      duration: animationDuration,
    );
  }
}
