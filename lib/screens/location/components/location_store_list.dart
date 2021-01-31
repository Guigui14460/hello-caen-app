import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

// import 'popup.dart';
import '../location_screen.dart';
import '../../../flutter_map_marker_popup/flutter_map_marker_popup.dart';
import "../../../model/database/commerce_model.dart";

class LocationStoreList extends State<MapPage> {
  final PopupController _popupLayerController = PopupController();
  @override
  Widget build(BuildContext context) {
    List<Marker> locationList = [];
    SafeArea(
      child: FutureBuilder(
        future: CommerceModel().getAll(),
        builder: (context, snapshot) {
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
                  new Marker(
                    width: 40.0,
                    height: 40.0,
                    point: new LatLng(data.latitude, data.longitude),
                    builder: (ctx) => Icon(Icons.location_on),
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

    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          // plugins: <MapPlugin>[PopupMarkerPlugin()],
          // center: LatLng(0.0, 0.0),
          center: LatLng(49.1705, -0.3650),
          zoom: 12.0,
          interactive: true,
          // onTap: (_) => _popupLayerController.hidePopup(),
          // zoom: 1.0,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: <String>['a', 'b', 'c'],
          ),
          MarkerLayerOptions(
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
          // PopupMarkerLayerOptions(
          //   markers: locationList,
          //   //popupSnap: PopupSnap.top,
          //   popupController: _popupLayerController,
          //   popupBuilder: (BuildContext _, Marker marker) =>
          //       ExamplePopup(marker),
          // )
        ],
      ),
    );
  }
}
