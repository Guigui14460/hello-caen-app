import 'package:diacritic/diacritic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../generated_screens/generated_store_screen.dart';
import '../../../constants.dart';
import '../../../components/category_menu.dart';
import '../../../components/store_card.dart';
import '../../../components/search_bar.dart';
import '../../../model/commerce.dart';
import '../../../model/commerce_type.dart';
import '../../../services/size_config.dart';
import '../../../services/theme_manager.dart';
import '../../../services/user_manager.dart';

class StoreListPage extends StatefulWidget {
  final Future<void> Function() refreshCommerces, refreshCommerceTypes;
  final List<Commerce> Function() getCommerces;
  final List<CommerceType> Function() getCommerceTypes;

  const StoreListPage(
      {Key key,
      @required this.getCommerces,
      @required this.getCommerceTypes,
      @required this.refreshCommerces,
      @required this.refreshCommerceTypes})
      : super(key: key);

  @override
  _StoreListPageState createState() => _StoreListPageState();
}

class _StoreListPageState extends State<StoreListPage> {
  RefreshController _refreshController = RefreshController();
  String _currentSearch = "";
  List<Commerce> _favoriteStores = [];
  List<Commerce> _stores = [];
  List<CommerceType> _types = [];
  List<Commerce> _currentDisplayedStores = [];
  List<Commerce> _searchResults = [];
  CommerceType _currentType;

  @override
  void initState() {
    super.initState();
    if (this.mounted) {
      setState(() {
        _types = widget.getCommerceTypes();
        _stores = _searchResults = widget.getCommerces();
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
            _searchResults = _currentDisplayedStores
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
    if (this.mounted) {
      setState(() {
        _currentType = type;
        if (type != null) {
          _currentDisplayedStores = widget
              .getCommerces()
              .where((element) => element.typeId == type.id)
              .toList();
        } else {
          _currentDisplayedStores = widget.getCommerces();
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
      });
    }
    if (userManager.isLoggedIn() && this.mounted) {
      if (this.mounted) {
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
  Widget build(BuildContext context) {
    Provider.of<ThemeManager>(context);
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: () =>
          _onRefresh(Provider.of<UserManager>(context, listen: false)),
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
            SizedBox(height: getProportionateScreenHeight(30)),
            SearchBar(onChanged: _search),
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
    return List.generate(
      _searchResults.length,
      (index) {
        return StoreCard(
          commerce: _searchResults[index],
          width: double.infinity,
          height: 105,
          onTap: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) =>
                        GeneratedStoreScreen(data: _searchResults[index])));
          },
        );
      },
    );
  }
}
