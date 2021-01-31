import 'package:diacritic/diacritic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../reduction_code_detail/reduction_code_detail_screen.dart';
import '../../sign_in/sign_in_screen.dart';
import '../../sign_up/sign_up_screen.dart';
import '../../../constants.dart';
import '../../../components/search_bar.dart';
import '../../../components/store_card.dart';
import '../../../model/commerce.dart';
import '../../../model/database/commerce_model.dart';
import '../../../model/database/reduction_code_model.dart';
import '../../../model/reduction_code.dart';
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

  @override
  void initState() {
    super.initState();
  }

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
      await value[0].init();
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
        for (Commerce store in value) {
          await store.init();
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
            children: [
              Text(
                (4 <= now && now <= 18 ? "Bonjour" : "Bonsoir") +
                    " cher\nHello Caennais",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: getProportionateScreenWidth(30),
                  color: ternaryColor,
                ),
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
                          onTap: () {},
                          // onTap: () => Navigator.push(
                          //       context,
                          //       CupertinoPageRoute(
                          //           builder: (context) => CommerceDetailScreen(commerce: _sponsoredStore))),
                        )
                      : Text(
                          "Aucun commerce sponsorisé disponible pour le moment")),
                  SizedBox(height: getProportionateScreenHeight(30)),
                ],
              ),
              (userManager.isLoggedIn()
                  ? buildFavoriteStoresWidget(_searchResults)
                  : buildSignInSignUpWidget(context)),
            ],
          ),
        ),
      ),
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
        Column(
          children: List.generate(
            favoriteStores.length,
            (index) => StoreCard(
              commerce: favoriteStores[index],
              width: double.infinity,
              height: 100,
              onTap: () {},
              // onTap: () => Navigator.push(
              //       context,
              //       CupertinoPageRoute(
              //           builder: (context) => CommerceDetailScreen(commerce: favoriteStores[index]))),
            ),
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(20)),
      ],
    );
  }
}

Widget buildSignInSignUpWidget(BuildContext context) {
  return Column(
    children: [
      Row(
        children: [
          GestureDetector(
              onTap: () => Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => SignInScreen())),
              child: Text(
                "Connectez-vous",
                style: TextStyle(color: primaryColor),
              )),
          Text(" ou "),
          GestureDetector(
              onTap: () => Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => SignUpScreen())),
              child: Text(
                "incrivez-vous",
                style: TextStyle(color: primaryColor),
              )),
        ],
      ),
      Text("pour accéder à des propositions de contenus personnalisées"),
    ],
  );
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
            style: TextStyle(color: Colors.white),
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
