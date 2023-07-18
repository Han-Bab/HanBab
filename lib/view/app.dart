import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:han_bab/controller/navigation_controller.dart';
import 'package:han_bab/view/login.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "HanBab",
      theme: ThemeData(
        useMaterial3: true,
      ),
      // TODO: 여기에 로그인 기능 구현해서 로그인 화면, 홈 화면 구성해야 합니다 (완)
      home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              return Consumer<NavigationController>(
                  builder: (context, controller, _) {
                return controller.getPageByIndex(controller.selectedIndex);
              });
            } else {
              return const LoginPage();
            }
          }),
    );
  }
}
