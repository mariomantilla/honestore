import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants.dart';
import '../models/shop.dart';

class DataService {
  static const String assetsUrl =
      'https://tbhtpkmrwtznqzsjlfmo.supabase.co/storage/v1/object/public/shops-content/%uuid%.jpg';

  static Future<void> initialise() async {
    await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseKey,
        authCallbackUrlHostname: 'login-callback', // optional
        debug: true // optional
        );
  }

  static String getAssetUrl(String uuid) {
    return assetsUrl.replaceAll("%uuid%", uuid);
  }

  static Future<FunctionResponse> deleteUser() {
    return Supabase.instance.client.functions.invoke('deleteUser');
  }

  static addFavourite(User user, Shop shop) {
    return Supabase.instance.client
        .from('favourites')
        .insert({'shop': shop.id, 'user': user.id}).execute();
  }

  static removeFavourite(User user, Shop shop) {
    return Supabase.instance.client
        .from('favourites')
        .delete(returning: ReturningOption.minimal)
        .eq('shop', shop.id)
        .eq('user', user.id)
        .execute();
  }

  static Future<List<Shop>> getFavourites(User user) async {
    PostgrestResponse resp = await Supabase.instance.client
        .from('shops')
        .select('*, favourites!inner(user)')
        .eq('favourites.user', user.id)
        .execute();
    if (resp.hasError) print(resp.error);
    if (resp.data == null) {
      return [];
    }
    return mapShopsFromData(resp.data);
  }

  static Future<List<Shop>> getShops(search, location, sorting) async {
    print('Getting shops');
    String rpc = 'search_shops';
    Map<String, String> params = {'search': search};
    if (location != null && sorting == SortByOptions.nearBy) {
      rpc = 'nearby_shops';
      params['location'] =
          'Point(${location?.latitude} ${location?.longitude})';
    }
    if (sorting == SortByOptions.popular) {
      rpc = 'popular_shops';
    }
    PostgrestFilterBuilder query =
        Supabase.instance.client.rpc(rpc, params: params);

    PostgrestResponse response = await query.execute();
    if (response.data == null) {
      return [];
    }
    return mapShopsFromData(response.data);
  }

  static List<Shop> mapShopsFromData(data) {
    return data.map<Shop>((s) {
      return Shop.fromRawData(
          id: s['id'],
          name: s['name'],
          description: s['description'],
          logoUuid: s['logo'],
          web: s['web'],
          instagram: s['instagram'],
          phone: s['phone'],
          address: s['address'],
          email: s['email'],
          coordinates: s['location_coordinates']
              .split(" ")
              .map<double>((x) => double.parse(x))
              .toList(),
          createdAt: s['created_at'],
          updatedAt: s['updated_at']);
    }).toList();
  }
}
