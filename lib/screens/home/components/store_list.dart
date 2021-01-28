import 'package:flutter/material.dart';
import 'package:hello_caen/components/category_menu.dart';
import  "package:hello_caen/model/database/commerce_model.dart";
import 'package:hello_caen/screens/location/location_screen.dart';
class StoreListPage extends StatelessWidget {
  const StoreListPage({Key key}) : super(key: key);
  static dosmth(param){print(param);}
  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    return SafeArea(child:
        SingleChildScrollView(child:
          Column(children : [
          SingleChildScrollView(child:CategoryMenu(text: ["B1","B2","B3","B4"],onPressed :[ dosmth("click 1"),dosmth("click 2"),dosmth("3"),dosmth("4") ])),


              ]
            )
          ,)
        );

    return SafeArea(child: FutureBuilder(
        future :  CommerceModel().getAll(),
        builder: (context,snapshot){
          if (snapshot.connectionState == ConnectionState.done) {
            if(snapshot.hasData) {
              print("--------------------------------------------------------------");
              print(snapshot.data);
              print("--------------------------------------------------------------");
              for (var data in snapshot.data) {
                widgets.add(Text(data.name));
              }
              return ListView.builder(
                  itemCount: widgets.length,
                  itemBuilder: (context, index) {
                    return widgets[index];
                  }
              );
            }

            if(snapshot.hasError){
              return Text("Snapshot Has error");}
            else{
              return Text("No Commerce Found");}
          }
          else{return CircularProgressIndicator();}
        }

    )
    );
  }
}
