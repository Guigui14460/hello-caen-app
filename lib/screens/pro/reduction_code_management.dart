import 'package:flutter/material.dart';
import 'package:hello_caen/services/theme_manager.dart';
import 'package:provider/provider.dart';

import '../../components/app_bar.dart';
import '../../constants.dart';
import '../../model/commerce.dart';
import '../../model/database/reduction_code_model.dart';
import '../../model/reduction_code.dart';
import '../../services/size_config.dart';

class ReductionManagementScreen extends StatefulWidget {
  final Commerce commerce;

  ReductionManagementScreen({Key key, this.commerce}) {
    assert(this.commerce != null);
  }

  @override
  _ReductionManagementScreenState createState() =>
      _ReductionManagementScreenState();
}

class _ReductionManagementScreenState extends State<ReductionManagementScreen> {
  List<ReductionCode> _codes = [];

  @override
  void initState() {
    super.initState();
    ReductionCodeModel()
        .where("commerce", isEqualTo: widget.commerce.id)
        .then((value) {
      setState(() {
        _codes = value;
      });
    });
  }

  void addCode(ReductionCode code) async {
    await ReductionCodeModel().create(code);
    ReductionCodeModel()
        .where("commerce", isEqualTo: widget.commerce.id)
        .then((value) {
      setState(() {
        _codes = value;
      });
    });
  }

  void updateCode(ReductionCode code) async {
    await ReductionCodeModel().update(code.id, code);
  }

  void deleteCode(ReductionCode code) async {
    await ReductionCodeModel().delete(code.id);
    _codes.remove(code);
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    return SafeArea(
      child: Scaffold(
        appBar:
            MyAppBar(actions: [Icon(Icons.add)], actionsCallback: [_addCode]),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(20),
              vertical: getProportionateScreenHeight(10),
            ),
            child: Column(
              children: [
                Text(
                  "Bon plans associés au commerce \"${widget.commerce.name}\"",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: getProportionateScreenWidth(30)),
                ),
                SizedBox(height: getProportionateScreenHeight(30)),
                Column(
                  children: _codes.map<Widget>((e) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: () => {},
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: getProportionateScreenWidth(10)),
                                child: Row(
                                  children: [
                                    Text(e.name +
                                        (e.endDate != null &&
                                                e.endDate.compareTo(now) < 0
                                            ? " (terminé)"
                                            : (e.beginDate.compareTo(now) > 0
                                                ? ""
                                                : " (commencé)"))),
                                    Spacer(),
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      color: Colors.blue[400],
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete_forever),
                                      color: Colors.red,
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: getProportionateScreenHeight(30)),
                          ],
                        );
                      }).toList() +
                      [SizedBox(height: getProportionateScreenHeight(80))],
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print("QR code scanner");
          },
          child: Icon(Icons.qr_code_scanner),
          backgroundColor: Provider.of<ThemeManager>(context).isDarkMode()
              ? ternaryColor
              : primaryColor,
        ),
      ),
    );
  }

  void _addCode() {}
}
