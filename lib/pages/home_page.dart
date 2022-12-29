import 'dart:async';

import 'package:flutter/material.dart';
import 'package:honestore/pages/articles_tab.dart';
import 'package:honestore/pages/favourites_tab.dart';
import 'package:honestore/pages/more_tab.dart';
import 'package:honestore/pages/search_shops_tab.dart';
import 'package:honestore/services/analytics_service.dart';
import 'package:honestore/services/error_service.dart';
import 'package:honestore/widgets/bottom_nav_bar.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:honestore/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedTab = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  AppUpdateInfo? _updateInfo;
  bool flexibleUpdateAvailable = false;

  @override
  void initState() {
    Timer.periodic(const Duration(minutes: 15), (timer) {
      checkForUpdate();
    });
    Timer(const Duration(seconds: 5), () {
      checkForUpdate();
    });
    super.initState();
  }

  void performFlaxibleUpdateDownload() async {
    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
    try {
      await InAppUpdate.startFlexibleUpdate();
      setState(() {
        flexibleUpdateAvailable = true;
      });
      askForInstallUpdate();
    } catch (error) {
      debugPrint(error.toString());
      ErrorService.show(
          _scaffoldKey.currentContext, 'Error descargando actualizaciones...');
    }
  }

  MaterialBanner getUpdateBanner(ready, callback) {
    String title = ready
        ? "Actualización lista para instalar"
        : "Hay una actualización disponible";
    String goLabel = ready ? "Instalar" : "Descargar";

    Widget cancelAction = TextButton(
      onPressed: () =>
          ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
      child: const Text('Más tarde'),
    );
    Widget goButton = ElevatedButton(onPressed: callback, child: Text(goLabel));

    List<Widget> actions = ready ? [goButton] : [cancelAction, goButton];

    return MaterialBanner(content: Text(title), actions: actions);
  }

  void askForUpdate() {
    MaterialBanner banner =
        getUpdateBanner(false, performFlaxibleUpdateDownload);
    ScaffoldMessenger.of(context).showMaterialBanner(banner);
  }

  void askForInstallUpdate() {
    MaterialBanner banner = getUpdateBanner(true, () async {
      ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
      InAppUpdate.completeFlexibleUpdate().then((_) {
        context.showSnackBar(message: 'Actualización instalada!');
      }).catchError((e) {
        ErrorService.show(context, 'Error al instalar actualización');
      });
    });
    ScaffoldMessenger.of(context).showMaterialBanner(banner);
  }

  void checkForUpdate() async {
    if (_updateInfo != null) {
      return;
    }
    try {
      AppUpdateInfo newUpdateInfo = await InAppUpdate.checkForUpdate();
      setState(() {
        _updateInfo = newUpdateInfo;
      });
      if (newUpdateInfo.updateAvailability ==
          UpdateAvailability.updateAvailable) {
        askForUpdate();
      }
    } catch (error) {
      debugPrint(error.toString());
      ErrorService.show(
          _scaffoldKey.currentContext, 'Error buscando actualizaciones...');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        body: IndexedStack(
          index: selectedTab,
          children: const [
            SearchShopsTab(),
            FavouritesTab(),
            // ArticlesTab(),
            MoreTab()
          ],
        ),
        bottomNavigationBar: BottomNavBar(
          selectedTab: selectedTab,
          callback: (int i) {
            setState(() {
              selectedTab = i;
              Analytics.t("Tap on tab ${homeTabsLabels[i]}");
            });
          },
        ),
      ),
    ));
  }
}
