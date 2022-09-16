import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:honestore/constants.dart';
import 'package:honestore/models/shop.dart';
import 'package:honestore/pages/shop_page.dart';
import 'package:honestore/services/data_service.dart';
import 'package:latlong2/latlong.dart';
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

goToShop(context, Shop shop) {
  Navigator.pushNamed(context, ShopPage.routeName, arguments: shop);
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

  const MapOfShops(
      {Key? key, required this.shops, this.location, this.showLocation = true})
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
            urlTemplate:
                'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
            subdomains: ['a', 'b', 'c'],
          ),
        ),
        MarkerLayerWidget(
            options: MarkerLayerOptions(
                markers: (widget.location != null && widget.showLocation)
                    ? [
                        Marker(
                          point: widget.location ?? defaultCenter,
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
                    : [])),
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
            size: 32,
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
  const MarkerPopUp({Key? key, required this.marker}) : super(key: key);

  final ShopMarker marker;

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
          )),
        ));
  }
}
