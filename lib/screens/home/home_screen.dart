import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import 'pages/account_profile.dart';
import 'pages/home_page.dart';
import 'pages/reduction_code_list.dart';
import 'pages/store_list.dart';
import '../location/location_screen.dart';
import '../../constants.dart';
import '../../utils.dart';
import '../../components/app_bar.dart';
import '../../helper/rating_and_comment_count.dart';
import '../../model/commerce.dart';
import '../../model/commerce_type.dart';
import '../../model/rating.dart';
import '../../model/user_account.dart';
import '../../model/database/commerce_model.dart';
import '../../model/database/commerce_type_model.dart';
import '../../model/database/rating_model.dart';
import '../../model/database/reduction_code_model.dart';
import '../../model/reduction_code.dart';
import '../../services/location_service.dart';
import '../../services/theme_manager.dart';
import '../../services/size_config.dart';
import '../../services/user_manager.dart';

/// Screen displayed by default for all users.
class HomeScreen extends StatefulWidget {
  /// Name of the route where is the screen.
  static final String routeName = "/home";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<Widget> _children = [];

  List<Commerce> _commerces = [];
  List<ReductionCode> _codes = [];
  List<CommerceType> _types = [];
  Map<Commerce, double> _commerceDistances;
  LocationData _locationData;
  List<Commerce> _favoriteCommerces = [];
  Map<Commerce, RatingAndCommentCount> _ratings = {};

  @override
  void initState() {
    _children = [
      HomePage(
        getCommerces: getCommerces,
        getCodes: getCodes,
        getCommerceDistances: getCommerceDistances,
        getRatings: getRatings,
        refreshCommerces: _refreshCommerces,
        refreshCodes: _refreshCodes,
        refreshCommerceTypes: _refreshCommerceTypes,
      ),
      StoreListPage(
        getCommerceDistances: getCommerceDistances,
        getCommerces: getCommerces,
        getCommerceTypes: getCommerceTypes,
        getRatings: getRatings,
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
      MapPage(
        getCommerces: getCommerces,
        getCommerceDistances: getCommerceDistances,
        getRatings: getRatings,
      ),
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

  Map<Commerce, RatingAndCommentCount> getRatings() {
    return this._ratings;
  }

  Future<void> _refreshCommerces() async {
    User user = UserManager.instance.getLoggedInUser();
    await CommerceModel().getAll().then((value) async {
      if (this.mounted) {
        setState(() {
          _commerces = value;
          _ratings = {};
          _favoriteCommerces = value
              .where((element) => user.favoriteCommerceIds.contains(element.id))
              .toList();
        });
        List<Rating> ratings = await RatingModel().getAll();
        for (Commerce commerce in value) {
          setState(() {
            _ratings[commerce] = RatingAndCommentCount.getObject(
                ratings.where((element) => element.commerceId == commerce.id));
          });
        }
      }
    });
    this._refreshCommerceDistances(this._locationData);
  }

  Map<Commerce, double> getCommerceDistances() {
    return this._commerceDistances;
  }

  void _refreshCommerceDistances(LocationData currentLocation) {
    if (currentLocation != null && this.mounted) {
      setState(() {
        _commerceDistances = {};
        _locationData = currentLocation;
      });
      for (Commerce commerce in _commerces) {
        _commerceDistances[commerce] = getDistanceFromLatLonInKm(
                currentLocation.latitude,
                currentLocation.longitude,
                commerce.latitude,
                commerce.longitude) *
            1000;
      }
    } else {
      _commerceDistances = null;
    }
  }

  List<Commerce> getFavoriteCommerces() {
    return this._favoriteCommerces;
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
    SizeConfig().init(context);
    bool isDarkMode = Provider.of<ThemeManager>(context).isDarkMode();
    LocationService locationService = Provider.of<LocationService>(context);
    if (locationService.isEnabled()) {
      locationService.addOnChangedFunction(this._refreshCommerceDistances);
    }
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
              icon: Icon(Icons.map_outlined),
              label: 'Carte',
              activeIcon: Icon(Icons.map),
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
