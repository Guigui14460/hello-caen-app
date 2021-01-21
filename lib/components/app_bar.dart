import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../screens/account_profile/account_profile_screen.dart';
import '../screens/sign_in/sign_in_screen.dart';
import '../screens/sign_up/sign_up_screen.dart';
import '../screens/home/home_screen.dart';
import '../services/theme_manager.dart';
import '../services/firebase_settings.dart';
import '../screens/explanations/explanations_screen.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  static Size _size = Size(double.minPositive, 65.0);

  List<Icon> actions;
  List<VoidCallback> actionsCallback;
  Icon leading;
  VoidCallback leadingCallback;

  MyAppBar(
      {this.leading,
      this.leadingCallback,
      this.actions,
      this.actionsCallback}) {
    assert((this.leading != null && this.leadingCallback != null) ||
        (this.leading == null && this.leadingCallback == null));
    assert((this.actions != null && this.actionsCallback != null) ||
        (this.actions == null && this.actionsCallback == null));
  }

  @override
  Widget build(BuildContext context) {
    ThemeManager manager = Provider.of<ThemeManager>(context);
    Color textColor = manager.isDarkMode() ? Colors.white : Colors.black;
    Widget _title = GestureDetector(
      child: SizedBox(
        height: 60,
        child: SvgPicture.asset("assets/images/logo.svg"),
      ),
      onTap: () {
        Navigator.pushNamed(context, HomeScreen.routeName);
      },
    );
    return AppBar(
      toolbarHeight: 65,
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: _title,
      foregroundColor: textColor,
      leading: this.leading != null
          ? IconButton(
              icon: this.leading,
              color: textColor,
              onPressed: this.leadingCallback,
            )
          : null,
      // IconButton(
      //     icon: Icon(Icons.menu),
      //     color: textColor,
      //     onPressed: () {
      //       Navigator.popAndPushNamed(
      //           context, ExplanationsScreen.routeName);
      //     },
      // ),
      actions: this.actions != null
          ? this.actions.asMap().keys.toList().map((index) {
              IconButton(
                icon: this.actions[index],
                color: textColor,
                onPressed: this.actionsCallback[index],
              );
            })
          : [
              IconButton(
                icon: Icon(Icons.add),
                color: textColor,
                onPressed: () {
                  if (FirebaseSettings.instance.getAuth().currentUser != null) {
                    Navigator.pushNamed(
                        context, AccountProfileScreen.routeName);
                  } else {
                    Navigator.pushNamed(context, SignUpScreen.routeName);
                    // Navigator.pushNamed(context, SignInScreen.routeName);
                  }
                },
              )
            ],
    );
  }

  @override
  Size get preferredSize => _size;
}
