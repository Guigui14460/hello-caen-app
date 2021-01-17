


import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hello_caen/screens/home/home_screen.dart';
import 'package:hello_caen/screens/splash/splash_screen.dart';
import 'package:flutter/src/painting/image_provider.dart';

import '../../sign_in/sign_in_screen.dart';




class StoresBody extends StatefulWidget {
  StoresBody({Key key}) : super(key: key);

  _StoresBodyState createState() => _StoresBodyState();
}

class _StoresBodyState extends State<StoresBody> {
  Widget build(BuildContext context) {
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
            ),
            IconButton(
              icon: Icon(Icons.add),
              color: Colors.red,
              onPressed: () {
                Navigator.pushNamed(context, SignInScreen.routeName);
              },
            )
          ],
        ),
        body: SingleChildScrollView(


       child: Column(

          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            SizedBox(height: 10),
            Container(
                width:MediaQuery.of(context).size.width*0.98,
                height:MediaQuery.of(context).size.height*0.2,
                decoration: BoxDecoration(image:DecorationImage(image: NetworkImage('https://media-cdn.tripadvisor.com/media/photo-s/11/9e/75/70/sala-a-restaurant.jpg'), fit: BoxFit.cover)),
                child:Column(
                    children: <Widget>[
                        Row(children : <Widget> [
                          Card(child: FlatButton(child : Text("Detail"),onPressed: () {print("oof");})),

                        ]),
                    ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              width:MediaQuery.of(context).size.width*0.98,
              height:MediaQuery.of(context).size.height*0.2,
              decoration: BoxDecoration(image:DecorationImage(image: NetworkImage('https://www.lyoncapitale.fr/wp-content/uploads/2020/10/Lyon_Capitale_Restaurant_Le_Garet_-21.jpg.webp'), fit: BoxFit.cover)),
              child:Column(
                children: <Widget>[
                  Row(children : <Widget> [
                    Card(child: FlatButton(child : Text("Detail"),onPressed: () {print("oof");})),

                  ]),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              width:MediaQuery.of(context).size.width*0.98,
              height:MediaQuery.of(context).size.height*0.2,
              decoration: BoxDecoration(image:DecorationImage(image: NetworkImage('https://blog-assets.lightspeedhq.com/img/2020/01/1e5ac4db-restaurant-soft-openings.jpg'), fit: BoxFit.cover)),
              child:Column(
                children: <Widget>[
                  Row(children : <Widget> [
                    Card(child: FlatButton(child : Text("Detail"),onPressed: () {print("oof");})),

                  ]),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              width:MediaQuery.of(context).size.width*0.98,
              height:MediaQuery.of(context).size.height*0.2,
              decoration: BoxDecoration(image:DecorationImage(image: NetworkImage('https://blog-assets.lightspeedhq.com/img/2020/01/1e5ac4db-restaurant-soft-openings.jpg'), fit: BoxFit.cover)),
              child:Column(
                children: <Widget>[
                  Row(children : <Widget> [
                    Card(child: FlatButton(child : Text("Detail"),onPressed: () {print("oof");})),

                  ]),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              width:MediaQuery.of(context).size.width*0.98,
              height:MediaQuery.of(context).size.height*0.2,
              decoration: BoxDecoration(image:DecorationImage(image: NetworkImage('https://blog-assets.lightspeedhq.com/img/2020/01/1e5ac4db-restaurant-soft-openings.jpg'), fit: BoxFit.cover)),
              child:Column(
                children: <Widget>[
                  Row(children : <Widget> [
                    Card(child: FlatButton(child : Text("Detail"),onPressed: () {print("oof");})),

                  ]),
                ],
              ),
            ),

            Container(
                child :FlatButton(

                    onPressed: () => {
                      Navigator.popAndPushNamed(context,HomeScreen.routeName)
                    },
                    child: Text("Fuck Go Back"))

            ),

          ]
          ,
        ),)



      ),
    );

  }
}