import 'package:flutter/material.dart';

import 'update_commerce_screen.dart';
import '../../components/app_bar.dart';
import '../../components/custom_dialog.dart';
import '../../model/commerce.dart';
import '../../model/database/commerce_model.dart';
import '../../services/firebase_settings.dart';
import '../../services/size_config.dart';

class ProHomeScreen extends StatefulWidget {
  static String routeName = "/pro/home";
  const ProHomeScreen({Key key}) : super(key: key);

  @override
  _ProHomeScreenState createState() => _ProHomeScreenState();
}

class _ProHomeScreenState extends State<ProHomeScreen> {
  List<Commerce> commerces = [];

  @override
  void initState() {
    super.initState();
    CommerceModel()
        .whereLinked("owner",
            isEqualTo: FirebaseSettings.instance.getAuth().currentUser.uid)
        .orderByLinked("name")
        .executeCurrentLinkedQueryRequest()
        .then((value) {
      setState(() {
        commerces = value;
      });
    });
  }

  void addCommerce(Commerce commerce) {
    setState(() {
      commerces.add(commerce);
    });
  }

  void removeCommerce(Commerce commerce) {
    setState(() {
      commerces.remove(commerce);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          actions: [Icon(Icons.add), Icon(Icons.info_outline)],
          actionsCallback: [_addCommerce, () => _infoDialog(context)],
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
                    "Vos commerces",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: getProportionateScreenWidth(30)),
                  ),
                  SizedBox(height: getProportionateScreenHeight(30)),
                  Column(
                    children: commerces.map((e) {
                      return Row(
                        children: [
                          Text(e.name),
                          Spacer(),
                          IconButton(
                            color: Colors.blueAccent[400],
                            icon: Icon(Icons.mode_edit),
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        UpdateCommerceScreen(e, false))),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () => _deleteCommerce(context, e),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _addCommerce() {}

  void _deleteCommerce(BuildContext context, Commerce commerce) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogBox(
            title: "Supprimer",
            description:
                "Toutes les données associées à ce commerce seront définitivement supprimées (commentaires, sous-commentaires, notes). Êtes-vous sûr de vouloir supprimer le commerce \"${commerce.name}\" ?",
            text: "Confirmer",
            onPressed: () async {
              await CommerceModel().delete(commerce.id);
              removeCommerce(commerce);
              Navigator.pop(context);
            },
          );
        });
  }

  _infoDialog(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogBox(
            title: "Information",
            description:
                "Seul vous et les administrateurs ont accès à ces informations.",
            text: "OK",
            onPressed: () {
              Navigator.pop(context);
            },
          );
        });
  }
}
