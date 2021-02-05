import 'package:flutter/material.dart';

import '../services/size_config.dart';

class ModalBox extends StatefulWidget {
  final String title, textButton;
  final Widget widget;
  final Function onPressed;

  ModalBox(
      {Key key,
      @required this.title,
      @required this.textButton,
      @required this.widget,
      @required this.onPressed});

  @override
  _ModalBoxState createState() => _ModalBoxState();
}

class _ModalBoxState extends State<ModalBox> {
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
    return Container(
      padding: EdgeInsets.only(left: 15, top: 25, right: 15, bottom: 15),
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
          Text(
            widget.title,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black, fontSize: 22, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: getProportionateScreenHeight(20)),
          widget.widget,
          SizedBox(height: getProportionateScreenHeight(20)),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
                onPressed: widget.onPressed,
                child: Text(widget.textButton,
                    style: TextStyle(color: Colors.black, fontSize: 18))),
          ),
        ],
      ),
    );
  }
}
