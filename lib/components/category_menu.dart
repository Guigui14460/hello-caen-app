import 'package:flutter/material.dart';

import '../constants.dart';

class CategoryMenu extends StatefulWidget {
  final List<String> text;
  final List<VoidCallback> onPressed;

  CategoryMenu({Key key, @required this.text, @required this.onPressed})
      : super(key: key);

  @override
  _CategoryMenuState createState() => _CategoryMenuState();
}

class _CategoryMenuState extends State<CategoryMenu> {
  int _currentSelected = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.text.length,
        itemBuilder: (context, index) {
          return Container(
            margin: index == widget.text.length - 1
                ? EdgeInsets.only(right: 0)
                : EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
                borderRadius: new BorderRadius.circular(24),
                color: index == _currentSelected
                    ? ternaryColor
                    : Colors.transparent),
            child: OutlineButton(
              onPressed: () => _onPressed(index),
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(24)),
              child: Text(widget.text[index]),
            ),
          );
        },
      ),
    );
  }

  void _onPressed(int index) {
    widget.onPressed[index]();
    if (this.mounted) {
      setState(() {
        _currentSelected = index;
      });
    }
  }
}
