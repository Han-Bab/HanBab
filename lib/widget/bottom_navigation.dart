import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:han_bab/controller/navigation_controller.dart';
import 'package:provider/provider.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationService = Provider.of<NavigationController>(context);

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // 그림자 색상 및 투명도 조절
            spreadRadius: 4,
            blurRadius: 3,
            offset: const Offset(0, 3), // 그림자 위치 조절
          ),
        ],
      ),
      child: NavigationBar(
        surfaceTintColor: Colors.white,
        onDestinationSelected: (int index) {
          navigationService.setSelectedIndex(index);
        },
        selectedIndex: navigationService.selectedIndex,
        destinations: <Widget>[
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
            icon: Image.asset("./assets/icons/menu.png", scale: 2,),
            label: '프로필',
          ),
        ],
        animationDuration: const Duration(milliseconds: 500),
      ),
    );
  }
}
