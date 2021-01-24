import 'dart:ui';

import 'package:flutter/material.dart';

import 'avatar.dart';
import '../services/size_config.dart';

class CustomDialogBox extends StatefulWidget {
  final String title, description, text;
  final ImageProvider<Object> img;
  final VoidCallback onPressed;

  CustomDialogBox(
      {Key key,
      @required this.title,
      @required this.text,
      this.description,
      this.img,
      @required this.onPressed});

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _contentBox(context),
    );
  }

  _contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: 15,
              top: (widget.img != null ? 45.0 : 0.0) + 25,
              right: 15,
              bottom: 15),
          margin: EdgeInsets.only(
              top: widget.img != null ? getProportionateScreenWidth(45) : 0),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(widget.title,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w600)),
              (widget.description != null
                  ? Column(
                      children: [
                        SizedBox(height: 15),
                        Text(
                          widget.description,
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  : SizedBox()),
              SizedBox(height: 22),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                    onPressed: widget.onPressed,
                    child: Text(widget.text,
                        style: TextStyle(color: Colors.black, fontSize: 18))),
              ),
            ],
          ),
        ),
        (widget.img != null
            ? Positioned(
                left: getProportionateScreenWidth(10),
                right: getProportionateScreenWidth(10),
                child: Avatar(
                    size: getProportionateScreenWidth(100),
                    picture: widget.img),
              )
            : SizedBox()),
      ],
    );
  }
}
