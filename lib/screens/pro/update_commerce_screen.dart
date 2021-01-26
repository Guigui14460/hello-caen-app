import 'package:flutter/material.dart';

import '../../components/app_bar.dart';
import '../../model/commerce.dart';
import '../../services/size_config.dart';

class UpdateCommerceScreen extends StatefulWidget {
  static String routeName = "/pro/commerce/update";

  UpdateCommerceScreen(this.commerce, this.modify);

  final Commerce commerce;
  final bool modify;

  @override
  _UpdateCommerceScreenState createState() => _UpdateCommerceScreenState();
}

class _UpdateCommerceScreenState extends State<UpdateCommerceScreen> {
  Commerce futureCommerce;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          actions: [Icon(Icons.remove_red_eye)],
          actionsCallback: [() => _previewCommerce(futureCommerce)],
        ),
        body: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20),
                vertical: getProportionateScreenHeight(10)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "Mise à jour du commerce \"${widget.commerce.name}\"",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: getProportionateScreenWidth(30)),
                  ),
                  Text(widget.commerce.id),
                  Text(widget.modify ? "oui" : "non"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _previewCommerce(Commerce futureCommerce) {
    print("preview");
  }
}
