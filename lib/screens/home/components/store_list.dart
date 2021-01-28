import 'package:flutter/material.dart';
import 'package:hello_caen/components/caller_row.dart';

import '../../../components/category_menu.dart';
import "../../../model/database/commerce_model.dart";

class StoreListPage extends StatelessWidget {
  const StoreListPage({Key key}) : super(key: key);
  static dosmth(param) {
    print(param);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    return SafeArea(
        child: Column(children:[CategoryMenu(text: [
      "B1",
      "B2",
      "B3",
      "B4"
    ], onPressed: [
      () => dosmth("click 1"),
      () => dosmth("click 2"),
      () => dosmth("3"),
      () => dosmth("3")
    ]),
          CallerRow(),
          CallerRow()]

      )
    );


    return SafeArea(
        child: FutureBuilder(
            future: CommerceModel().getAll(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  print(
                      "--------------------------------------------------------------");
                  print(snapshot.data);
                  print(
                      "--------------------------------------------------------------");
                  for (var data in snapshot.data) {
                    widgets.add(Text(data.name));
                  }
                  return ListView.builder(
                      itemCount: widgets.length,
                      itemBuilder: (context, index) {
                        return widgets[index];
                      });
                }

                if (snapshot.hasError) {
                  return Text("Snapshot Has error");
                } else {
                  return Text("No Commerce Found");
                }
              } else {
                return CircularProgressIndicator();
              }
            }));
  }
}
