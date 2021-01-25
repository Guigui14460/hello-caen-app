import 'package:flutter/material.dart';
import  "package:hello_caen/model/database/commerce_model.dart";
class StoreListPage extends StatelessWidget {
  const StoreListPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    return SafeArea(child: FutureBuilder(
        future :  CommerceModel().getAll(),
        builder: (context,snapshot){
          if (snapshot.connectionState == ConnectionState.done) {
            if(snapshot.hasData) {
              print("--------------------------------------------------------------");
              print(snapshot.data);
              print("--------------------------------------------------------------");
              for (var data in snapshot.data) {
                widgets.add(Text(data.id));
              }
              widgets.add(Text("sweet sweet sanity"));
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
