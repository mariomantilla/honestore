import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class LocationService {
  Location locationHelper = Location();

  Future<LatLng?> getLocation() async {
    bool serviceEnabled = await locationHelper.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationHelper.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    PermissionStatus permissionGranted = await locationHelper.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationHelper.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    LocationData locationData = await locationHelper.getLocation();
    if (locationData.latitude != null && locationData.longitude != null) {
      return LatLng(locationData.latitude ?? 0, locationData.longitude ?? 0);
    }
    return null;
  }
}
