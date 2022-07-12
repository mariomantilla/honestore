import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:honestore/constants.dart';
import 'package:honestore/models/shop.dart';
import 'package:honestore/services/data_service.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_map/flutter_map.dart';

class ShopsDisplay extends StatelessWidget {
  const ShopsDisplay(
      {Key? key, required this.shops, required this.index, this.location})
      : super(key: key);

  final List<Shop>? shops;
  final int index;
  final LatLng? location;

  @override
  Widget build(BuildContext context) {
    List<Shop>? shopList = shops;
    return Expanded(
        child: shopList != null
            ? IndexedStack(
                index: index,
                children: [
                  ListOfShops(shops: shopList),
                  MapOfShops(
                    shops: shopList,
                    location: location,
                  )
                ],
              )
            : const Center(
                child: CircularProgressIndicator(),
              ));
  }
}

class ListOfShops extends StatelessWidget {
  const ListOfShops({Key? key, required this.shops}) : super(key: key);

  final List<Shop> shops;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: shops.length,
      itemBuilder: (context, index) {
        Shop shop = shops[index];
        return Card(
            child: ListTile(
          leading: Image.network(DataService.getAssetUrl(shop.logoUuid)),
          title: Text(shop.name),
          subtitle: Text(shop.description),
        ));
      },
    );
  }
}

class MapOfShops extends StatefulWidget {
  final List<Shop> shops;
  final LatLng? location;

  const MapOfShops({Key? key, required this.shops, this.location})
      : super(key: key);

  @override
  State<MapOfShops> createState() => _MapOfShopsState();
}

class _MapOfShopsState extends State<MapOfShops> {
  final PopupController _popupLayerController = PopupController();

  @override
  Widget build(BuildContext context) {
    LatLng defaultCenter = LatLng(defaultCenterLat, defaultCenterLng);
    return FlutterMap(
      options: MapOptions(
          center: widget.location ?? defaultCenter,
          zoom: defaultZoom,
          onTap: (_, __) => _popupLayerController.hideAllPopups()),
      children: [
        TileLayerWidget(
          options: TileLayerOptions(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
        ),
        PopupMarkerLayerWidget(
          options: PopupMarkerLayerOptions(
            popupController: _popupLayerController,
            markers: widget.shops.map((s) => ShopMarker(shop: s)).toList(),
            markerRotateAlignment:
                PopupMarkerLayerOptions.rotationAlignmentFor(AnchorAlign.top),
            popupBuilder: (BuildContext context, Marker marker) {
              if (marker is ShopMarker) {
                return MarkerPopUp(
                  marker: marker,
                );
              }
              return Container();
            },
          ),
        ),
        MarkerLayerWidget(
            options: MarkerLayerOptions(
                markers: widget.location != null
                    ? [
                        Marker(
                            point: widget.location ?? defaultCenter,
                            rotate: true,
                            builder: (_) => const Icon(
                                  Icons.run_circle_rounded,
                                  color: Colors.blue,
                                  shadows: [
                                    Shadow(
                                        offset: Offset(1, 1),
                                        blurRadius: 10.0,
                                        color: Color(0xffffffff))
                                  ],
                                ))
                      ]
                    : []))
      ],
    );
  }
}

class ShopMarker extends Marker {
  ShopMarker({required this.shop})
      : super(
          anchorPos: AnchorPos.align(AnchorAlign.top),
          point: LatLng(shop.location.latitude, shop.location.longitude),
          builder: (BuildContext ctx) => const Icon(
            Icons.shopping_bag_rounded,
            shadows: [
              Shadow(
                  offset: Offset(1, 1),
                  blurRadius: 10.0,
                  color: Color(0xffffffff))
            ],
          ),
        );

  final Shop shop;
}

class MarkerPopUp extends StatelessWidget {
  const MarkerPopUp({Key? key, required this.marker}) : super(key: key);

  final ShopMarker marker;

  @override
  Widget build(BuildContext context) {
    Shop shop = marker.shop;
    return SizedBox(
        width: 300,
        child: Card(
            child: ListTile(
          leading: Image.network(DataService.getAssetUrl(shop.logoUuid)),
          title: Text(shop.name),
          subtitle: Text(shop.description),
        )));
  }
}
