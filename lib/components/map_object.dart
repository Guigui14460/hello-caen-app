import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';

import '../constants.dart';
import '../helper/zoombuttons_plugin.dart';
import '../services/size_config.dart';

// ignore: must_be_immutable
class MapObject extends StatefulWidget {
  final double height;
  final double initialZoom;
  final LatLng initialLocation;
  final bool includeZoomButtons;
  final double maxZoom;
  LatLng centerLocation;
  double markerSize;
  bool slideOnBoundaries;
  void Function(LatLng) onTap;

  MapObject({
    Key key,
    @required this.initialZoom,
    @required this.maxZoom,
    LatLng centerLocation,
    this.height = double.infinity,
    this.initialLocation,
    this.includeZoomButtons = true,
    this.markerSize = 30,
    this.onTap,
    this.slideOnBoundaries = false,
  }) {
    this.centerLocation =
        centerLocation == null ? caenLocation : centerLocation;
  }

  @override
  _MapObjectState createState() => _MapObjectState();
}

class _MapObjectState extends State<MapObject> {
  LatLng _location;

  @override
  void initState() {
    setState(() {
      _location = widget.initialLocation;
    });
    super.initState();
  }

  void _handleTap(LatLng latlng) {
    setState(() {
      _location = latlng;
    });
    widget.onTap(latlng);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getProportionateScreenHeight(widget.height),
      child: FlutterMap(
        options: MapOptions(
          center: widget.centerLocation,
          zoom: widget.initialZoom,
          minZoom: widget.initialZoom,
          maxZoom: widget.maxZoom,
          boundsOptions: FitBoundsOptions(padding: EdgeInsets.zero),
          slideOnBoundaries: widget.slideOnBoundaries,
          swPanBoundary: widget.slideOnBoundaries
              ? LatLng(widget.centerLocation.latitude - 0.1,
                  widget.centerLocation.longitude - 0.1)
              : null,
          nePanBoundary: widget.slideOnBoundaries
              ? LatLng(widget.centerLocation.latitude + 0.1,
                  widget.centerLocation.longitude + 0.1)
              : null,
          plugins: [
            (widget.includeZoomButtons ? ZoomButtonsPlugin() : null),
          ],
          onTap: _handleTap,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          new MarkerLayerOptions(
            markers: [
              new Marker(
                width: 30,
                height: 30,
                point: _location,
                anchorPos: AnchorPos.align(AnchorAlign.top),
                builder: (ctx) =>
                    Icon(Icons.place, color: Colors.red, size: 30),
              ),
            ],
          ),
        ],
        nonRotatedLayers: [
          ZoomButtonsPluginOption(
            minZoom: widget.initialZoom.toInt(),
            maxZoom: widget.maxZoom.toInt(),
          ),
        ],
      ),
    );
  }
}
