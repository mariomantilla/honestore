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

  static Future<Shop?> getShop(id) async {
    PostgrestResponse response = await Supabase.instance.client
        .from('shops')
        .select('*')
        .eq('id', id)
        .execute();
    if (response.data == null) {
      return null;
    }
    return mapShopFromData(response.data[0]);
  }

  static List<Shop> mapShopsFromData(data) {
    return data.map<Shop>((s) {
      return mapShopFromData(s);
    }).toList();
  }

  static Shop mapShopFromData(data) {
    return Shop.fromRawData(
        id: data['id'],
        name: data['name'],
        description: data['description'],
        logoUuid: data['logo'],
        web: data['web'],
        instagram: data['instagram'],
        phone: data['phone'],
        address: data['address'],
        email: data['email'],
        coordinates: data['location_coordinates']
            .split(" ")
            .map<double>((x) => double.parse(x))
            .toList(),
        createdAt: data['created_at'],
        updatedAt: data['updated_at']);
  }
}
