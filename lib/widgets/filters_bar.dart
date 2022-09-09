import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../constants.dart';
import '/widgets/button.dart';

class SortOptionWidget extends StatelessWidget {
  final SortByOptions option;
  final bool selected;

  const SortOptionWidget(this.option, {Key? key, this.selected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: () {
        Navigator.pop(context, option);
      },
      child: Row(
        children: [
          Icon(sortByIcons[option]),
          const Padding(padding: EdgeInsets.all(5)),
          Text(
            sortByLabels[option],
            style: TextStyle(
                fontWeight: selected ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }
}

class FiltersBar extends StatelessWidget {
  const FiltersBar(
      {Key? key,
      required this.locationCallback,
      this.location,
      required this.sortingCallback,
      required this.sorting})
      : super(key: key);

  final GestureTapCallback locationCallback;
  final void Function(SortByOptions) sortingCallback;
  final LatLng? location;
  final SortByOptions sorting;

  Future<void> _askForSortingOption(context) async {
    SortByOptions? newSelection = await showDialog<SortByOptions>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Ordenar por'),
            children: <Widget>[
              SortOptionWidget(SortByOptions.nearBy,
                  selected: sorting == SortByOptions.nearBy),
              SortOptionWidget(SortByOptions.newest,
                  selected: sorting == SortByOptions.newest)
            ],
          );
        });
    if (newSelection != null) {
      sortingCallback(newSelection);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget locationButton = location == null
        ? DefaultButton(
            pressedCallback: locationCallback,
            text: 'Usar mi ubicacion',
            icon: Icons.near_me,
          )
        : DefaultButton(
            pressedCallback: locationCallback, icon: Icons.edit_location_alt);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const Padding(padding: EdgeInsets.all(5)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: locationButton,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: DefaultButton(
                pressedCallback: () {
                  _askForSortingOption(context);
                },
                icon: sortByIcons[sorting]),
          ),
        ],
      ),
    );
  }
}
