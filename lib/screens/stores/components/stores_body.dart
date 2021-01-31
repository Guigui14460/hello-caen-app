import 'package:flutter/material.dart';
import 'package:hello_caen/screens/stores/components/store_list.dart';

class StoresBody extends StatefulWidget {
  StoresBody({Key key}) : super(key: key);

  _StoresBodyState createState() => _StoresBodyState();
}

class _StoresBodyState extends State<StoresBody> {
  Widget build(BuildContext context) {
    return StoreListPage();
  }
}
