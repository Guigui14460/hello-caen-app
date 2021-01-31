import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/size_config.dart';
import '../services/theme_manager.dart';

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
    Color color = Provider.of<ThemeManager>(context).isDarkMode()
        ? Colors.white
        : Colors.black;
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF777777).withOpacity(0.6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        onChanged: onChanged,
        style: TextStyle(color: color),
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: placeholder,
          prefixIcon: Icon(Icons.search, color: color),
          contentPadding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
            vertical: getProportionateScreenWidth(13),
          ),
        ),
      ),
    );
  }
}
