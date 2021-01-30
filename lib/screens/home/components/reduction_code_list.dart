import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../constants.dart';
import '../../../model/commerce_type.dart';
import '../../../model/reduction_code.dart';
import '../../../model/reduction_code_used.dart';
import '../../../model/database/commerce_model.dart';
import '../../../model/database/commerce_type_model.dart';
import '../../../model/database/reduction_code_model.dart';
import '../../../model/database/reduction_code_used_model.dart';
import '../../../screens/reduction_code_detail/reduction_code_detail_screen.dart';
import '../../../services/size_config.dart';
import '../../../services/theme_manager.dart';

class ReductionCodeListPage extends StatefulWidget {
  ReductionCodeListPage({Key key}) : super(key: key);

  @override
  _ReductionCodeListPageState createState() => _ReductionCodeListPageState();
}

class _ReductionCodeListPageState extends State<ReductionCodeListPage> {
  List<CommerceType> _types = [];
  Map<CommerceType, List<ReductionCode>> _codes = {};
  Map<ReductionCode, List<ReductionCodeUsed>> _used = {};
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  @override
  void initState() {
    CommerceTypeModel().getAll().then((value) {
      _types = value;
    });
    super.initState();
  }

  void _onRefresh() async {
    DateTime now = DateTime.now();
    for (CommerceType type in _types) {
      await CommerceModel().where("type", isEqualTo: type.id).then((commerces) {
        List<ReductionCode> codesByType = [];
        commerces.forEach((commerce) async {
          await ReductionCodeModel()
              .where("commerce", isEqualTo: commerce.id)
              .then((codes) async {
            codes = codes.where((e) => e.endDate.isAfter(now)).toList();
            codesByType.addAll(codes);
            for (ReductionCode code in codes) {
              await ReductionCodeUsedModel()
                  .where("reductionCodeId", isEqualTo: code.id)
                  .then((value) {
                if (this.mounted) {
                  setState(() {
                    _used[code] = value;
                  });
                }
              });
            }
          });
        });
        if (this.mounted) {
          setState(() {
            codesByType
                .sort((code1, code2) => code1.endDate.compareTo(code2.endDate));
            _codes[type] = codesByType;
          });
        }
      });
    }
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    if (this.mounted) {
      setState(() {
        _codes = {};
        _used = {};
      });
    }
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ThemeManager>(context).getTheme();
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      enablePullDown: true,
      header: MaterialClassicHeader(
        height: 20,
        color: primaryColor,
      ),
      footer: ClassicFooter(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: getProportionateScreenHeight(10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Bons plans",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: getProportionateScreenWidth(30)),
              ),
            ],
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          (_types.length == _codes.keys.length
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    _types.length,
                    (int index) {
                      return _buildCodeCategoryWidget(_types[index]);
                    },
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Aucune données trouvées",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: getProportionateScreenWidth(18.5),
                      ),
                    ),
                  ],
                )),
        ],
      ),
    );
  }

  Widget _buildCodeCategoryWidget(CommerceType type) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            type.name,
            style: TextStyle(
              fontSize: getProportionateScreenWidth(18),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(6)),
          (_codes[type].length == 0
              ? Text("Aucun code de réduction disponible pour le moment")
              : _buildCodesScrollWidget(_codes[type])),
          SizedBox(height: getProportionateScreenHeight(45)),
        ],
      ),
    );
  }

  Widget _buildCodesScrollWidget(List<ReductionCode> codes) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          codes.length,
          (index) => _buildCodeWidget(codes[index],
              isLastIndex: index == codes.length - 1),
        ),
      ),
    );
  }

  Widget _buildCodeWidget(ReductionCode code, {bool isLastIndex = false}) {
    if (_used[code] == null) {
      return SizedBox();
    }
    int codeAvailableLeft = code.maxAvailableCodes - _used[code].length;

    return Padding(
      padding: EdgeInsets.only(
          right: getProportionateScreenWidth(isLastIndex ? 0 : 20)),
      child: GestureDetector(
        onTap: () => Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => ReductionCodeDetailScreen(code: code))),
        child: SizedBox(
          width: getProportionateScreenWidth(200),
          height: getProportionateScreenHeight(100),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      primaryColor.withOpacity(0.95),
                      primaryColor.withOpacity(0.75),
                    ]),
              ),
              child: (codeAvailableLeft == 0
                  ? Banner(
                      message: "Épuisé",
                      location: BannerLocation.topEnd,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(15),
                          vertical: getProportionateScreenWidth(10),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                code.name,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: getProportionateScreenWidth(18),
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 3),
                              Text(
                                (codeAvailableLeft >
                                            (code.maxAvailableCodes * 0.2)
                                                .ceil() ||
                                        codeAvailableLeft == 0
                                    ? "$codeAvailableLeft codes dispo"
                                    : "$codeAvailableLeft codes encore dispo"),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: (codeAvailableLeft <=
                                          (code.maxAvailableCodes * 0.2).ceil()
                                      ? Colors.red
                                      : ternaryColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(15),
                        vertical: getProportionateScreenWidth(10),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              code.name,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: getProportionateScreenWidth(18),
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 3),
                            Text(
                              (codeAvailableLeft >
                                          (code.maxAvailableCodes * 0.2)
                                              .ceil() ||
                                      codeAvailableLeft == 0
                                  ? "$codeAvailableLeft codes dispo"
                                  : "$codeAvailableLeft codes encore dispo"),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: (codeAvailableLeft <=
                                        (code.maxAvailableCodes * 0.2).ceil()
                                    ? Colors.red
                                    : ternaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}
