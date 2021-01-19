import 'package:flutter/material.dart';

import '../../home/home_screen.dart';
import '../../../components/app_bar.dart';

class StoresBody extends StatefulWidget {
  StoresBody({Key key}) : super(key: key);

  _StoresBodyState createState() => _StoresBodyState();
}

class _StoresBodyState extends State<StoresBody> {
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: MyAppBar(),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Container(
                    width: MediaQuery.of(context).size.width * 0.98,
                    height: MediaQuery.of(context).size.width * 0.4,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                'https://media-cdn.tripadvisor.com/media/photo-s/11/9e/75/70/sala-a-restaurant.jpg'),
                            fit: BoxFit.cover)),
                    child: GridView.count(
                      primary: false,
                      crossAxisCount: 2,
                      childAspectRatio:
                          MediaQuery.of(context).size.height / 333,
                      children: [
                        Container(
                          child: Text(" Nom Du resto"),
                          padding: EdgeInsets.all(10),
                        ),
                        Container(
                          child: Text(" Horraires"),
                          padding: EdgeInsets.all(10),
                        ),
                        Container(
                          child: Text(" Description : "),
                          padding: EdgeInsets.all(10),
                        ),
                        Container(
                            child: Opacity(
                          opacity: 0.5,
                          child: FlatButton(
                            color: Colors.black,
                            child: Text(" Detail"),
                            onPressed: () {},
                          ),
                        )),
                      ],
                    )),
                SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width * 0.98,
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              'https://www.lyoncapitale.fr/wp-content/uploads/2020/10/Lyon_Capitale_Restaurant_Le_Garet_-21.jpg.webp'),
                          fit: BoxFit.cover)),
                  child: Column(
                    children: <Widget>[
                      Row(children: <Widget>[
                        Card(
                            child: FlatButton(
                                child: Text("Detail"),
                                onPressed: () {
                                  print("oof");
                                })),
                      ]),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width * 0.98,
                  //height: MediaQuery.of(context).size.height * 0.2,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              'https://blog-assets.lightspeedhq.com/img/2020/01/1e5ac4db-restaurant-soft-openings.jpg'),
                          fit: BoxFit.cover)),
                  child: Column(
                    children: <Widget>[
                      Opacity(
                          opacity: 0.4,
                          child: Container(
                            color: Colors.black,
                            width: MediaQuery.of(context).size.width * 0.98,
                            height: MediaQuery.of(context).size.height * 0.2,
                            child: Row(children: <Widget>[
                              Opacity(
                                  opacity: 1,
                                  child: Card(
                                      child: FlatButton(
                                          child: Text("Detail"),
                                          onPressed: () {
                                            print("oof");
                                          }))),
                            ]),
                          ))
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width * 0.98,
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              'https://blog-assets.lightspeedhq.com/img/2020/01/1e5ac4db-restaurant-soft-openings.jpg'),
                          fit: BoxFit.cover)),
                  child: Column(
                    children: <Widget>[
                      Row(children: <Widget>[
                        Card(
                            child: FlatButton(
                                child: Text("Detail"),
                                onPressed: () {
                                  print("oof");
                                })),
                      ]),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width * 0.98,
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              'https://blog-assets.lightspeedhq.com/img/2020/01/1e5ac4db-restaurant-soft-openings.jpg'),
                          fit: BoxFit.cover)),
                  child: Column(
                    children: <Widget>[
                      Row(children: <Widget>[
                        Card(
                            child: FlatButton(
                                child: Text("Detail"),
                                onPressed: () {
                                  print("oof");
                                })),
                      ]),
                    ],
                  ),
                ),
                Container(
                    child: FlatButton(
                        onPressed: () => Navigator.popAndPushNamed(
                            context, HomeScreen.routeName),
                        child: Text("Fuck ,Go Back"))),
              ],
            ),
          )),
    );
  }
}
