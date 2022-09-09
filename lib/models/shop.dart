import 'package:latlong2/latlong.dart';

class Shop {
  int id;
  String name;
  String description;
  String logoUuid;
  LatLng location;
  String? web;
  String? instagram;

  DateTime createdAt;
  DateTime updatedAt;

  Shop({
    required this.id,
    required this.name,
    required this.description,
    required this.logoUuid,
    required this.location,
    this.web,
    this.instagram,
    required this.updatedAt,
    required this.createdAt,
  });

  Shop.fromRawData({
    required this.id,
    required this.name,
    required this.description,
    required this.logoUuid,
    this.web,
    this.instagram,
    required List<double> coordinates,
    required String createdAt,
    required String updatedAt,
  })  : location = LatLng(coordinates[0], coordinates[1]),
        createdAt = DateTime.parse(createdAt),
        updatedAt = DateTime.parse(updatedAt);
}
