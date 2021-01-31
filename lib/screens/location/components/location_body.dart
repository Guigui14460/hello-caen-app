import 'package:flutter/material.dart';
import 'package:hello_caen/model/database/commerce_model.dart';

import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

class LocationBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 1, bottom: 1),
            ),
            Flexible(
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(49.1705, -0.3650),
                  zoom: 12.0,
                  boundsOptions: FitBoundsOptions(padding: EdgeInsets.all(0)),
                ),
                layers: [
                  TileLayerOptions(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c'],
                    // For example purposes. It is recommended to use
                    // TileProvider with a caching and retry strategy, like
                    // NetworkTileProvider or CachedNetworkTileProvider
                    //tileProvider: NonCachingNetworkTileProvider(),
                  ),
                  //MarkerLayerOptions(markers: markers)
                  new MarkerLayerOptions(
                    markers: [
                      new Marker(
                        width: 40.0,
                        height: 40.0,
                        point: new LatLng(49.1705, -0.3650),
                        builder: (ctx) => new Container(
                          child: Icon(Icons.place),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
