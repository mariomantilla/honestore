import 'package:latlong2/latlong.dart';

class Shop {
  String name;
  String description;
  String logoUuid;
  LatLng location;
  DateTime createdAt;
  DateTime updatedAt;

  Shop({
    required this.name,
    required this.description,
    required this.logoUuid,
    required this.location,
    required this.updatedAt,
    required this.createdAt,
  });

  Shop.fromRawData({
    required this.name,
    required this.description,
    required this.logoUuid,
    required List<double> coordinates,
    required String createdAt,
    required String updatedAt,
  })  : location = LatLng(coordinates[0], coordinates[1]),
        createdAt = DateTime.parse(createdAt),
        updatedAt = DateTime.parse(updatedAt);
}
