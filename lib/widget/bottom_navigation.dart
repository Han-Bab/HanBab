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
        print(index);
        navigationService.setSelectedIndex(index);
      },
      selectedIndex: navigationService.selectedIndex,
      destinations: const <Widget>[
        NavigationDestination(
          selectedIcon: Icon(CupertinoIcons.news_solid),
          icon: Icon(CupertinoIcons.news),
          label: '주문내역',
        ),
        NavigationDestination(
          selectedIcon: Icon(CupertinoIcons.house_fill),
          icon: Icon(CupertinoIcons.house),
          label: '홈',
        ),
        NavigationDestination(
          selectedIcon: Icon(CupertinoIcons.person_crop_circle_fill),
          icon: Icon(CupertinoIcons.person_crop_circle),
          label: '프로필',
        ),
      ],
      animationDuration: const Duration(milliseconds: 500),
    );
  }
}
