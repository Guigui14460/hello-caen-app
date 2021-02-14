import 'package:flutter/material.dart';

import 'components/location_store_list.dart';
import '../../model/commerce.dart';

class MapPage extends StatefulWidget {
  final List<Commerce> Function() getCommerces;
  final Map<Commerce, double> Function() getCommerceDistances;

  MapPage({
    Key key,
    @required this.getCommerces,
    @required this.getCommerceDistances,
  }) : super(key: key);

  @override
  LocationStoreList createState() => LocationStoreList();
}
