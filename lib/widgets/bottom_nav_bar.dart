import 'package:flutter/material.dart';

import '../constants.dart';

const Map<int, String> homeTabsLabels = {
  0: 'Explorar',
  1: 'Favs',
  2: 'Más',
};

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
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.explore), label: homeTabsLabels[0]),
          BottomNavigationBarItem(
              icon: const Icon(Icons.favorite), label: homeTabsLabels[1]),
          BottomNavigationBarItem(
              icon: const Icon(Icons.more_horiz), label: homeTabsLabels[2])
        ]);
  }
}
