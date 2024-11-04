import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:han_bab/color_schemes.dart';
import 'package:han_bab/controller/navigation_controller.dart';
import 'package:han_bab/view/login/email_verify.dart';
import 'package:han_bab/view/login/initial.dart';
import 'package:han_bab/view/login/login.dart';
import 'package:han_bab/view/login/signup1.dart';
import 'package:han_bab/view/login/signup2.dart';
import 'package:han_bab/view/page1/order_list_page.dart';
import 'package:han_bab/view/page2/home/home.dart';
import 'package:han_bab/view/page3/profile.dart';
import 'package:provider/provider.dart';

String? token = "";

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  var messageString = "";
  void getMyDeviceToken() async {
    token = await FirebaseMessaging.instance.getToken();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('user').doc(user.uid).update({
        'token': token,
      }).catchError((e) {
        print("Error updating token: $e");
      });
    }
  }

  @override
  void initState() {
    getMyDeviceToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "HanBab",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'PretendardRegular',
        useMaterial3: true,
        colorScheme: lightColorScheme,
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.white,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: _routes,
      themeMode: ThemeMode.system,
      home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            return Consumer<NavigationController>(
                builder: (context, controller, _) {

              if (snapshot.hasData && snapshot.data!.email != "") {
                return controller.getPageByIndex();
              } else {
                return const InitialPage();
              }
            });
          }),
    );
  }
}

final _routes = <String, WidgetBuilder>{
  '/initial': ((BuildContext context) => const InitialPage()),
  '/login': ((BuildContext context) => const LoginPage()),
  '/signup1': ((BuildContext context) => Signup1Page()),
  '/signup2': ((BuildContext context) => const Signup2Page()),
  '/verify': ((BuildContext context) => const EmailVerifyPage()),
  '/orderList': ((BuildContext context) => const OrderListPage()),
  '/home': ((BuildContext context) => const HomePage()),
  '/profile': ((BuildContext context) => const ProfilePage()),
};
