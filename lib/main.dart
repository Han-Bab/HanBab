import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:han_bab/controller/auth_controller.dart';
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
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthController()),
        ChangeNotifierProvider(create: (context) => NavigationController()),
        ChangeNotifierProvider(create: (context) => TextInputModel()),
      ],
      builder: ((context, child) => const App()),
    ),
  );
}
