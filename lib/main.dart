import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:han_bab/controller/hanbab_auth_provider.dart';
import 'package:han_bab/controller/home_provider.dart';
import 'package:han_bab/controller/map_provider.dart';
import 'package:han_bab/controller/orderlist_provider.dart';
import 'package:han_bab/controller/signup_controller.dart';
import 'package:han_bab/controller/verify_controller.dart';
import 'package:han_bab/model/text_input_model.dart';
import 'package:han_bab/view/app.dart';
import 'package:han_bab/controller/navigation_controller.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NaverMapSdk.instance.initialize(clientId: '6ziij4feg1');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HanbabAuthProvider()),
        ChangeNotifierProvider(create: (context) => SignupController()),
        ChangeNotifierProvider(create: (context) => NavigationController()),
        ChangeNotifierProvider(create: (context) => TextInputModel()),
        ChangeNotifierProvider(create: (context) => VerifyController()),
        ChangeNotifierProvider(create: (context) => OrderlistProvider()),
        ChangeNotifierProvider(create: (context) => HomeProvider()),
        ChangeNotifierProvider(create: (context) => MapProvider()),
      ],
      builder: ((context, child) => const App()),
    ),
  );
}
