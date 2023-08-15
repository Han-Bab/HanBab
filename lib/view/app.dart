import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:han_bab/color_schemes.dart';
import 'package:han_bab/controller/navigation_controller.dart';
import 'package:han_bab/view/login/login.dart';
import 'package:han_bab/view/login/signup1.dart';
import 'package:han_bab/view/login/signup2.dart';
import 'package:han_bab/view/login/signup3.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "HanBab",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.white,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
      ),
      routes: _routes,
      themeMode: ThemeMode.system,
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

final _routes = <String, WidgetBuilder>{
  '/login': ((BuildContext context) => const LoginPage()),
  '/signup1': ((BuildContext context) => const Signup1Page()),
  '/signup2': ((BuildContext context) => const Signup2Page()),
  '/signup3': ((BuildContext context) => const Signup3Page()),
};
