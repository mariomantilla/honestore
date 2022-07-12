import 'package:flutter/material.dart';

import '../constants.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar(
      {Key? key, required this.selectedTab, required this.callback})
      : super(key: key);

  final int selectedTab;
  final Function(int) callback;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: selectedTab,
        onTap: callback,
        selectedItemColor: CustomMaterialColors.primary[900],
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explorar'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favs'),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'Más')
        ]);
  }
}
