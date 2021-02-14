import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import '../../generated_screens/generated_store_screen.dart';
import '../../../constants.dart';
import '../../../model/commerce.dart';

class Market {
  static const double size = 25;

  Market(
      {this.name,
      this.imagePath,
      this.lat,
      this.long,
      this.open,
      this.commerce});

  final String name;
  final String imagePath;
  final double lat;
  final double long;
  final String open;
  final Commerce commerce;
}

class MarketMarker extends Marker {
  final Color color;
  final Market market;

  MarketMarker({
    @required this.market,
    this.color = primaryColor,
  }) : super(
          anchorPos: AnchorPos.align(AnchorAlign.top),
          height: Market.size,
          width: Market.size,
          point: LatLng(market.lat, market.long),
          builder: (BuildContext ctx) => IconTheme(
            data: IconThemeData(color: color),
            child: Icon(Icons.place),
          ),
        );
}

class MarketMarkerPopup extends StatelessWidget {
  const MarketMarkerPopup({Key key, this.market}) : super(key: key);
  final Market market;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Hero(
          tag: market.commerce.id,
          child: Image.network(
            market.imagePath,
            height: 50,
          ),
        ),
        title: Text(
          market.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(market.open),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GeneratedStoreScreen(data: market.commerce),
          ),
        ),
      ),
    );
  }
}
