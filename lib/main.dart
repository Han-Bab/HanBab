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
  print("백그라운드 메시지 처리: ${message.messageId}");
  await Firebase.initializeApp(); //이거 새로 생김
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

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);

  // await flutterLocalNotificationsPlugin.initialize(initializationSettings,
  //     onSelectNotification: (String? payload) async {
  //       print('알림 클릭: $payload');
  //     });

  NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    provisional: false,
    sound: true,
  );

  print('알림 권한 요청 결과: ${settings.authorizationStatus}');

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('포그라운드에서 메시지 수신: ${message.messageId}');
    if (message.notification != null) {
      print('메시지 알림: ${message.notification!.title}, ${message.notification!.body}');
      showNotification(message);
    }
  });

  // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //   print('알림 클릭: ${message.messageId}');
  //   // 알림 클릭 시 처리
  // });

  FirebaseMessaging.instance.getToken().then((String? token) {
    assert(token != null);
    print("FCM Token: $token");
  });

}

void showNotification(RemoteMessage message) {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'high_importance_notification',
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
    print('알림 표시: ${notification.title}, ${notification.body}');
  }
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
