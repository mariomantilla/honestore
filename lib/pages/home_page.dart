import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../constants.dart';
import '../models/shop.dart';
import '../services/data_service.dart';
import '../services/location_services.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/filters_bar.dart';
import '../widgets/search_bar.dart';
import '../widgets/shops_display.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Shop>? shops;

  SortByOptions sorting = SortByOptions.newest;
  LatLng? location;
  String search = '';

  int selectedTab = 0;
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
    return SafeArea(
        child: GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: IndexedStack(
          index: selectedTab,
          children: [
            Column(
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
                    setState(() {
                      displayMode = displayMode == 0 ? 1 : 0;
                    });
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
                    },
                    sorting: sorting),
                ShopsDisplay(
                  shops: shops,
                  index: displayMode,
                  location: location,
                )
              ],
            ),
            Container(),
            Container()
          ],
        ),
        bottomNavigationBar: BottomNavBar(
          selectedTab: selectedTab,
          callback: (int i) {
            setState(() {
              selectedTab = i;
            });
          },
        ),
      ),
    ));
  }
}
