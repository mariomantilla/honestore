import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:honestore/models/shop.dart';
import 'package:honestore/services/analytics_service.dart';
import 'package:honestore/services/data_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final client = Supabase.instance.client;

class AppState extends ChangeNotifier {
  AppState() {
    createSubscription();
  }

  /// Internal, private state of the appstate.
  User? user;
  List<Shop> favourites = [];
  StreamSubscription? _authSubscription;

  void createSubscription() {
    _authSubscription = client.auth.onAuthStateChange.listen((data) {
      final User? user = data.session?.user;
      if (user != null) {
        loginUser(user);
      } else {
        logOut();
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  void loginUser(User newUser) async {
    user = newUser;
    favourites = await DataService.getFavourites(newUser);
    Analytics.instance?.identify(newUser.id.toString());
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void logOut() {
    user = null;
    favourites = [];
    Analytics.instance?.reset();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void addFavourite(Shop shop) {
    User? actingUser = user;
    if (actingUser != null) {
      DataService.addFavourite(actingUser, shop).then((dynamic v) {
        favourites.add(shop);
        Analytics.t("Add to favourites", {"shop_id": shop.id});
        notifyListeners();
      });
    }
  }

  void removeFavourite(Shop shop) {
    User? actingUser = user;
    if (actingUser != null) {
      DataService.removeFavourite(actingUser, shop).then((dynamic v) {
        favourites.removeWhere((s) => s.id == shop.id);
        Analytics.t("Remove from favourites", {"shop_id": shop.id});
        notifyListeners();
      });
    }
  }

  bool isFavourite(Shop shop) {
    return favourites.map((s) => s.id).contains(shop.id);
  }
}
