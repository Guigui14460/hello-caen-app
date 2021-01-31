import 'package:flutter/material.dart';
import 'package:hello_caen/components/app_bar.dart';
import 'package:hello_caen/model/commerce.dart';
import 'package:hello_caen/model/database/commerce_model.dart';
import 'package:hello_caen/screens/stores/components/store_list.dart';
import 'package:hello_caen/screens/home/home_screen.dart';
import 'package:hello_caen/screens/stores/stores_screen.dart';
import 'package:hello_caen/services/size_config.dart';

class GeneratedStorePage extends StatefulWidget {
  //final CommerceModel commerce;

  final Commerce data;

  const GeneratedStorePage({Key key, @required this.data}) : super(key: key);
  @override
  _GeneratedStorePageState createState() => _GeneratedStorePageState();
}

/// [State] of the [HomeBody].
class _GeneratedStorePageState extends State<GeneratedStorePage> {
  Widget build(BuildContext context) {
    print(widget.data);
    return SafeArea(
        child: Scaffold(
            appBar: MyAppBar(),
            body: SingleChildScrollView(
                child: Column(
              children: [
                Container(
                  width: getProportionateScreenWidth(1000),
                  height: getProportionateScreenHeight(130),
                  margin: EdgeInsets.only(top: 10, left: 20),
                  child: Column(children: [
                    Container(
                        child: Row(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          Text(widget.data.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 40))
                        ])),
                    Container(
                        margin: EdgeInsets.only(top: 10, left: 20),
                        child: Row(

                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("4 étoiles ",
                                  style: TextStyle(fontWeight: FontWeight.bold))
                            ])),
                  ]),
                ),
                Container(
                  width: getProportionateScreenWidth(330),
                  height: getProportionateScreenHeight(200),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.data.imageLink),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                ),
                Container(
                    width: getProportionateScreenWidth(1000),
                    height: getProportionateScreenHeight(200),
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: getProportionateScreenWidth(150),
                          height: getProportionateScreenHeight(200),
                          //color : Colors.amber,
                          child: Text(widget.data.description),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: getProportionateScreenWidth(150),
                          height: getProportionateScreenHeight(200),
                          color: Colors.amber,
                          child: Text(widget.data.timetables),
                        )
                      ],
                    )),
                Container(
                  width: getProportionateScreenWidth(1000),
                  height: getProportionateScreenHeight(130),
                  margin: EdgeInsets.only(top: 10),
                  //mainAxisAlignment: MainAxisAlignment.center,
                  child: Column(
                    children: [
                      Text("Commentaires",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30)),
                      // ListView.builder(
                      //    scrollDirection: Axis.horizontal,
                      //    itemCount: widget.data.comments.length,
                      //   itemBuilder:(context, index)
                      //   {
                      //     return Container(
                      //         width: getProportionateScreenWidth(1000),
                      //         height: getProportionateScreenHeight(100),
                      //         child:Text(widget.data.comments[index].text));
                      //     })
                    ],
                  ),
                )
              ],
            ))));
  }
}
