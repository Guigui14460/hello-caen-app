import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../screens/account_profile/account_profile_screen.dart';
import '../services/theme_manager.dart';
import '../screens/explanations/explanations_screen.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  static Widget _title = SizedBox(
    height: 60,
    child: SvgPicture.asset("assets/images/logo.svg"),
  );
  static Size _size = Size(double.minPositive, 65.0);

  @override
  Widget build(BuildContext context) {
    ThemeManager manager = Provider.of<ThemeManager>(context);
    Color textColor = manager.isDarkMode() ? Colors.white : Colors.black;
    return AppBar(
      toolbarHeight: 65,
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: _title,
      foregroundColor: textColor,
      leading: IconButton(
        icon: Icon(Icons.menu),
        color: textColor,
        onPressed: () {
          Navigator.popAndPushNamed(context, ExplanationsScreen.routeName);
        },
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          color: textColor,
          onPressed: () {
            Navigator.pushNamed(context, AccountProfileScreen.routeName);
          },
        )
      ],
    );
  }

  @override
  Size get preferredSize => _size;
}
