import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../services/theme_manager.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  static Size _size = Size(double.minPositive, 65.0);

  final List<Icon> actions;
  final List<VoidCallback> actionsCallback;
  final Icon leading;
  final VoidCallback leadingCallback;

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
        // Navigator.pushNamed(context, HomeScreen.routeName);
      },
    );
    return AppBar(
      toolbarHeight: 65,
      backgroundColor: Colors.transparent,
      primary: false,
      iconTheme: IconThemeData(color: textColor),
      // automaticallyImplyLeading: false,
      title: _title,
      leading: this.leading != null
          ? IconButton(
              icon: this.leading,
              color: textColor,
              onPressed: this.leadingCallback,
            )
          : null,
      actions: this.actions != null
          ? this.actions.asMap().keys.toList().map((index) {
              return IconButton(
                icon: this.actions[index],
                color: textColor,
                onPressed: this.actionsCallback[index],
              );
            }).toList()
          : [],
    );
  }

  @override
  Size get preferredSize => _size;
}
