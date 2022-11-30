import 'package:flutter/material.dart';
import 'package:honestore/models/app_state.dart';
import 'package:honestore/services/analytics_service.dart';
import 'package:honestore/services/data_service.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'constants.dart';
import 'pages/home_page.dart';
import 'pages/shop_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DataService.initialise();
  await Analytics.init();
  runApp(
      ChangeNotifierProvider(create: (context) => AppState(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Honestore',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: CustomMaterialColors.primary,
          iconTheme: IconThemeData(color: CustomMaterialColors.primary[900])),
      routerConfig: _router,
    );
  }

  final GoRouter _router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const HomePage();
        },
      ),
      GoRoute(
        path: '/shop/:id',
        builder: (BuildContext context, GoRouterState state) {
          int id = int.parse(state.params['id'] ?? '');
          return ShopPage(id);
        },
      )
    ],
    errorBuilder: (context, state) => const HomePage(),
  );
}
