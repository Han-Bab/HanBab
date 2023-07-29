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
        title: Text("Profile Page"),
        //backgroundColor: Color(0xFFFFCD96),
        //titleTextStyle: Color(0xFFFFFFFF),
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
