import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import "popup.dart";
import '../location_screen.dart';
import '../../../model/commerce.dart';
import '../../../services/location_service.dart';
import '../../../services/user_manager.dart';

class LocationStoreList extends State<MapPage> {
  final PopupController _popupLayerController = PopupController();

  List<Marker> _stores = [];
  List<Marker> _favoriteStores = [];
  Marker _userLocation;

  @override
  Widget build(BuildContext context) {
    UserManager userManager = Provider.of<UserManager>(context);
    LocationService locationService = Provider.of<LocationService>(context);
    locationService.addOnChangedFunction((LocationData data) {
      if (this.mounted) {
        setState(() {
          _userLocation = Marker(
            width: 30,
            height: 30,
            point: LatLng(data.latitude, data.longitude),
            anchorPos: AnchorPos.align(AnchorAlign.top),
            builder: (ctx) => Icon(Icons.place, color: Colors.red, size: 30),
          );
        });
      }
    });
    if (this.mounted) {
      setState(() {
        for (Commerce m in widget.getCommerces()) {
          if (userManager.isLoggedIn() &&
              userManager
                  .getLoggedInUser()
                  .favoriteCommerceIds
                  .contains(m.id)) {
            _favoriteStores.add(
              MarketMarker(
                color: Colors.blue,
                market: Market(
                  name: m.name,
                  imagePath: m.imageLink,
                  lat: m.latitude,
                  long: m.longitude,
                  open: "Ouvert",
                  commerce: m,
                ),
              ),
            );
          } else {
            _stores.add(
              MarketMarker(
                color: Colors.black,
                market: Market(
                  name: m.name,
                  imagePath: m.imageLink,
                  lat: m.latitude,
                  long: m.longitude,
                  open: "Ouvert",
                  commerce: m,
                ),
              ),
            );
          }
        }
      });
    }
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          plugins: <MapPlugin>[PopupMarkerPlugin()],
          center: LatLng(49.1705, -0.3650),
          zoom: 12.0,
          minZoom: 12.0,
          slideOnBoundaries: true,
          swPanBoundary: LatLng(49.0705, -0.4650),
          nePanBoundary: LatLng(49.2705, -0.2650),
          interactiveFlags: InteractiveFlag.all - InteractiveFlag.rotate,
          onTap: (_) => _popupLayerController.hidePopup(),
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: <String>['a', 'b', 'c'],
          ),
          PopupMarkerLayerOptions(
            markers: _stores +
                _favoriteStores +
                (locationService.isEnabled() && _userLocation != null
                    ? [_userLocation]
                    : []),
            popupSnap: PopupSnap.top,
            popupController: _popupLayerController,
            popupBuilder: (ctx, Marker marker) {
              if (marker is MarketMarker) {
                return MarketMarkerPopup(market: marker.market);
              }
              return Card(child: const Text('Not a market'));
            },
          ),
        ],
      ),
    );
  }
}
