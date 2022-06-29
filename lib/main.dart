import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  int _counter = 0;

  // List<String> shops = List<String>.generate(10000, (i) => 'Shop $i');

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<PostgrestResponse> data =
        Supabase.instance.client.from('shops').select('*').execute();
    return SafeArea(
        child: Scaffold(
            body: FutureBuilder(
                future: data,
                builder:
                    (context, AsyncSnapshot<PostgrestResponse> projectSnap) {
                  if (!projectSnap.hasData) {
                    return Container();
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
                })));
  }
}
