import 'package:flutter/material.dart';

import '../services/size_config.dart';

class SearchBar extends StatelessWidget {
  final void Function(String) onChanged;
  final String placeholder;
  SearchBar({
    Key key,
    @required this.onChanged,
    this.placeholder = "Rechercher",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF777777).withOpacity(0.6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        onChanged: onChanged,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: placeholder,
          prefixIcon: Icon(Icons.search, color: Colors.white),
          contentPadding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
            vertical: getProportionateScreenWidth(13),
          ),
        ),
      ),
    );
  }
}
