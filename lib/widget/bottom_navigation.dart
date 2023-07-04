import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:han_bab/controller/navigation_controller.dart';
import 'package:provider/provider.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationService = Provider.of<NavigationController>(context);

    return NavigationBar(
      onDestinationSelected: (int index) {
        navigationService.setIndex(index);
      },
      selectedIndex: navigationService.selectedIndex,
      destinations: const <Widget>[
        NavigationDestination(
          selectedIcon: Icon(CupertinoIcons.chat_bubble_2_fill),
          icon: Icon(CupertinoIcons.chat_bubble_2),
          label: 'Chat',
        ),
        NavigationDestination(
          selectedIcon: Icon(CupertinoIcons.house_fill),
          icon: Icon(CupertinoIcons.house),
          label: 'Home',
        ),
        NavigationDestination(
          selectedIcon: Icon(CupertinoIcons.person_crop_circle_fill),
          icon: Icon(CupertinoIcons.person_crop_circle),
          label: 'Profile',
        ),
      ],
    );
  }
}
