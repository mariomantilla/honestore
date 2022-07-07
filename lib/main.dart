import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:location/location.dart';

const Map<int, Color> color = {
  50: Color.fromRGBO(251, 113, 104, .1),
  100: Color.fromRGBO(251, 113, 104, .2),
  200: Color.fromRGBO(251, 113, 104, .3),
  300: Color.fromRGBO(251, 113, 104, .4),
  400: Color.fromRGBO(251, 113, 104, .5),
  500: Color.fromRGBO(251, 113, 104, .6),
  600: Color.fromRGBO(251, 113, 104, .7),
  700: Color.fromRGBO(251, 113, 104, .8),
  800: Color.fromRGBO(251, 113, 104, .9),
  900: Color.fromRGBO(251, 113, 104, 1),
};

class CustomColors {
  static const primary = MaterialColor(0x00fb7168, color);
}

const supabaseUrl = "https://tbhtpkmrwtznqzsjlfmo.supabase.co";
const supabaseKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRiaHRwa21yd3R6bnF6c2psZm1vIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NTY1MjU1MTUsImV4cCI6MTk3MjEwMTUxNX0.1udAz1lLiqT4bmRF-SZlSNOgng2pCZqwkMAXHb07Ch4';

class LatLng {
  double lat;
  double lng;

  LatLng(this.lat, this.lng);
}

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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Honestore',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: CustomColors.primary,
          iconTheme: IconThemeData(color: CustomColors.primary[900])),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Location locationHelper = Location();
  late Future<PostgrestResponse> shops;
  LatLng? location;
  String search = '';
  int selectedTab = 0;

  void loadShops() {
    setState(() {
      String rpc = 'search_shops';
      Map<String, String> params = {'search': search};
      if (location != null) {
        rpc = 'nearby_shops';
        params['location'] = 'Point(${location?.lat} ${location?.lng})';
      }
      shops = Supabase.instance.client.rpc(rpc, params: params).execute();
    });
  }

  void getLocation() async {
    bool serviceEnabled = await locationHelper.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationHelper.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    PermissionStatus permissionGranted = await locationHelper.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationHelper.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    LocationData locationData = await locationHelper.getLocation();

    setState(() {
      location =
          LatLng(locationData.latitude ?? 0, locationData.longitude ?? 0);
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
      /*title: TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(),
            hintText: 'Buscar tienda',
          ),
          onChanged: (String text) {
            search = text;
          },
          onEditingComplete: () {
            loadShops();
          },
        ),*/

      body: IndexedStack(
        index: selectedTab,
        children: [
          Column(
            children: [
              Padding(
                  padding:
                      EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 10),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 1,
                            color: Colors.black /*fromRGBO(251, 113, 104, 1)*/),
                        borderRadius: BorderRadius.circular(5)),
                    child: Row(children: [
                      Padding(
                          padding: EdgeInsets.all(15),
                          child: Icon(
                            Icons.search,
                            color: Colors.black,
                          )),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            search != '' ? search : 'Buscar tienda...',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.normal),
                          ),
                          location != null
                              ? Text(
                                  'cerca de mi',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                )
                              : Container(),
                        ],
                      )),
                      Padding(
                          padding: EdgeInsets.all(15),
                          child: Icon(Icons.map, color: Colors.black)),
                    ]),
                  )),
              Padding(
                padding: const EdgeInsets.all(3),
                child: OutlinedButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromRGBO(251, 113, 104, 1)),
                    ),
                    onPressed: getLocation,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.location_on),
                        location != null
                            ? const Text('Actualizar Ubicación')
                            : const Text('Localizar')
                      ],
                    )),
              ),
              Expanded(
                  child: FutureBuilder(
                      future: shops,
                      builder: (context,
                          AsyncSnapshot<PostgrestResponse> projectSnap) {
                        if (!projectSnap.hasData) {
                          return Container();
                        }
                        if (projectSnap.hasError) {
                          return Container(
                              child: Text(projectSnap.error?.toString() ?? ''));
                        }

                        List<dynamic> shops = projectSnap.data?.data;
                        return ListView.builder(
                          itemCount: shops.length,
                          itemBuilder: (context, index) {
                            dynamic shop = shops[index];
                            return Card(
                                child: ListTile(
                              leading: Image.network(
                                  'https://tbhtpkmrwtznqzsjlfmo.supabase.co/storage/v1/object/public/shops-content/${shop['logo']}.jpg'),
                              title: Text(shop['name']),
                              subtitle: Text(shop['description']),
                            ));
                          },
                        );
                      }))
            ],
          ),
          Container(),
          Container()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedTab,
          onTap: (int i) {
            setState(() {
              selectedTab = i;
            });
          },
          selectedItemColor: CustomColors.primary[900],
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.explore), label: 'Explorar'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favs'),
            BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'Más')
          ]),
      /*Padding(
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: ),
              Expanded(
                  child:
                      IconButton(onPressed: () {}, icon: Icon(Icons.explore))),
              Expanded(
                  child:
                      IconButton(onPressed: () {}, icon: Icon(Icons.explore)))
            ],
          )),*/
      floatingActionButton: FloatingActionButton(
          onPressed: loadShops, child: const Icon(Icons.refresh)),
    ));
  }
}
