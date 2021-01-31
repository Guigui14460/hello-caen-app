import 'package:flutter/material.dart';

class CategoryMenu extends StatefulWidget {
  final List<String> text;
  final List<VoidCallback> onPressed;

  CategoryMenu({Key key, @required this.text, @required this.onPressed})
      : super(key: key);

  @override
  _CategoryMenuState createState() => _CategoryMenuState();
}

class _CategoryMenuState extends State<CategoryMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.text.length,
        itemBuilder: (context, index) {
          return Container(
            // margin: const EdgeInsets.only(left: 5, right: 5),
            margin: index == widget.text.length - 1
                ? EdgeInsets.only(right: 0)
                : EdgeInsets.only(right: 10),
            child: OutlineButton(
              onPressed: widget.onPressed[index],
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(24)),
              child: Container(
                child: Center(
                  child: Text(widget.text[index]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
