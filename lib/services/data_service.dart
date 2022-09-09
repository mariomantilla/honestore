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

  static Future<List<Shop>> getShops(search, location, sorting) async {
    print('Getting shops');
    String rpc = 'search_shops';
    Map<String, String> params = {'search': search};
    if (location != null && sorting == SortByOptions.nearBy) {
      rpc = 'nearby_shops';
      params['location'] =
          'Point(${location?.latitude} ${location?.longitude})';
    }
    PostgrestFilterBuilder query =
        Supabase.instance.client.rpc(rpc, params: params);

    PostgrestResponse response = await query.execute();
    if (response.data == null) {
      return [];
    }
    return response.data.map<Shop>((s) {
      return Shop.fromRawData(
          id: s['id'],
          name: s['name'],
          description: s['description'],
          logoUuid: s['logo'],
          web: s['web'],
          instagram: s['instagram'],
          coordinates: s['location']
              .split(" ")
              .map<double>((x) => double.parse(x))
              .toList(),
          createdAt: s['created_at'],
          updatedAt: s['updated_at']);
    }).toList();
  }
}
