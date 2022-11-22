import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:go_router/go_router.dart';
import 'package:honestore/constants.dart';
import 'package:honestore/helpers/url_helper.dart';
import 'package:honestore/models/shop.dart';
import 'package:honestore/services/data_service.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../services/analytics_service.dart';

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
            ? (shopList.isEmpty
                ? const Center(child: Text('Ups. Por aquí no hay nada.'))
                : IndexedStack(
                    index: index,
                    children: [
                      ListOfShops(shops: shopList),
                      MapOfShops(
                        shops: shopList,
                        location: location,
                      )
                    ],
                  ))
            : const Center(
                child: CircularProgressIndicator(),
              ));
  }
}

goToShop(context, Shop shop) {
  GoRouter.of(context).push('/shop/${shop.id}');
  Analytics.t("Open shop page", {"shop_id": shop.id});
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
        return Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Card(
            child: InkWell(
              onTap: () {
                goToShop(context, shop);
              },
              child: ListTile(
                leading: SizedBox(
                  width: 50,
                  height: 50,
                  child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                      child: Image.network(
                        DataService.getAssetUrl(shop.logoUuid),
                        fit: BoxFit.cover,
                      )),
                ),
                title: Text(shop.name),
                trailing: const Icon(Icons.arrow_forward_ios),
                subtitle: Text(
                  shop.description,
                  maxLines: 2,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class MapOfShops extends StatefulWidget {
  final List<Shop> shops;
  final LatLng? location;
  final bool showLocation;
  final bool showDirections;

  const MapOfShops(
      {Key? key,
      required this.shops,
      this.location,
      this.showLocation = true,
      this.showDirections = false})
      : super(key: key);

  @override
  State<MapOfShops> createState() => _MapOfShopsState();
}

class _MapOfShopsState extends State<MapOfShops> {
  final PopupController _popupLayerController = PopupController();
  LatLng? defaultCenter;

  Future<void> setDefaultLocation() async {
    final response = await http.get(Uri.parse('https://ipinfo.io/json'));
    LatLng defaultLocation;
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var data = jsonDecode(response.body);
      List<double> coords =
          data['loc'].split(",").map<double>((x) => double.parse(x)).toList();
      defaultLocation = LatLng(coords[0], coords[1]);
    } else {
      // If the server did not return a 200 OK response,
      defaultLocation = LatLng(defaultCenterLat, defaultCenterLng);
    }
    setState(() {
      defaultCenter = defaultLocation;
    });
  }

  @override
  void initState() {
    setDefaultLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.location == null && defaultCenter == null) {
      return const CircularProgressIndicator();
    }
    // LatLng defaultCenter = LatLng(defaultCenterLat, defaultCenterLng);
    return FlutterMap(
      options: MapOptions(
          center: widget.location ?? defaultCenter,
          zoom: defaultZoom,
          onTap: (_, __) => _popupLayerController.hideAllPopups()),
      nonRotatedChildren: [
        AttributionWidget.defaultWidget(
          source: 'OpenStreetMap & CartoDB Inc',
          onSourceTapped: () {},
        ),
      ],
      children: [
        TileLayer(
          userAgentPackageName: 'app.honestore.android',
          urlTemplate:
              'https://{s}.basemaps.cartocdn.com/rastertiles/voyager_nolabels/{z}/{x}/{y}{r}.png',
          subdomains: const ['a', 'b', 'c', 'b'],
        ),
        MarkerLayer(
            markers: (defaultCenter != null &&
                    widget.location != null &&
                    widget.showLocation)
                ? [
                    Marker(
                      point: widget.location ?? defaultCenter ?? LatLng(0, 0),
                      rotate: true,
                      builder: (_) => const Icon(
                        Icons.my_location,
                        size: 28,
                        color: Colors.blueGrey,
                        shadows: [
                          Shadow(
                              offset: Offset(0, 0),
                              blurRadius: 20.0,
                              color: Color(0xffffffff)),
                        ],
                      ),
                    )
                  ]
                : []),
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
                  showDirections: widget.showDirections,
                );
              }
              return Container();
            },
          ),
        ),
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
            Icons.location_on,
            size: 38,
            shadows: [
              Shadow(
                  offset: Offset(1, 1),
                  blurRadius: 10.0,
                  color: Color(0x88000000))
            ],
          ),
        );

  final Shop shop;
}

class MarkerPopUp extends StatelessWidget {
  const MarkerPopUp(
      {Key? key, required this.marker, this.showDirections = false})
      : super(key: key);

  final ShopMarker marker;
  final bool showDirections;

  @override
  Widget build(BuildContext context) {
    Shop shop = marker.shop;
    return SizedBox(
        width: 300,
        child: GestureDetector(
          onTap: () {
            goToShop(context, shop);
          },
          child: Card(
              child: ListTile(
            leading: Image.network(DataService.getAssetUrl(shop.logoUuid)),
            title: Text(shop.name),
            subtitle: Text(
              shop.description,
              maxLines: 2,
            ),
            trailing: showDirections
                ? IconButton(
                    icon: const Icon(Icons.directions),
                    onPressed: openUrlCallback(
                        "http://maps.google.com/maps?daddr=${shop.location.latitude},${shop.location.longitude}"),
                  )
                : null,
          )),
        ));
  }
}
