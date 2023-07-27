import 'package:flutter/material.dart';
import 'package:han_bab/widget/bottom_navigation.dart';

class OrderListPage extends StatelessWidget {
  const OrderListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("주문내역"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xffF97E13),
                Color(0xffFFCD96),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: const Center(
        child: Text("Chat Page"),
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}
