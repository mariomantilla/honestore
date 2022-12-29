import 'package:honestore/models/article.dart';
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
        .insert({'shop': shop.id, 'user': user.id});
  }

  static Future removeFavourite(User user, Shop shop) {
    return Supabase.instance.client
        .from('favourites')
        .delete()
        .eq('shop', shop.id)
        .eq('user', user.id);
  }

  static Future<List<Shop>> getFavourites(User user) async {
    List favourites = await Supabase.instance.client
        .from('shops')
        .select('*, favourites!inner(user)')
        .eq('favourites.user', user.id);
    return mapShopsFromData(favourites);
  }

  static Future<List<Article>> getArticles() async {
    List articles = await Supabase.instance.client
        .from('articles')
        .select('*, author(name)');
    return mapArticlesFromData(articles);
  }

  static Future<List<Shop>> getShops(search, location, sorting) async {
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
    List response = await Supabase.instance.client.rpc(rpc, params: params);
    return mapShopsFromData(response);
  }

  static Future<Shop?> getShop(id) async {
    List shops =
        await Supabase.instance.client.from('shops').select('*').eq('id', id);
    if (shops.isEmpty) {
      return null;
    }
    return mapShopFromData(shops[0]);
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
        online: data['online'],
        coordinates: data['location_coordinates']
            .split(" ")
            .map<double>((x) => double.parse(x))
            .toList(),
        createdAt: data['created_at'],
        updatedAt: data['updated_at']);
  }

  static List<Article> mapArticlesFromData(data) {
    return data.map<Article>((s) {
      return mapArticleFromData(s);
    }).toList();
  }

  static Article mapArticleFromData(data) {
    return Article.fromRawData(
        id: data['id'],
        title: data['title'],
        body: data['body'],
        authorName: data['author']['name'] ?? '',
        createdAt: data['created_at'],
        updatedAt: data['updated_at']);
  }
}
