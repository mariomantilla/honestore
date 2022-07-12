import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '/widgets/button.dart';

class LocationPicker extends StatelessWidget {
  const LocationPicker({Key? key, required this.callback, this.location})
      : super(key: key);

  final GestureTapCallback callback;
  final LatLng? location;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: location != null
          ? const Text('Cerca de mi')
          : DefaultButton(
              pressedCallback: callback,
              text: 'Buscar cerca de mi',
              icon: Icons.near_me,
            ),
    );
  }
}
