import 'package:flutter/material.dart';
import 'package:honestore/models/shop.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/data_service.dart';
import '../widgets/shops_display.dart';

const customDivider = Padding(
  padding: EdgeInsets.only(left: 16, right: 16),
  child: Divider(
    thickness: 1,
  ),
);

openUrlCallback(url) {
  return () {
    launchUrl(Uri.parse(url ?? ''), mode: LaunchMode.externalApplication);
  };
}

class Description extends StatelessWidget {
  const Description(this.text, {Key? key}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0, left: 20),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}

class Logo extends StatelessWidget {
  const Logo(this.uuid, {Key? key}) : super(key: key);

  final String uuid;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            width: 200,
            height: 200,
            child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(200)),
                child: Image.network(
                  DataService.getAssetUrl(uuid),
                  fit: BoxFit.cover,
                )),
          ),
        ),
      ],
    );
  }
}

class DataItem extends StatelessWidget {
  const DataItem(this.title, this.value, {Key? key, this.action})
      : super(key: key);

  final String title;
  final String? value;
  final void Function()? action;

  @override
  Widget build(BuildContext context) {
    final v = value;
    return v != null
        ? ListTile(
            title: Text(
              title,
              style: TextStyle(fontSize: 16),
            ),
            subtitle: Text(v, style: TextStyle(fontSize: 16)),
            onTap: action,
            visualDensity: VisualDensity(vertical: -4),
          )
        : Container();
  }
}

class ShopPage extends StatefulWidget {
  const ShopPage(this.shop, {Key? key}) : super(key: key);

  final Shop shop;
  static const routeName = 'shops';

  @override
  State<ShopPage> createState() => ShopPageState();
}

class ShopPageState extends State<ShopPage> {
  @override
  Widget build(BuildContext context) {
    Shop shop = widget.shop;
    return Scaffold(
        appBar: AppBar(
          title: Text(shop.name),
        ),
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Logo(shop.logoUuid),
            Description(shop.description),
            customDivider,
            DataItem('Instagram', shop.instagram,
                action: openUrlCallback(
                    'https://www.instagram.com/${shop.instagram}')),
            DataItem('Web', shop.web, action: openUrlCallback(shop.web)),
            customDivider,
            SizedBox(
              height: 300,
              child: MapOfShops(
                shops: [shop],
                location: shop.location,
                showLocation: false,
              ),
            )
          ]),
        ));
  }
}
