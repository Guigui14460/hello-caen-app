import 'package:diacritic/diacritic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../generated_screens/generated_store_screen.dart';
import '../../../settings.dart';
import '../../../constants.dart';
import '../../../components/category_menu.dart';
import '../../../components/store_card.dart';
import '../../../components/search_bar.dart';
import '../../../helper/rating_and_comment_count.dart';
import '../../../model/commerce.dart';
import '../../../model/commerce_type.dart';
import '../../../services/size_config.dart';
import '../../../services/theme_manager.dart';
import '../../../services/user_manager.dart';

class StoreListPage extends StatefulWidget {
  final Future<void> Function() refreshCommerces, refreshCommerceTypes;
  final List<Commerce> Function() getCommerces;
  final List<CommerceType> Function() getCommerceTypes;
  final Map<Commerce, double> Function() getCommerceDistances;
  final Map<Commerce, RatingAndCommentCount> Function() getRatings;

  const StoreListPage({
    Key key,
    @required this.getCommerces,
    @required this.getCommerceTypes,
    @required this.getCommerceDistances,
    @required this.getRatings,
    @required this.refreshCommerces,
    @required this.refreshCommerceTypes,
  }) : super(key: key);

  @override
  _StoreListPageState createState() => _StoreListPageState();
}

class _StoreListPageState extends State<StoreListPage> {
  RefreshController _refreshController = RefreshController();
  String _currentSearch = "";
  bool _showFavoriteStores = false;
  bool _showStoresNextToUser = false;
  List<Commerce> _favoriteStores = [];
  List<Commerce> _stores = [];
  List<CommerceType> _types = [];
  List<Commerce> _currentDisplayedStores = [];
  List<Commerce> _searchResults = [];
  CommerceType _currentType;
  Map<Commerce, RatingAndCommentCount> _ratings = {};
  Iterable<Commerce> _storesNextToUser = [];

  @override
  void initState() {
    super.initState();
    if (this.mounted) {
      setState(() {
        _types = widget.getCommerceTypes();
        _stores = _searchResults = widget.getCommerces();
        _ratings = widget.getRatings();
      });
    }
  }

  void _search(String value) {
    if (this.mounted) {
      setState(() {
        _currentSearch = value;
        _searchResults = _currentDisplayedStores;
        if (value != "") {
          setState(() {
            _searchResults = _searchResults
                .where((element) =>
                    (this._currentType == null ||
                        element.typeId == this._currentType.id) &&
                    removeDiacritics(element.name.toLowerCase())
                        .contains(removeDiacritics(value.toLowerCase())))
                .toList();
          });
        }
      });
    }
  }

  void _filterByType(CommerceType type) {
    Iterable<Commerce> filteredList = _stores;
    if (_showStoresNextToUser) {
      if (this.mounted) {
        setState(() {
          _storesNextToUser = _filterCommercesByDistance().keys;
        });
      }
      filteredList = _storesNextToUser;
    }
    if (_showFavoriteStores) {
      filteredList =
          filteredList.where((element) => _favoriteStores.contains(element));
    }
    if (this.mounted) {
      setState(() {
        _currentType = type;
        if (type != null) {
          _currentDisplayedStores = filteredList
              .where((element) => element.typeId == type.id)
              .toList();
        } else {
          _currentDisplayedStores = filteredList.toList();
        }
      });
    }
    this._search(this._currentSearch);
  }

  void _onRefresh(UserManager userManager) async {
    await Future.wait([
      widget.refreshCommerces(),
      widget.refreshCommerceTypes(),
    ]);

    if (this.mounted) {
      setState(() {
        _types = widget.getCommerceTypes();
        _stores = widget.getCommerces();
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
    this._filterByType(_currentType);
    this._search(this._currentSearch);
    _refreshController.refreshCompleted();
  }

  void _onLoading() {
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
    if (this.mounted) {
      setState(() {
        _favoriteStores = widget
            .getCommerces()
            .where((element) => userManager
                .getLoggedInUser()
                .favoriteCommerceIds
                .contains(element.id))
            .toList();
      });
    }
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: () => _onRefresh(userManager),
      onLoading: _onLoading,
      enablePullDown: true,
      header: MaterialClassicHeader(
        height: 80,
        color: primaryColor,
      ),
      footer: ClassicFooter(),
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenHeight(20)),
            Row(
              children: [
                Expanded(
                  child: SearchBar(onChanged: _search),
                ),
                SizedBox(width: getProportionateScreenWidth(10)),
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    if (this.mounted) {
                      setState(() {
                        _showFavoriteStores = !_showFavoriteStores;
                      });
                      this._filterByType(this._currentType);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(12),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 150),
                      child: Icon(
                        _showFavoriteStores
                            ? Icons.bookmarks
                            : Icons.bookmarks_outlined,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: getProportionateScreenWidth(10)),
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    if (this.mounted) {
                      setState(() {
                        _showStoresNextToUser = !_showStoresNextToUser;
                      });
                      this._filterByType(this._currentType);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(12),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 150),
                      child: Icon(
                        _showStoresNextToUser
                            ? Icons.place
                            : Icons.place_outlined,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            CategoryMenu(
              text: ["Tout"] + _types.map((e) => e.name).toList(),
              onPressed: [() => _filterByType(null)] +
                  _types.map((e) => (() => _filterByType(e))).toList(),
            ),
            SizedBox(height: getProportionateScreenHeight(30)),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: buildCommerceView(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildCommerceView() {
    Map<Commerce, double> distances = widget.getCommerceDistances();
    return List.generate(
      _searchResults.length,
      (index) {
        Commerce commerce = _searchResults[index];
        return StoreCard(
          commerce: commerce,
          width: double.infinity,
          height: 105,
          rating: _ratings[commerce],
          distance: _storesNextToUser.contains(commerce)
              ? distances[commerce]
              : double.nan,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GeneratedStoreScreen(
                  data: commerce,
                  rating: _ratings[commerce],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Map<Commerce, double> _filterCommercesByDistance() {
    Map<Commerce, double> distances = widget.getCommerceDistances(),
        returns = {};
    distances.entries.forEach((element) {
      if (element.value <= maximalDistanceToSeeStore) {
        returns[element.key] = element.value;
      }
    });
    return returns;
  }
}
