import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("백그라운드 메시지 처리.. ${message.notification!.body!}");
}

void initializeNotification() async {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(const AndroidNotificationChannel(
          'high_importance_channel', 'high_importance_notification',
          importance: Importance.max));

  await flutterLocalNotificationsPlugin.initialize(const InitializationSettings(
    android: AndroidInitializationSettings("@mipmap/ic_launcher"),
  ));

  NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    provisional: false,
    sound: true,
  );
  // iOS foreground notification 권한
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NaverMapSdk.instance.initialize(clientId: '6ziij4feg1');
  initializeNotification();
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
