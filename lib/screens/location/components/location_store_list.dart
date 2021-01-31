import 'package:flutter/material.dart';
import 'package:hello_caen/components/caller_row.dart';

import "../../../model/database/commerce_model.dart";

import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

class LocationStoreList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    return SafeArea(
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
                  List<Marker> locationList = [];
                  List<String> slice = [];

                  for (var data in snapshot.data) {
                    slice = data.location.split(",");

                    print(slice);
                    print("object");
                    print(double.parse(slice[0]));
                    print(double.parse(slice[1]));

                    if (data.location != '') {
                      slice = data.location.split(",");
                      locationList.add(
                        new Marker(
                          width: 40.0,
                          height: 40.0,
                          point: new LatLng(
                              double.parse(slice[0]), double.parse(slice[1])),
                          builder: (ctx) => new Container(
                            child: new FlutterLogo(),
                          ),
                        ),
                      );
                    } else {
                      print("location vide : ");
                      print(data.name);
                    }
                  }

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
                                // center: LatLng(0.0, 0.0),
                                center: LatLng(49.1705, -0.3650),
                                zoom: 12.0,
                                // zoom: 1.0,
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
                                MarkerLayerOptions(markers: locationList),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Text("Snapshot Has error");
                } else {
                  return Text("No Commerce Found");
                }
              } else {
                return CircularProgressIndicator();
              }
            }));
  }
}
