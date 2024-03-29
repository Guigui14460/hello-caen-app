import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helper/read_qr_code.dart';
import '../reduction_codes/reduction_code_management.dart';
import '../stores/update_commerce_screen.dart';
import '../../../constants.dart';
import '../../../components/app_bar.dart';
import '../../../components/custom_dialog.dart';
import '../../../model/commerce.dart';
import '../../../model/database/commerce_model.dart';
import '../../../model/database/user_model.dart';
import '../../../services/firebase_settings.dart';
import '../../../services/size_config.dart';
import '../../../services/theme_manager.dart';

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
            isEqualTo: UserModel().getDocumentReference(
                FirebaseSettings.instance.getAuth().currentUser.uid))
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

  void updateCommerce(Commerce commerce) {
    int where = commerces.indexWhere((element) => element.id == commerce.id);
    setState(() {
      commerces[where] = commerce;
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
          actions: [Icon(Icons.add)],
          actionsCallback: [_addCommerce],
        ),
        body: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20),
                vertical: getProportionateScreenHeight(10),
              ),
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
                    children: commerces.map<Widget>((e) {
                          return GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => UpdateCommerceScreen(
                                        commerce: e,
                                        modifyCallback: updateCommerce))),
                            child: Column(
                              children: [
                                Image.network(
                                  e.imageLink,
                                  width: double.infinity,
                                ),
                                SizedBox(
                                    height: getProportionateScreenHeight(10)),
                                Text(
                                  e.name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          getProportionateScreenWidth(20)),
                                ),
                                SizedBox(
                                    height: getProportionateScreenHeight(5)),
                                Row(
                                  children: [
                                    TextButton(
                                        onPressed: () => Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                                builder: (context) =>
                                                    ReductionManagementScreen(
                                                        commerce: e))),
                                        child: Text("Bons plans associés",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color:
                                                    Provider.of<ThemeManager>(
                                                                context)
                                                            .isDarkMode()
                                                        ? Colors.white
                                                        : Colors.black,
                                                fontWeight: FontWeight.w600))),
                                    Spacer(),
                                    IconButton(
                                      color: Colors.blue[300],
                                      icon: Icon(Icons.mode_edit),
                                      onPressed: () => Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  UpdateCommerceScreen(
                                                      commerce: e,
                                                      modifyCallback:
                                                          updateCommerce))),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      color: Colors.red[400],
                                      onPressed: () =>
                                          _deleteCommerce(context, e),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList() +
                        [SizedBox(height: getProportionateScreenHeight(80))],
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _readQrCode(context),
          child: Icon(Icons.qr_code_scanner),
          backgroundColor: Provider.of<ThemeManager>(context).isDarkMode()
              ? ternaryColor
              : primaryColor,
        ),
      ),
    );
  }

  void _readQrCode(BuildContext context) async {
    QRCodeResult result = await readQrCodeAndApplyReductionCode();
    switch (result) {
      case QRCodeResult.OK:
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Code utilisé")));
        break;
      case QRCodeResult.ALREADY_USED:
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Code déjà utilisé")));
        break;
      case QRCodeResult.NO_SCAN:
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Aucun QR code lu")));
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Erreur lors de la lecture du QR code")));
        break;
    }
  }

  void _addCommerce() {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => UpdateCommerceScreen(
                  modify: false,
                  addCallback: addCommerce,
                )));
  }

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
              await FirebaseSettings.instance
                  .getStorage()
                  .refFromURL(commerce.imageLink)
                  .delete();
              removeCommerce(commerce);
              Navigator.pop(context);
            },
          );
        });
  }
}
