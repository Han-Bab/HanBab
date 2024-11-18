import 'package:flutter/material.dart';
import 'package:han_bab/color_schemes.dart';
import 'package:han_bab/controller/navigation_controller.dart';
import 'package:provider/provider.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationService = Provider.of<NavigationController>(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      padding: const EdgeInsets.only(bottom: 28.0, top: 10), // 네비게이션 바 높이 조절
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // 각 아이템 간격 동일하게
        children: [
          _buildNavItem(
            context,
            index: 0,
            isSelected: navigationService.selectedIndex == 0,
            label: "채팅",
            icon: "./assets/navi_icons/order_off.png",
            activeIcon: "./assets/navi_icons/order_on.png",
          ),
          const SizedBox(width: 91,),
          _buildNavItem(
            context,
            index: 1,
            isSelected: navigationService.selectedIndex == 1,
            label: "홈",
            icon: "./assets/navi_icons/home_off.png",
            activeIcon: "./assets/navi_icons/home_on.png",
          ),
          const SizedBox(width: 91,),
          _buildNavItem(
            context,
            index: 2,
            isSelected: navigationService.selectedIndex == 2,
            label: "메뉴",
            icon: "./assets/navi_icons/menu_off.png",
            activeIcon: "./assets/navi_icons/menu_on.png",
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, {
        required int index,
        required bool isSelected,
        required String label,
        required String icon,
        required String activeIcon,
      }) {
    final navigationService = Provider.of<NavigationController>(context, listen: false);

    return GestureDetector(
      onTap: () {
        navigationService.setSelectedIndex(index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            isSelected ? activeIcon : icon,
            scale: 2,
          ),
          const SizedBox(height: 4), // 아이콘과 라벨 사이 간격
          Text(
            label,
            style: TextStyle(
              fontFamily: "PretendardMedium",
              fontSize: 12,
              color: isSelected ? lightColorScheme.primary : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
