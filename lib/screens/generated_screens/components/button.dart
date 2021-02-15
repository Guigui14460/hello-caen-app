import 'package:flutter/material.dart';

class SmallButton extends StatelessWidget {
  final Function onPressed;
  final Icon icon;
  final String name;
  final double size;
  const SmallButton(
      {Key key,
      @required this.name,
      @required this.onPressed,
      this.icon,
      this.size = 18})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: TextButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (icon != null
                ? Icon(
                    Icons.add,
                  )
                : Container()),
            Text(
              name,
              style: TextStyle(fontSize: size),
            ),
          ],
        ),
      ),
    );
  }
}
