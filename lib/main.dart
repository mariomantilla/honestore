import 'package:flutter/material.dart';
import 'package:honestore/services/data_service.dart';
import 'package:honestore/widgets/search_bar.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '/services/location_services.dart';
import '/widgets/location_picker.dart';
import '/constants.dart';
import '/widgets/bottom_nav_bar.dart';
import 'models/shop.dart';
import 'widgets/shops_display.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
      authCallbackUrlHostname: 'login-callback', // optional
      debug: true // optional
      );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Honestore',
      theme: ThemeData(
          primarySwatch: CustomMaterialColors.primary,
          iconTheme: IconThemeData(color: CustomMaterialColors.primary[900])),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Shop>? shops;
  LatLng? location;
  String search = '';
  int selectedTab = 0;
  int displayMode = 0;

  void loadShops() async {
    List<Shop> newShops = await DataService.getShops(search, location);
    setState(() {
      shops = newShops;
    });
  }

  void getLocation() async {
    LatLng? newLocation = await LocationService().getLocation();
    setState(() {
      location = newLocation;
    });
  }

  @override
  void initState() {
    super.initState();
    loadShops();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
              LocationPicker(
                callback: getLocation,
                location: location,
              ),
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
    ));
  }
}
