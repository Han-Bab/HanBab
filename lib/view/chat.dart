import 'package:flutter/material.dart';
import 'package:han_bab/widget/bottom_navigation.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Page"),
      ),
      body: const Center(
        child: Text("Chat Page"),
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}
