import 'package:flutter/foundation.dart';
import 'package:honestore/models/shop.dart';
import 'package:honestore/services/data_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppState extends ChangeNotifier {
  /// Internal, private state of the appstate.
  User? user;
  List<Shop> favourites = [];

  void loginUser(User newUser) async {
    user = newUser;
    favourites = await DataService.getFavourites(newUser);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void logOut() {
    user = null;
    favourites = [];
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void addFavourite(Shop shop) {
    User? actingUser = user;
    if (actingUser != null) {
      DataService.addFavourite(actingUser, shop).then((PostgrestResponse resp) {
        if (!resp.hasError) {
          favourites.add(shop);
          notifyListeners();
        }
      });
    }
  }

  void removeFavourite(Shop shop) {
    User? actingUser = user;
    if (actingUser != null) {
      DataService.removeFavourite(actingUser, shop)
          .then((PostgrestResponse resp) {
        if (!resp.hasError) {
          favourites.removeWhere((s) => s.id == shop.id);
          notifyListeners();
        }
      });
    }
  }

  bool isFavourite(Shop shop) {
    return favourites.map((s) => s.id).contains(shop.id);
  }
}
