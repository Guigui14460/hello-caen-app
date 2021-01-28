import 'package:flutter/material.dart';


class CategoryMenu extends StatefulWidget {

  final List<String> text;
  final List<VoidCallback> onPressed;

  CategoryMenu({Key key,this.text,this.onPressed }) : super(key: key);

  @override
  _CategoryMenuState createState() => _CategoryMenuState();

}


class _CategoryMenuState extends State<CategoryMenu> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 700,
      height: 50,

      child:ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.text.length,
          itemBuilder: (context,index){
            return Container(
                margin: const EdgeInsets.only(left: 5,right: 5),
                child:OutlineButton(
                  onPressed: widget.onPressed[index],
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                  child:Container(width: 100,height: 50,child: Center(child:Text(widget.text[index])))
                )
            );
          }
        ),
      );
  }
}