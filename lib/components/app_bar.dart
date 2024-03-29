import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/theme_manager.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  static Size _size = Size(double.minPositive, 65.0);

  final List<Icon> actions;
  final List<VoidCallback> actionsCallback;
  final Icon leading;
  final VoidCallback leadingCallback;
  final bool automaticBackArrow;

  MyAppBar(
      {this.leading,
      this.leadingCallback,
      this.actions,
      this.automaticBackArrow = true,
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
    Widget _title = SizedBox(
      height: 60,
      child: Image.asset("assets/images/logo.png"),
    );
    return AppBar(
      toolbarHeight: 65,
      backgroundColor: Colors.transparent,
      primary: false,
      iconTheme: IconThemeData(color: textColor),
      title: _title,
      automaticallyImplyLeading: automaticBackArrow,
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
