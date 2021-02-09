import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'account_profile.dart';
import 'home_page.dart';
import 'reduction_code_list.dart';
import '../../stores/components/store_list.dart';
import '../../location/location_screen.dart';
import '../../../constants.dart';
import '../../../components/app_bar.dart';
import '../../../model/commerce.dart';
import '../../../model/commerce_type.dart';
import '../../../model/database/commerce_model.dart';
import '../../../model/database/commerce_type_model.dart';
import '../../../model/database/reduction_code_model.dart';
import '../../../model/reduction_code.dart';
import '../../../services/theme_manager.dart';

/// Class to build all widgets of the [HomeScreen].
class HomeBody extends StatefulWidget {
  HomeBody({Key key}) : super(key: key);

  @override
  _HomeBodyState createState() => _HomeBodyState();
}

/// [State] of the [HomeBody].
class _HomeBodyState extends State<HomeBody> {
  int _currentIndex = 0;
  List<Widget> _children = [];

  List<Commerce> _commerces = [];
  List<ReductionCode> _codes = [];
  List<CommerceType> _types = [];

  @override
  void initState() {
    _children = [
      HomePage(
        getCommerces: getCommerces,
        getCodes: getCodes,
        refreshCommerces: _refreshCommerces,
        refreshCodes: _refreshCodes,
        refreshCommerceTypes: _refreshCommerceTypes,
      ),
      StoreListPage(
        getCommerces: getCommerces,
        getCommerceTypes: getCommerceTypes,
        refreshCommerceTypes: _refreshCommerceTypes,
        refreshCommerces: _refreshCommerces,
      ),
      ReductionCodeListPage(
        getCodes: getCodes,
        getCommerces: getCommerces,
        getCommerceTypes: getCommerceTypes,
        refreshCodes: _refreshCodes,
        refreshCommerceTypes: _refreshCommerceTypes,
      ),
      LocationScreen(),
      AccountProfilePage(widget),
    ];
    super.initState();
  }

  List<ReductionCode> getCodes() {
    return this._codes;
  }

  Future<void> _refreshCodes() async {
    await ReductionCodeModel().getAll().then((value) {
      if (this.mounted) {
        setState(() {
          _codes = value;
        });
      }
    });
  }

  List<Commerce> getCommerces() {
    return this._commerces;
  }

  Future<void> _refreshCommerces() async {
    await CommerceModel().getAll().then((value) {
      if (this.mounted) {
        setState(() {
          _commerces = value;
        });
      }
    });
  }

  List<CommerceType> getCommerceTypes() {
    return this._types;
  }

  Future<void> _refreshCommerceTypes() async {
    await CommerceTypeModel().getAll().then((value) {
      if (this.mounted) {
        setState(() {
          _types = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeManager>(context).isDarkMode();
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        body: _children[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          selectedItemColor: isDarkMode ? ternaryColor : secondaryColor,
          unselectedItemColor: isDarkMode ? Colors.white : Colors.black,
          selectedIconTheme:
              IconThemeData(color: isDarkMode ? ternaryColor : secondaryColor),
          unselectedIconTheme:
              IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
          showSelectedLabels: true,
          selectedFontSize: 13,
          showUnselectedLabels: true,
          currentIndex: _currentIndex,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          onTap: (value) {
            setState(() {
              _currentIndex = value;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Accueil',
              activeIcon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.store_outlined),
              label: 'Commerces',
              activeIcon: Icon(Icons.store),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_offer_outlined),
              label: 'Bons plans',
              activeIcon: Icon(Icons.local_offer),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.place_outlined),
              label: 'Localisation',
              activeIcon: Icon(Icons.place),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: 'Compte',
              activeIcon: Icon(Icons.account_circle),
            ),
          ],
        ),
      ),
    );
  }
}
