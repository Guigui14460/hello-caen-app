import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong/latlong.dart';

class Market {
  static const double size = 25;

  Market({this.name, this.imagePath, this.lat, this.long});

  final String name;
  final String imagePath;
  final double lat;
  final double long;
}

class MarketMarker extends Marker {
  MarketMarker({@required this.market})
      : super(
          anchorPos: AnchorPos.align(AnchorAlign.top),
          height: Market.size,
          width: Market.size,
          point: LatLng(market.lat, market.long),
          builder: (BuildContext ctx) => Icon(Icons.place),
        );

  final Market market;
}

class MarketMarkerPopup extends StatelessWidget {
  const MarketMarkerPopup({Key key, this.market}) : super(key: key);
  final Market market;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.network(market.imagePath, width: 200),
            Text(market.name),
            // Text('${market.lat}-${market.long}'),
          ],
        ),
      ),
    );
  }
}
