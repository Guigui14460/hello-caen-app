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
          body: SingleChildScrollView(
              child:Column(
                children: [
                  SizedBox(height:50,width:500,child:
                    ListView(
                      children: [
                        Container(width: 100,height: 50,color:Colors.white),
                        Container(width: 100,height: 50,color:Colors.black),
                        Container(width: 100,height: 50,color:Colors.white),
                        Container(width: 100,height: 50,color:Colors.black),
                        Container(width: 100,height: 50,color:Colors.white),
                      ],
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.99,
                    height: MediaQuery.of(context).size.width * 0.8,
                    color: Colors.amber,
                    child: Container(
                      child :Column(
                          children: [

                            SizedBox(height: 10),
                            Row( children: [
                              Container(
                                  width: MediaQuery.of(context).size.width * 0.40,
                                  height: MediaQuery.of(context).size.width * 0.15,
                                  color: Colors.red,),]),
                            SizedBox(height: 10),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child:Row(
                                  children: [
                                    GestureDetector(onTap: () {
                                      print('click');
                                        },
                                      child:
                                      Container(

                                        width: MediaQuery.of(context).size.width * 0.55,
                                        height: MediaQuery.of(context).size.width * 0.55,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage('https://media-cdn.tripadvisor.com/media/photo-s/11/9e/75/70/sala-a-restaurant.jpg'),
                                                fit: BoxFit.cover,
                                                ),
                                            borderRadius: BorderRadius.all(Radius.circular(15))



                                        ),
                                        child: GridView.count(
                                          crossAxisCount: 2,
                                          children: [Container(
                                            //color:Colors.lightGreen,
                                            width:100,
                                            height: 100,),
                                            Container(
                                            //color:Colors.lightGreen,
                                            width:100,
                                            height: 100,),
                                            Opacity(child:Container(
                                              color:Colors.black,
                                              width:120,
                                              height: 100,),
                                              opacity: 0.6,
                                            ),
                                            Opacity(child:Container(
                                              color:Colors.black,
                                              width:120,
                                              height: 100,),
                                              opacity: 0.6,
                                            ),

                                              ],
                                        ),
                                      ),
                                    ),
                                        SizedBox(width: 10),
                                        Container(
                                            width: MediaQuery.of(context).size.width * 0.55,
                                            height: MediaQuery.of(context).size.width * 0.55, color: Colors.red),
                                        SizedBox(width: 10),
                                    Container(
                                        width: MediaQuery.of(context).size.width * 0.55,
                                        height: MediaQuery.of(context).size.width * 0.55,
                                        color: Colors.red), ]),),
                        ],
                      )
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.99,
                    height: MediaQuery.of(context).size.width * 0.8,
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
                    color: Colors.lightGreen,
                    padding: EdgeInsets.all(16.0),
                    child: Container(
                      color: Colors.red,
                      width: MediaQuery.of(context).size.width * 0.99 / 3,
                      height: MediaQuery.of(context).size.width * 0.6 / 3,),)
              ]
            ),
          )
        )
      );

  }
}
