import 'package:flutter/material.dart';
import 'package:honestore/pages/favourites_tab.dart';
import 'package:honestore/pages/more_tab.dart';
import 'package:honestore/pages/search_shops_tab.dart';

import 'package:honestore/widgets/bottom_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedTab = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: IndexedStack(
          index: selectedTab,
          children: const [SearchShopsTab(), FavouritesTab(), MoreTab()],
        ),
        bottomNavigationBar: BottomNavBar(
          selectedTab: selectedTab,
          callback: (int i) {
            setState(() {
              selectedTab = i;
            });
          },
        ),
      ),
    ));
  }
}
