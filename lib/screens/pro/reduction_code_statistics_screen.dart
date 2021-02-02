import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../utils.dart';
import '../../components/app_bar.dart';
import '../../components/custom_dialog.dart';
import '../../model/reduction_code.dart';
import '../../model/reduction_code_used.dart';
import '../../model/database/reduction_code_used_model.dart';
import '../../services/size_config.dart';
import '../../services/theme_manager.dart';

class ProReductionCodeStatisticsScreen extends StatefulWidget {
  final List<ReductionCode> codes;
  ProReductionCodeStatisticsScreen({Key key, @required this.codes})
      : super(key: key);

  @override
  ProReductionCodeStatisticsScreenState createState() =>
      ProReductionCodeStatisticsScreenState();
}

class ProReductionCodeStatisticsScreenState
    extends State<ProReductionCodeStatisticsScreen> {
  ReductionCode _currentCodeDisplayed;
  List<ReductionCodeUsed> _used = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          actions: [Icon(Icons.info_outline)],
          actionsCallback: [() => _infoDialog(context)],
        ),
        body: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(20),
              vertical: getProportionateScreenHeight(10),
            ),
            child: Column(
              children: [
                Text(
                  "Statistiques",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: getProportionateScreenWidth(30),
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(30)),
                buildReductionCodeDropdownButton(),
                SizedBox(height: getProportionateScreenHeight(30)),
                (_currentCodeDisplayed != null
                    ? buildChartWidget(context)
                    : SizedBox()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildReductionCodeDropdownButton() {
    return new DropdownButtonFormField<ReductionCode>(
      isExpanded: true,
      value: _currentCodeDisplayed,
      hint: _currentCodeDisplayed != null
          ? Text(_currentCodeDisplayed.name)
          : Text("Sélectionnez un code de réduction"),
      items: widget.codes.map((ReductionCode value) {
        return new DropdownMenuItem(
          value: value,
          child: Text(value.name),
        );
      }).toList(),
      onChanged: (code) async {
        await ReductionCodeUsedModel()
            .where("reductionCodeId", isEqualTo: code.id)
            .then((value) {
          setState(() {
            value.sort((use1, use2) => use1.whenUsed.compareTo(use2.whenUsed));
            _currentCodeDisplayed = code;
            _used = value;
          });
        });
      },
    );
  }

  Widget buildChartWidget(BuildContext context) {
    bool isDarkModeEnabled = Provider.of<ThemeManager>(context).isDarkMode();
    var axis = charts.NumericAxisSpec(
        renderSpec: charts.GridlineRendererSpec(
      labelStyle: charts.TextStyleSpec(
          fontSize: 10,
          color: isDarkModeEnabled
              ? charts.MaterialPalette.white
              : charts.MaterialPalette.black),
    ));
    return SizedBox(
      height: 300,
      child: charts.BarChart(
        _getSeriesData(),
        animate: true,
        primaryMeasureAxis: axis,
        domainAxis: charts.OrdinalAxisSpec(
          showAxisLine: true,
          renderSpec: charts.SmallTickRendererSpec(
            labelRotation: 45,
            labelStyle: charts.TextStyleSpec(
                color: isDarkModeEnabled
                    ? charts.MaterialPalette.white
                    : charts.MaterialPalette.black),
          ),
        ),
      ),
    );
  }

  _infoDialog(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogBox(
            title: "Information",
            description:
                "Seul vous et les administrateurs ont accès à ces informations. Si vous n'arrivez pas à accès aux graphiques, vous pouvez contacter les administrateurs.",
            text: "OK",
            onPressed: () {
              Navigator.pop(context);
            },
          );
        });
  }

  List<charts.Series<ReductionCodeBarChartData, String>> _getSeriesData() {
    List<charts.Series<ReductionCodeBarChartData, String>> series = [
      charts.Series(
        id: "Utilisé/jour",
        seriesColor: charts.ColorUtil.fromDartColor(Colors.white),
        data: ReductionCodeBarChartData.extractData(_used),
        domainFn: (datum, index) => datum.date,
        measureFn: (datum, index) => datum.nb,
        colorFn: (datum, index) => charts.ColorUtil.fromDartColor(ternaryColor),
      ),
    ];
    return series;
  }
}

class ReductionCodeBarChartData {
  int nb = 1;
  final String date;

  ReductionCodeBarChartData(this.date);

  void increment() => this.nb++;

  static List<ReductionCodeBarChartData> extractData(
      List<ReductionCodeUsed> data) {
    Map<String, ReductionCodeBarChartData> results = {};
    for (ReductionCodeUsed datum in data) {
      String date =
          convertDatetimeToString(datum.whenUsed, full: true).substring(0, 5);
      if (results.containsKey(date)) {
        results[date].increment();
      } else {
        results[date] = ReductionCodeBarChartData(date);
      }
    }
    return results.values.toList();
  }
}
