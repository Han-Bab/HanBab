import 'package:flutter/material.dart';
import 'package:han_bab/view/page1/order_list_page.dart';
import 'package:han_bab/view/page2/home.dart';
import 'package:han_bab/view/page3/profile.dart';

class NavigationController extends ChangeNotifier {
  int _selectedIndex = 1;

  int get selectedIndex => _selectedIndex;
  void setIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  Widget getPageByIndex(int index) {
    switch (index) {
      case 0:
        return const OrderListPage();
      case 1:
        return const HomePage();
      case 2:
        return const ProfilePage();
      default:
        return const HomePage();
    }
  }
}
