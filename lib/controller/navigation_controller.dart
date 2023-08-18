import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:han_bab/view/page1/order_list_page.dart';
import 'package:han_bab/view/page2/home.dart';
import 'package:han_bab/view/page3/profile.dart';

class NavigationController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _selectedIndex = 1;

  int get selectedIndex => _selectedIndex;
  void setSelectedIndex(int index) {
    _selectedIndex = index;
    print(_selectedIndex);
    notifyListeners();
  }

  Widget getPageByIndex() {
    return IndexedStack(
      index: _selectedIndex,
      children: const [
        OrderListPage(),
        HomePage(),
        ProfilePage(),
      ],
    );
  }

  bool isEmailVerified() {
    bool isVerified = false;

    if (_auth.currentUser!.emailVerified) {
      isVerified = true;
    } else {
      isVerified = false;
    }

    return isVerified;
  }
}
