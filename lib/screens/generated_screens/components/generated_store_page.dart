import 'package:flutter/material.dart';
import 'package:hello_caen/components/app_bar.dart';
import 'package:hello_caen/model/database/commerce_model.dart';
import 'package:hello_caen/screens/stores/components/store_list.dart';
import 'package:hello_caen/screens/home/home_screen.dart';
import 'package:hello_caen/screens/stores/stores_screen.dart';
import 'package:hello_caen/services/size_config.dart';


class GeneratedStorePage extends StatefulWidget {

  //final CommerceModel commerce;


  const GeneratedStorePage({Key key}) : super(key: key);

  @override
  _GeneratedStorePageState createState() => _GeneratedStorePageState();
}

/// [State] of the [HomeBody].
class _GeneratedStorePageState extends State<GeneratedStorePage> {

  Widget build(BuildContext context) {
    return SafeArea(
        child:Scaffold( appBar: MyAppBar(),
                  body: GestureDetector(
                      onTap: (){Navigator.popAndPushNamed(context, HomeScreen.routeName); },
                      child:Container(width:100,
                        height:100 ,
                        color: Colors.amber,
                        child: Text("Oof"),)
        )
      )
    );
  }
}