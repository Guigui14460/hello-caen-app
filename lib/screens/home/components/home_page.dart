import 'package:diacritic/diacritic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../generated_screens/generated_store_screen.dart';
import '../../reduction_code_detail/reduction_code_detail_screen.dart';
import '../../sign_in/sign_in_screen.dart';
import '../../sign_up/sign_up_screen.dart';
import '../../../constants.dart';
import '../../../settings.dart';
import '../../../utils.dart';
import '../../../components/search_bar.dart';
import '../../../components/store_card.dart';
import '../../../model/commerce.dart';
import '../../../model/database/commerce_model.dart';
import '../../../model/database/reduction_code_model.dart';
import '../../../model/reduction_code.dart';
import '../../../services/location_service.dart';
import '../../../services/size_config.dart';
import '../../../services/theme_manager.dart';
import '../../../services/user_manager.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Commerce _sponsoredStore;
  ReductionCode _sponsoredReductionCode;
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  String _currentSearch = "";
  List<Commerce> _favoriteStores = [];
  List<Commerce> _searchResults = [];
  LocationData _locationData;
  List<Commerce> _storesGetByLocation = [];

  @override
  void initState() {
    super.initState();
  }

  void _search(String value) {
    if (this.mounted) {
      setState(() {
        _currentSearch = value;
        _searchResults = _favoriteStores;
        if (value != "") {
          _searchResults = _searchResults
              .where((element) => removeDiacritics(element.name.toLowerCase())
                  .contains(removeDiacritics(value.toLowerCase())))
              .toList();
        }
      });
    }
  }

  void _onRefresh(UserManager userManager) async {
    if (this.mounted) {
      setState(() {
        _storesGetByLocation = [];
        _locationData = null;
      });
    }
    await ReductionCodeModel().where("name", isEqualTo: "LAUNCH").then((value) {
      if (this.mounted) {
        setState(() {
          _sponsoredReductionCode = value[0];
        });
      }
    });
    await CommerceModel()
        .where("name", isEqualTo: "Café 1")
        .then((value) async {
      if (this.mounted) {
        setState(() {
          _sponsoredStore = value[0];
        });
      }
    });
    if (userManager.isLoggedIn()) {
      await CommerceModel()
          .getMultipleByIds(userManager.getLoggedInUser().favoriteCommerceIds)
          .then((value) async {
        if (this.mounted) {
          setState(() {
            _favoriteStores = value;
          });
        }
      });
    }
    this._search(_currentSearch);
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ThemeManager>(context);
    UserManager userManager = Provider.of<UserManager>(context);
    LocationService locationService = LocationService.getInstance();
    int now = DateTime.now().hour;
    return SmartRefresher(
      controller: _refreshController,
      onLoading: _onLoading,
      onRefresh: () => _onRefresh(userManager),
      enablePullDown: true,
      header: MaterialClassicHeader(height: 20, color: primaryColor),
      footer: ClassicFooter(),
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(15)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    //(4 <= now && now <= 18 ? "Bonjour" : "Bonsoir") +
                    " Ah cool, \n te revoilà, enfin",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: getProportionateScreenWidth(30),
                      color: ternaryColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(30)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Contenus sponsorisés",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: getProportionateScreenHeight(20),
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(5)),
                  SponsoredReductionCodeBanner(code: _sponsoredReductionCode),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  (_sponsoredStore != null
                      ? StoreCard(
                          commerce: _sponsoredStore,
                          width: double.infinity,
                          height: 150,
                          showComments: false,
                          smallTitle: "Commerce sponsorisé",
                          onTap: () => Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => GeneratedStoreScreen(
                                      data: _sponsoredStore))),
                        )
                      : Text(
                          "Aucun commerce sponsorisé disponible pour le moment")),
                  SizedBox(height: getProportionateScreenHeight(30)),
                ],
              ),
              (userManager.isLoggedIn()
                  ? buildFavoriteStoresWidget(_searchResults)
                  : buildSignInSignUpWidget(context)),
              SizedBox(height: getProportionateScreenHeight(20)),
              Text(
                "Commerces près de vous",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: getProportionateScreenHeight(20),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(5)),
              (locationService.isEnabled()
                  ? buildLocationStoreWidget(context)
                  : Text(
                      "Par accéder à ce contenu, activez la localisation dans les paramètres")),
              SizedBox(height: getProportionateScreenHeight(20)),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLocationStoreWidget(BuildContext context) {
    LocationService locationService = Provider.of<LocationService>(context);
    locationService.addOnChangedFunction((LocationData location) async {
      List<LatLng> latlngs =
          searchBorderBox(location.latitude, location.longitude);
      await CommerceModel()
          .whereLinked("latitude", isGreaterThanOrEqualTo: latlngs[0].latitude)
          .whereLinked("latitude", isLessThanOrEqualTo: latlngs[1].latitude)
          .executeCurrentLinkedQueryRequest()
          .then((value) {
        value = value
            .where((element) =>
                element.longitude >= latlngs[0].longitude &&
                element.longitude <= latlngs[1].longitude)
            .where((element) =>
                getDistanceFromLatLonInKm(location.latitude, location.longitude,
                        element.latitude, element.longitude) *
                    1000 <=
                maximalDistanceToSeeStore)
            .toList();
        if (this.mounted) {
          setState(() {
            _locationData = location;
            _storesGetByLocation = value;
          });
        }
      });
    });
    if (_locationData == null) {
      return Text("Aucune données de localisation trouvées");
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: getProportionateScreenHeight(10)),
        (_storesGetByLocation.length == 0
            ? Text("Aucun commerce près de votre localisation")
            : Column(
                children: List.generate(
                  _storesGetByLocation.length,
                  (index) => StoreCard(
                    commerce: _storesGetByLocation[index],
                    width: double.infinity,
                    height: 100,
                    onTap: () => Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => GeneratedStoreScreen(
                                data: _storesGetByLocation[index]))),
                  ),
                ),
              )),
      ],
    );
  }

  Widget buildFavoriteStoresWidget(List<Commerce> favoriteStores) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Commerces favoris",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: getProportionateScreenHeight(20),
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(5)),
        SearchBar(onChanged: _search),
        SizedBox(height: getProportionateScreenHeight(10)),
        (favoriteStores.length == 0
            ? Text("Aucun commerce dans vos favoris")
            : Column(
                children: List.generate(
                  favoriteStores.length,
                  (index) => StoreCard(
                    commerce: favoriteStores[index],
                    width: double.infinity,
                    height: 100,
                    onTap: () => Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => GeneratedStoreScreen(
                                data: favoriteStores[index]))),
                  ),
                ),
              )),
      ],
    );
  }

  Widget buildSignInSignUpWidget(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
                onTap: () => Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => SignInScreen())),
                child: Text(
                  "Connectez-vous",
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: getProportionateScreenWidth(20),
                  ),
                )),
            Text(
              " ou ",
              style: TextStyle(fontSize: getProportionateScreenWidth(20)),
            ),
            GestureDetector(
                onTap: () => Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => SignUpScreen())),
                child: Text(
                  "incrivez-vous",
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: getProportionateScreenWidth(20)),
                )),
          ],
        ),
        Text("pour accéder à des propositions de contenus personnalisées",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: getProportionateScreenWidth(20))),
      ],
    );
  }
}

class SponsoredReductionCodeBanner extends StatelessWidget {
  final ReductionCode code;
  SponsoredReductionCodeBanner({Key key, @required this.code})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (code == null) {
      return Text("Aucune réduction sponsorisée disponible pour le moment");
    }
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => ReductionCodeDetailScreen(code: code))),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(20),
          vertical: getProportionateScreenWidth(20),
        ),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              secondaryColor,
              secondaryColor.withOpacity(0.85),
            ],
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text.rich(
          TextSpan(
            text: "Bon plan sponsorisé\n",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            children: [
              TextSpan(
                text: code.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
