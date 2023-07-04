import 'package:flutter/material.dart';
import 'package:han_bab/widget/bottom_navigation.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: const Center(
        child: Text("Home Page"),
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}
