import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../components/app_bar.dart';
import '../../../components/default_button.dart';
import '../../../model/commerce_type.dart';
import '../../../model/database/commerce_type_model.dart';
import '../../../services/data_cache.dart';
import '../../../services/firebase_settings.dart';
import '../../../services/notification_service.dart';
import '../../../services/theme_manager.dart';
import '../../../utils.dart';

/// Class to build all widgets of the [AccountProfileScreen].
class AccountProfileBody extends StatefulWidget {
  AccountProfileBody({Key key}) : super(key: key);

  @override
  _AccountProfileBodyState createState() => _AccountProfileBodyState();
}

/// [State] of the [AccountProfileBody].
class _AccountProfileBodyState extends State<AccountProfileBody> {
  String results = "Nothing";
  String id = "test";

  @override
  Widget build(BuildContext context) {
    CommerceTypeModel model = new CommerceTypeModel();
    CommerceType test = CommerceType(name: "truc");

    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(getTimeAgo(Duration(minutes: 4))),
            Text(getTimeAgoFrom(DateTime(2010, 4, 13))),
            Text(getTimeAgo(Duration(hours: 2300))),
            DefaultButton(
                height: 40,
                text: "Get all commerce types",
                press: () {
                  model.getAll().then((value) => {
                        setState(() {
                          results = value.map((e) => e.name).join(", ");
                        })
                      });
                },
                longPress: () {}),
            DefaultButton(
                height: 40,
                text: "Get all commerce types by IDs",
                press: () {
                  model.getMultipleByIds([
                    "SkP4ctuE6eshxIOQ6Qel",
                    "WtUCtvsfDSJymjuN6tsn",
                    "b0hITsXqxCWkzmJeRqzB"
                  ]).then((value) => {
                        setState(() {
                          results = "Multiple : " +
                              value.map((e) => e.name).join(", ");
                        })
                      });
                },
                longPress: () {}),
            DefaultButton(
                height: 40,
                text: "Get commerce type by id",
                press: () async {
                  CommerceType type = await model.getById(id);
                  setState(() {
                    results = (type == null ? "null" : type.name);
                  });
                },
                longPress: () {}),
            DefaultButton(
                height: 40,
                text: "Exists commerce type",
                press: () async {
                  bool exists = await model.exists(id);
                  setState(() {
                    results = (exists ? "exists" : "not exists");
                  });
                },
                longPress: () {}),
            DefaultButton(
                height: 40,
                text: "Create commerce type",
                press: () async {
                  await model.createWithId(id, test);
                  List<CommerceType> list = await model.getAll();
                  setState(() {
                    results = list.map((e) => e.name).join(", ");
                  });
                },
                longPress: () {}),
            DefaultButton(
                height: 40,
                text: "Update commerce type",
                press: () async {
                  CommerceType truc = CommerceType(name: "autre truc");
                  await model.update(id, truc);

                  List<CommerceType> list = await model.getAll();
                  setState(() {
                    results = list.map((e) => e.name).join(", ");
                  });
                },
                longPress: () {}),
            DefaultButton(
                height: 40,
                text: "Delete commerce type",
                press: () async {
                  await model.delete(id);

                  List<CommerceType> list = await model.getAll();
                  setState(() {
                    results = list.map((e) => e.name).join(", ");
                  });
                },
                longPress: () {}),
            Text(results),
            DefaultButton(
                height: 40,
                text: "Push local notification",
                press: () async {
                  await NotificationService.instance
                      .pushNotification("Test poto", "sa march b1 frr");
                  print("done");
                },
                longPress: () {}),
            DefaultButton(
                height: 40,
                text: "Send image to storage",
                press: () async {
                  await FirebaseSettings.instance.uploadFile(
                      await ImagePicker().getImage(source: ImageSource.gallery),
                      context,
                      "test",
                      "test.jpg");
                },
                longPress: () {}),
            DefaultButton(
                height: 40,
                text: "Print data cache",
                press: () {
                  print(DataCache.getSubEntry("location", "actual"));
                  DataCache.debug();
                },
                longPress: () {}),
            DefaultButton(
                height: 40,
                text: "Toggle theme",
                press: () {
                  Provider.of<ThemeManager>(context, listen: false)
                      .toggleThemeMode();
                },
                longPress: () {}),
            DefaultButton(
                height: 40,
                text: "Print current user",
                press: () {
                  print(FirebaseSettings.instance.getAuth().currentUser.uid);
                },
                longPress: () {}),
            DefaultButton(
                height: 40,
                text: "Logout current user",
                press: () async {
                  await FirebaseSettings.instance.getAuth().signOut();
                  Navigator.pop(context);
                },
                longPress: () {}),
          ],
        ),
      ),
    );
  }
}
