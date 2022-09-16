import 'package:flutter/material.dart';
import 'package:honestore/models/app_state.dart';
import 'package:honestore/models/shop.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants.dart';
import '../services/data_service.dart';
import '../widgets/shops_display.dart';

const customDivider = Padding(
  padding: EdgeInsets.only(left: 20, right: 20),
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
  const DataItem(this.icon, this.title, this.value, {Key? key, this.action})
      : super(key: key);

  final Widget icon;
  final String title;
  final String? value;
  final void Function()? action;

  @override
  Widget build(BuildContext context) {
    final v = value;
    return v != null
        ? ListTile(
            horizontalTitleGap: 0,
            leading: Container(
              width: 50,
              padding: const EdgeInsets.only(top: 8),
              alignment: Alignment.center,
              // padding: const EdgeInsets.all(12.0),
              child: icon,
            ),
            title: Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
            subtitle: Text(v, style: const TextStyle(fontSize: 16)),
            onTap: action,
            trailing: action != null
                ? const Padding(
                    padding: EdgeInsets.only(right: 18.0, top: 12),
                    child: Icon(
                      Icons.open_in_new,
                      color: CustomColors.primary,
                    ),
                  )
                : null,
            visualDensity: const VisualDensity(vertical: -4),
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

    List<List> dataItemsConfig = [
      [
        const FaIcon(
          FontAwesomeIcons.instagram,
          color: CustomColors.primary,
        ),
        'Instagram',
        shop.instagram,
        openUrlCallback('https://www.instagram.com/${shop.instagram}')
      ],
      [
        const Icon(
          Icons.web,
          color: CustomColors.primary,
        ),
        'Web',
        shop.web,
        openUrlCallback(shop.web)
      ],
      [
        const Icon(
          Icons.phone,
          color: CustomColors.primary,
        ),
        'Teléfono',
        shop.phone,
        openUrlCallback('tel:${shop.phone}')
      ],
      [
        const Icon(
          Icons.alternate_email,
          color: CustomColors.primary,
        ),
        'Email',
        shop.email,
        openUrlCallback('mailto:${shop.email}')
      ],
      [
        const Icon(
          Icons.location_city,
          color: CustomColors.primary,
        ),
        'Dirección',
        shop.address,
        null
      ]
    ];
    List<Widget> dataItems = dataItemsConfig
        .where((i) => i[2] != null)
        .map<Widget>((i) => DataItem(i[0], i[1], i[2], action: i[3]))
        .toList();
    if (dataItems.isNotEmpty) {
      dataItems += [customDivider];
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(shop.name),
          actions: [
            Consumer<AppState>(builder: (context, appState, child) {
              if (appState.user == null) return Container();
              bool isFav = appState.isFavourite(shop);
              IconData icon = isFav ? Icons.favorite : Icons.favorite_outline;
              return IconButton(
                  onPressed: () {
                    if (isFav) {
                      appState.removeFavourite(shop);
                    } else {
                      appState.addFavourite(shop);
                    }
                  },
                  icon: Icon(icon));
            })
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                    Logo(shop.logoUuid),
                    Description(shop.description),
                    customDivider
                  ] +
                  dataItems +
                  [
                    SizedBox(
                      height: 400,
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
