import 'package:flutter/material.dart';

import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../../home/home_screen.dart';
import 'splash_content.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<Map<String, dynamic>> splashData = [
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

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final DefaultButton button = DefaultButton(
      height: 50,
      fontSize: 20,
      text: 'Continuer',
      press: () {
        Navigator.popAndPushNamed(context, HomeScreen.routeName);
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
                      color: primaryColor,
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
                    currentPage = value;
                  });
                },
                itemCount: splashData.length,
                itemBuilder: (context, index) => SplashContent(
                  text: splashData[index]["text"],
                  image: splashData[index]["image"],
                  imageWidth: splashData[index]["imageSize"],
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
                        splashData.length,
                        (index) => buildDot(index: index),
                      ),
                    ),
                    Spacer(flex: 2),
                    (currentPage == splashData.length - 1
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

  AnimatedContainer buildDot({@required int index}) {
    return AnimatedContainer(
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: (currentPage == index ? 20 : 6),
      decoration: BoxDecoration(
        color: currentPage == index ? ternaryColor : Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
      duration: animationDuration,
    );
  }
}
