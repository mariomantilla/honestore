import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/shop.dart';

class DataService {
  static const String assetsUrl =
      'https://tbhtpkmrwtznqzsjlfmo.supabase.co/storage/v1/object/public/shops-content/%uuid%.jpg';

  static String getAssetUrl(String uuid) {
    return assetsUrl.replaceAll("%uuid%", uuid);
  }

  static Future<List<Shop>> getShops(search, location) async {
    String rpc = 'search_shops';
    Map<String, String> params = {'search': search};
    if (location != null) {
      rpc = 'nearby_shops';
      params['location'] =
          'Point(${location?.latitude} ${location?.longitude})';
    }
    PostgrestResponse response =
        await Supabase.instance.client.rpc(rpc, params: params).execute();
    return response.data.map<Shop>((s) {
      return Shop.fromRawData(
          name: s['name'],
          description: s['description'],
          logoUuid: s['logo'],
          coordinates: s['location']
              .split(" ")
              .map<double>((x) => double.parse(x))
              .toList(),
          createdAt: s['created_at'],
          updatedAt: s['updated_at']);
    }).toList();
  }
}
