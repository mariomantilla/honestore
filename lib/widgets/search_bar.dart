import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar(
      {Key? key,
      required this.search,
      required this.searchCallback,
      required this.viewMode,
      this.mapCallback,
      this.updateResults})
      : super(key: key);

  final String search;
  final Function(String) searchCallback;
  final void Function()? mapCallback;
  final void Function()? updateResults;
  final int viewMode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25, right: 20, left: 20, bottom: 0),
      child: TextFormField(
        textInputAction: TextInputAction.go,
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            focusedBorder: const OutlineInputBorder(),
            hintText: 'Buscar tienda',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
                onPressed: mapCallback,
                icon: Icon(viewMode == 0 ? Icons.map : Icons.list))),
        initialValue: search,
        onChanged: searchCallback,
        onEditingComplete: updateResults,
      ),
    );
  }
}
