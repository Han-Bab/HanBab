import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:han_bab/widget/toggle_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

bool isInChatPage = false;

// 앱 시작 시 토글 상태 확인하는 함수 추가
Future<bool> checkInitialToggleState() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isToggled') ?? true; // 기본값 true
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (isToggled) {
    print("백그라운드 메시지 처리: ${message.messageId}");
    await Firebase.initializeApp();
  }
}

Future<void> initializeNotification() async {
  isToggled = await checkInitialToggleState();
  if (isToggled) {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(const AndroidNotificationChannel(
          'high_importance_channel', 'high_importance_notification',
          importance: Importance.max));

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
      iOS: initializationSettingsIOS, android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    provisional: false,
    sound: true,
  );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print(message);
    if (!isToggled || isInChatPage) {
      print("알림이 비활성화되어 있거나 채팅 화면에 있으므로 알림을 표시하지 않습니다.");
      return;
    }

    // 채팅 화면이 아닐 경우에만 알림 표시
    if (message.data != null) {
      print('메시지 알림: ${message.data["title"]}, ${message.data["body"]}');
      showNotification(message, flutterLocalNotificationsPlugin);
    }
  });
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
    try {
      // 현재 로그인한 사용자의 UID 가져오기
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        // Firestore의 user 컬렉션에서 사용자 문서 업데이트
        await FirebaseFirestore.instance.collection('user').doc(userId).update({
          'token': newToken, // token 필드 업데이트
        });

        print("User token updated in Firestore: $newToken");
      } else {
        print("No authenticated user found. Token not updated.");
      }
    } catch (e) {
      print("Error updating user token in Firestore: $e");
    }
  });

}

void showNotification(RemoteMessage message, flutterLocalNotificationsPlugin) {
  final data = message.data; // 데이터 메시지에서 정보 가져오기

  flutterLocalNotificationsPlugin.show(
    message.hashCode,
    data['title'] ?? '알림 제목 없음', // 데이터 메시지에서 제목 추출
    data['body'] ?? '알림 내용 없음', // 데이터 메시지에서 본문 추출
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'high_importance_channel', // 동일한 채널 ID
        'High Importance Notifications',
        icon: '@mipmap/ic_launcher',
      ),
      // iOS: DarwinNotificationDetails(
      //   presentAlert: true, // iOS 알림 표시
      //   presentBadge: true,
      //   presentSound: true,
      // ),
    ),
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 초기화 전에 토글 상태 확인
  isToggled = await checkInitialToggleState();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NaverMapSdk.instance.initialize(clientId: '6ziij4feg1');
  await initializeNotification();
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
