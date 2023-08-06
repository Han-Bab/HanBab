import 'package:flutter/material.dart';
import 'package:han_bab/controller/auth_controller.dart';
import 'package:han_bab/widget/bottom_navigation.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Page"),
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
        actions: [
          IconButton(
              onPressed: () {
                authController.logout();
              },
              icon: const Icon(Icons.logout_rounded)),
        ],
      ),
      body: const Center(
        child: Text("Profile Page"),
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}
