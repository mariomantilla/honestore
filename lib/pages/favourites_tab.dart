import 'package:flutter/material.dart';
import 'package:honestore/models/app_state.dart';
import 'package:honestore/widgets/login_required.dart';
import 'package:honestore/widgets/shops_display.dart';
import 'package:honestore/widgets/tab_title.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

final client = sb.Supabase.instance.client;

class FavouritesTab extends StatelessWidget {
  const FavouritesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, child) {
      return Column(
        children: [
          const TabTitle('Tus Favoritos'),
          appState.user == null
              ? const LoginRequired()
              : ShopsDisplay(
                  shops: appState.favourites,
                  index: 0,
                ),
        ],
      );
    });
  }
}
