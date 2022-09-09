import 'package:flutter/material.dart';
import 'package:honestore/models/shop.dart';
import 'package:honestore/services/data_service.dart';

import 'constants.dart';
import 'pages/home_page.dart';
import 'pages/shop_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DataService.initialise();
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
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case ShopPage.routeName:
            final args = settings.arguments as Shop;
            return MaterialPageRoute(builder: (context) => ShopPage(args));
        }
        return MaterialPageRoute(builder: (context) => const HomePage());
        // String? route = settings.name;
        // if (route != null && route != '/') {
        //   var uri = Uri.parse(route);
        //   switch (uri.pathSegments.first) {
        //     case 'shops':
        //       int? id = int.tryParse(uri.pathSegments[1]);
        //       if (id != null) {
        //         return MaterialPageRoute(builder: (context) => ShopPage(id));
        //       }
        //   }
        // }
        // return MaterialPageRoute(builder: (context) => const HomePage());
      },
      /*routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          '/': (context) => const HomePage(),
          // When navigating to the "/second" route, build the SecondScreen widget.
          '/shop': (context) => const ShopPage(),
        }*/
    );
  }
}
