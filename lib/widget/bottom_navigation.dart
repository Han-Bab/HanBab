import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:han_bab/color_schemes.dart';
import 'package:han_bab/controller/navigation_controller.dart';
import 'package:provider/provider.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationService = Provider.of<NavigationController>(context);

    return Theme(
      data: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: Container(
        padding: const EdgeInsets.only(top: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // 그림자 색상 및 투명도 조절
              spreadRadius: 4,
              blurRadius: 3,
              offset: const Offset(0, 3), // 그림자 위치 조절
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white, // surfaceTintColor
          selectedItemColor: lightColorScheme.primary, // indicatorColor
          currentIndex: navigationService.selectedIndex,
          onTap: (int index) {
            navigationService.setSelectedIndex(index);
          },
          selectedLabelStyle: const TextStyle(fontFamily: "PretenderMedium", fontSize: 12, height: 3),
          unselectedLabelStyle: const TextStyle(fontFamily: "PretenderMedium", fontSize: 12, height: 3),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Image.asset("./assets/navi_icons/order_off.png", scale: 1.8,),
              activeIcon: Image.asset("./assets/navi_icons/order_on.png", scale: 1.8,),
              label: '주문내역',
            ),
            BottomNavigationBarItem(
              icon: Image.asset("./assets/navi_icons/home_off.png", scale: 1.8,),
              activeIcon: Image.asset("./assets/navi_icons/home_on.png", scale: 1.8,),
              label: '홈',
            ),
            BottomNavigationBarItem(
              icon: Image.asset("./assets/navi_icons/menu_off.png", scale: 1.8,),
              activeIcon: Image.asset("./assets/navi_icons/menu_on.png", scale: 1.8,),
              label: '메뉴',
            ),
          ],
        ),
      ),
    );
  }
}
