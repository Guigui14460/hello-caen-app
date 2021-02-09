import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

// import 'popup.dart';
import '../location_screen.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import "../../../model/database/commerce_model.dart";
import "popup.dart";

class LocationStoreList extends State<MapPage> {
  final PopupController _popupLayerController = PopupController();
  @override
  Widget build(BuildContext context) {
    print("salut toi");
    List<Marker> locationList = [];
    locationList.add(
      MarketMarker(
        market: Market(
          name: 'test marker',
          imagePath: 'assets/images/test.jpg',
          lat: 49.1705,
          long: -0.3650,
        ),
      ),
    );

    SafeArea(
      child: FutureBuilder(
        future: CommerceModel().getAll(),
        builder: (context, snapshot) {
          print("debut future");
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              print(
                  "--------------------------------------------------------------");
              print(snapshot.data);
              print(
                  "--------------------------------------------------------------");

              for (var data in snapshot.data) {
                print("lat");
                print(data.latitude);
                print("long");
                print(data.longitude);

                locationList.add(
                  MarketMarker(
                    market: Market(
                      name: 'test marker',
                      imagePath: 'assets/images/test.jpg',
                      lat: 49.1705,
                      long: -0.3650,
                    ),
                  ),
                );
              }
            }

            if (snapshot.hasError) {
              return Text("Snapshot Has error");
            } else {
              return Text("No Commerce Found");
            }
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
    print("fin future");
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          plugins: <MapPlugin>[PopupMarkerPlugin()],
          // center: LatLng(0.0, 0.0),
          center: LatLng(49.1705, -0.3650),
          zoom: 12.0,
          interactive: true,
          onTap: (_) => _popupLayerController.hidePopup(),
          // zoom: 1.0,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: <String>['a', 'b', 'c'],
          ),
          // MarkerLayerOptions(
          //   markers: [
          //     new Marker(
          //       width: 40.0,
          //       height: 40.0,
          //       point: new LatLng(49.1705, -0.3650),
          //       builder: (ctx) => new Container(
          //         child: Icon(Icons.place),
          //       ),
          //     ),
          //   ],
          // ),
          PopupMarkerLayerOptions(
              markers: locationList,
              popupSnap: PopupSnap.top,
              popupController: _popupLayerController,
              popupBuilder: (_, Marker marker) {
                if (marker is MarketMarker) {
                  return MarketMarkerPopup(market: marker.market);
                }
                return Card(child: const Text('Not a market'));
              })
        ],
      ),
    );
  }
}
