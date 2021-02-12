import 'package:diacritic/diacritic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../components/sponsored_code_banner.dart';
import '../../generated_screens/generated_store_screen.dart';
import '../../sign_in/sign_in_screen.dart';
import '../../sign_up/sign_up_screen.dart';
import '../../../constants.dart';
import '../../../settings.dart';
import '../../../components/search_bar.dart';
import '../../../components/store_card.dart';
import '../../../helper/rating_and_comment_count.dart';
import '../../../model/commerce.dart';
import '../../../model/reduction_code.dart';
import '../../../services/location_service.dart';
import '../../../services/size_config.dart';
import '../../../services/theme_manager.dart';
import '../../../services/user_manager.dart';

class HomePage extends StatefulWidget {
  final Future<void> Function() refreshCommerces,
      refreshCodes,
      refreshCommerceTypes;
  final List<Commerce> Function() getCommerces;
  final List<ReductionCode> Function() getCodes;
  final Map<Commerce, double> Function() getCommerceDistances;
  final Map<Commerce, RatingAndCommentCount> Function() getRatings;

  HomePage({
    Key key,
    @required this.getCommerces,
    @required this.getCodes,
    @required this.getCommerceDistances,
    @required this.getRatings,
    @required this.refreshCommerces,
    @required this.refreshCodes,
    @required this.refreshCommerceTypes,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  Commerce _sponsoredStore;
  ReductionCode _sponsoredReductionCode;
  String _currentSearch = "";
  List<Commerce> _stores = [];
  List<ReductionCode> _codes = [];
  List<Commerce> _favoriteStores = [];
  List<Commerce> _searchResults = [];
  LocationData _locationData;
  Map<Commerce, RatingAndCommentCount> _ratings = {};

  void _search(String value) {
    if (this.mounted) {
      setState(() {
        _currentSearch = value;
        _searchResults = List<Commerce>.from(_favoriteStores);
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
    await Future.wait([
      widget.refreshCommerces(),
      widget.refreshCodes(),
      widget.refreshCommerceTypes(),
    ]);
    if (this.mounted) {
      setState(() {
        _locationData = null;
        _codes = widget.getCodes();
        _stores = widget.getCommerces();
        _sponsoredReductionCode = _codes[0];
        _sponsoredStore = _stores[0];
        _ratings = widget.getRatings();
      });

      if (userManager.isLoggedIn()) {
        List<String> fav = userManager.getLoggedInUser().favoriteCommerceIds;
        setState(() {
          _favoriteStores =
              _stores.where((element) => fav.contains(element.id)).toList();
        });
      }
    }
    this._search(_currentSearch);
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    _refreshController.loadComplete();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ThemeManager>(context);
    UserManager userManager = Provider.of<UserManager>(context);
    LocationService locationService = LocationService.getInstance();
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
                    " Ah cool,\nte revoilà, enfin",
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
                          rating: _ratings[_sponsoredStore],
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GeneratedStoreScreen(
                                        data: _sponsoredStore,
                                      ))),
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

  List<Commerce> _filterCommercesByDistance() {
    Map<Commerce, double> distances = widget.getCommerceDistances();
    List<Commerce> commercesNextToUser =
        distances.keys.map<Commerce>((element) {
      if (distances[element] <= maximalDistanceToSeeStore) {
        return element;
      }
      return null;
    }).toList();
    commercesNextToUser.removeWhere((element) => element == null);
    return commercesNextToUser;
  }

  Widget buildLocationStoreWidget(BuildContext context) {
    LocationService locationService = Provider.of<LocationService>(context);
    locationService.addOnChangedFunction((LocationData location) {
      if (this.mounted) {
        setState(() {
          _locationData = location;
        });
      }
    });
    if (_locationData == null) {
      return Text("Aucune données de localisation trouvées");
    }
    List<Commerce> commercesNextToUser = _filterCommercesByDistance();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: getProportionateScreenHeight(10)),
        (commercesNextToUser.length == 0
            ? Text("Aucun commerce trouvé près de votre localisation")
            : Column(
                children: List.generate(
                  commercesNextToUser.length,
                  (index) => StoreCard(
                    commerce: commercesNextToUser[index],
                    width: double.infinity,
                    height: 105,
                    rating: _ratings[commercesNextToUser[index]],
                    onTap: () => Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => GeneratedStoreScreen(
                                  data: commercesNextToUser[index],
                                ))),
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
                    height: 105,
                    rating: _ratings[favoriteStores[index]],
                    onTap: () => Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => GeneratedStoreScreen(
                                  data: favoriteStores[index],
                                ))),
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
              style: TextStyle(
                fontSize: getProportionateScreenWidth(20),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => SignUpScreen())),
              child: Text(
                "incrivez-vous",
                style: TextStyle(
                  color: primaryColor,
                  fontSize: getProportionateScreenWidth(20),
                ),
              ),
            ),
          ],
        ),
        Text(
          "pour accéder à des propositions de contenus personnalisées",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: getProportionateScreenWidth(20)),
        ),
      ],
    );
  }
}
