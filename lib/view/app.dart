import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:han_bab/color_schemes.dart';
import 'package:han_bab/controller/navigation_controller.dart';
import 'package:han_bab/database/databaseService.dart';
import 'package:han_bab/view/login/email_verify.dart';
import 'package:han_bab/view/login/initial.dart';
import 'package:han_bab/view/login/login.dart';
import 'package:han_bab/view/login/signup1.dart';
import 'package:han_bab/view/login/signup2.dart';
import 'package:han_bab/view/login/signup3.dart';
import 'package:han_bab/view/page1/order_list_page.dart';
import 'package:han_bab/view/page2/home/home.dart';
import 'package:han_bab/view/page3/profile.dart';
import 'package:han_bab/widget/notification.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {

  @override
  void initState() {

    FlutterLocalNotification.init();

    Future.delayed(const Duration(seconds: 3), FlutterLocalNotification.requestNotificationPermission());
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
      // darkTheme: ThemeData(
      //   useMaterial3: true,
      //   colorScheme: darkColorScheme,
      // ),
      routes: _routes,
      // onGenerateRoute: (settings) => _tabRoutes(settings),
      themeMode: ThemeMode.system,
      home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            return Consumer<NavigationController>(
                builder: (context, controller, _) {
              if (snapshot.hasData && snapshot.data!.email != "") {
                DatabaseService().alarm();
                return controller.getPageByIndex();
                // return const AddRoomPage();
                // if (controller.isEmailVerified()) {
                //   print('${controller.selectedIndex}');
                //   return controller.getPageByIndex();
                // } else {
                //   print('verify needed');
                //   return const EmailVerifyPage();
                // }
              } else {
                print('NoData');
                return const InitialPage();
              }
            });
          }),
    );
  }
}

// dynamic _tabRoutes(RouteSettings settings) {
//   switch (settings.name) {
//     case '/home':
//       return PageTransition(
//         child: const HomePage(),
//         type: PageTransitionType.fade,
//         settings: settings,
//       );
//     case '/homeFromLeft':
//       return PageTransition(
//         child: const HomePage(),
//         type: PageTransitionType.rightToLeft,
//         settings: settings,
//       );
//     case '/homeFromRight':
//       return PageTransition(
//         child: const HomePage(),
//         type: PageTransitionType.leftToRight,
//         settings: settings,
//       );
//     case '/orderList':

//       return PageTransition(
//         child: const OrderListPage(),
//         type: PageTransitionType.leftToRight,
//         settings: settings,
//       );
//     case '/profile':
//       return PageTransition(
//         child: const ProfilePage(),
//         type: PageTransitionType.rightToLeft,
//         settings: settings,
//       );
//     default:
//       return;
//   }
// }

final _routes = <String, WidgetBuilder>{
  '/initial': ((BuildContext context) => const InitialPage()),
  '/login': ((BuildContext context) => const LoginPage()),
  '/signup1': ((BuildContext context) => const Signup1Page()),
  '/signup2': ((BuildContext context) => const Signup2Page()),
  '/signup3': ((BuildContext context) => const Signup3Page()),
  '/verify': ((BuildContext context) => const EmailVerifyPage()),
  '/orderList': ((BuildContext context) => const OrderListPage()),
  '/home': ((BuildContext context) => const HomePage()),
  '/profile': ((BuildContext context) => const ProfilePage()),
};
