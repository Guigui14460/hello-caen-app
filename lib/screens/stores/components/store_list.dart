import 'package:diacritic/diacritic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../generated_screens/generated_store_screen.dart';
import '../../../constants.dart';
import '../../../components/category_menu.dart';
import '../../../components/store_card.dart';
import '../../../model/commerce.dart';
import '../../../model/commerce_type.dart';
import '../../../model/database/commerce_model.dart';
import '../../../model/database/commerce_type_model.dart';
import '../../../services/size_config.dart';
import '../../../services/theme_manager.dart';

class StoreListPage extends StatefulWidget {
  const StoreListPage({Key key}) : super(key: key);

  @override
  _StoreListPageState createState() => _StoreListPageState();
}

class _StoreListPageState extends State<StoreListPage> {
  List<CommerceType> _types = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  String _currentSearch = "";
  List<Commerce> _stores = [];
  List<Commerce> _currentDisplayedStores = [];
  List<Commerce> _searchResults = [];
  CommerceType _currentType;

  @override
  void initState() {
    CommerceTypeModel().getAll().then((value) {
      if (this.mounted) {
        setState(() {
          _types = value;
          _currentType = null;
        });
      }
    });
    super.initState();
  }

  void _search(String value) {
    if (this.mounted) {
      setState(() {
        _currentSearch = value;
        _searchResults = _currentDisplayedStores;
        if (value != "") {
          setState(() {
            _searchResults = _currentDisplayedStores
                .where((element) => removeDiacritics(element.name.toLowerCase())
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
          _currentDisplayedStores =
              _stores.where((element) => element.typeId == type.id).toList();
        } else {
          _currentDisplayedStores = _stores;
        }
      });
    }
    this._search(this._currentSearch);
  }

  void _onRefresh() async {
    await CommerceModel().getAll().then((value) {
      if (this.mounted) {
        setState(() {
          _stores = value;
        });
      }
    });
    this._filterByType(_currentType);
    this._search(this._currentSearch);
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ThemeManager>(context);
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: _onRefresh,
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
