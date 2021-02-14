import 'package:flutter/material.dart';

import 'components/location_store_list.dart';
import '../../helper/rating_and_comment_count.dart';
import '../../model/commerce.dart';

class MapPage extends StatefulWidget {
  final List<Commerce> Function() getCommerces;
  final Map<Commerce, double> Function() getCommerceDistances;
  final Map<Commerce, RatingAndCommentCount> Function() getRatings;

  MapPage({
    Key key,
    @required this.getCommerces,
    @required this.getCommerceDistances,
    @required this.getRatings,
  }) : super(key: key);

  @override
  LocationStoreList createState() => LocationStoreList();
}
