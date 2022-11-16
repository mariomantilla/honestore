import 'package:flutter/material.dart';
import 'package:honestore/constants.dart';
import 'package:honestore/models/shop.dart';
import 'package:honestore/services/analytics_service.dart';
import 'package:honestore/services/data_service.dart';
import 'package:honestore/services/location_services.dart';
import 'package:honestore/widgets/filters_bar.dart';
import 'package:honestore/widgets/search_bar.dart';
import 'package:honestore/widgets/shops_display.dart';
import 'package:latlong2/latlong.dart';

class SearchShopsTab extends StatefulWidget {
  const SearchShopsTab({Key? key}) : super(key: key);

  @override
  State<SearchShopsTab> createState() => SearchShopsTabState();
}

class SearchShopsTabState extends State<SearchShopsTab> {
  List<Shop>? shops;

  SortByOptions sorting = SortByOptions.newest;
  LatLng? location;
  String search = '';

  int displayMode = 0;

  void loadShops() async {
    List<Shop> newShops = await DataService.getShops(search, location, sorting);
    setState(() {
      shops = newShops;
    });
  }

  void getLocation() async {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Actualizando ubicación..."),
    ));
    LatLng? newLocation = await LocationService().getLocation();
    setState(() {
      location = newLocation;
    });
    loadShops();
  }

  @override
  void initState() {
    super.initState();
    loadShops();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchBar(
          search: search,
          searchCallback: (String text) {
            setState(() {
              search = text;
            });
          },
          viewMode: displayMode,
          mapCallback: () {
            int newMode = displayMode == 0 ? 1 : 0;
            setState(() {
              displayMode = newMode;
            });
            MixpanelManager.instance?.track("Switched search mode",
                properties: {"newMode": newMode});
          },
          updateResults: loadShops,
        ),
        FiltersBar(
            locationCallback: getLocation,
            location: location,
            sortingCallback: (newSorting) {
              setState(() {
                sorting = newSorting;
              });
              loadShops();
            },
            sorting: sorting),
        ShopsDisplay(
          shops: shops,
          index: displayMode,
          location: location,
        )
      ],
    );
  }
}
