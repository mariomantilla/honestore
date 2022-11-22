import 'package:flutter/material.dart';

class CustomColors {
  static const primary = Color(0xfffb7168);
  static const secondary = Color(0xff521E1E);
}

MaterialColor toMaterial(Color color) {
  return MaterialColor(color.value, {
    50: color.withAlpha(25),
    100: color.withAlpha(50),
    200: color.withAlpha(75),
    300: color.withAlpha(100),
    400: color.withAlpha(125),
    500: color.withAlpha(150),
    600: color.withAlpha(175),
    700: color.withAlpha(200),
    800: color.withAlpha(225),
    900: color.withAlpha(255),
  });
}

class CustomMaterialColors {
  static final primary = toMaterial(CustomColors.primary);
  static final secondary = toMaterial(CustomColors.secondary);
}

const supabaseUrl = "https://tbhtpkmrwtznqzsjlfmo.supabase.co";
const supabaseKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRiaHRwa21yd3R6bnF6c2psZm1vIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NTY1MjU1MTUsImV4cCI6MTk3MjEwMTUxNX0.1udAz1lLiqT4bmRF-SZlSNOgng2pCZqwkMAXHb07Ch4';

const double defaultCenterLat = 41.3870154;
const double defaultCenterLng = 2.1612924;
const double defaultZoom = 13;

enum SortByOptions { nearBy, newest, popular }

Map sortByIcons = {
  SortByOptions.nearBy: Icons.radar,
  SortByOptions.newest: Icons.calendar_month,
  SortByOptions.popular: Icons.favorite
};

Map sortByLabels = {
  SortByOptions.nearBy: 'Más cercanos',
  SortByOptions.newest: 'Novedades',
  SortByOptions.popular: 'Populares'
};

extension ShowSnackBar on BuildContext {
  void showSnackBar({
    required String message,
    Color backgroundColor = Colors.white,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    ));
  }

  void showErrorSnackBar({required String message}) {
    showSnackBar(message: message, backgroundColor: CustomColors.secondary);
  }
}
