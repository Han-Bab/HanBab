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
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

bool isInChatPage = false;
bool isToggled = true;

// 전역적으로 FlutterLocalNotificationsPlugin 선언
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<bool> checkInitialToggleState() async {
  final prefs = await SharedPreferences.getInstance();
  print(prefs.getBool('isToggled'));

  return prefs.getBool('isToggled') ?? true; // 기본값 true
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  final prefs = await SharedPreferences.getInstance();
  await prefs.reload(); // 강제로 최신 데이터 동기화

  bool isToggledBackground = prefs.getBool('isToggled') ?? true;
  if (!isToggledBackground) {
    print("isToggled 비활성화, 알림 표시 중단");
    return;
  }

  print("백그라운드 알림 처리: ${message.messageId}");
  showNotification(message);
}


Future<void> initializeNotification() async {

  // Android 및 iOS 초기화 설정
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings initializationSettingsIOS =
  DarwinInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // 알림 권한 요청
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    provisional: false,
    sound: true,
  );

  // 포그라운드 알림 표시 설정
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // 메시지 수신 리스너 설정
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("포그라운드 메시지 수신: $message");
    if (!isToggled || isInChatPage) {
      print("알림 비활성화 또는 채팅 화면에서 알림 표시 안 함");
      return;
    }
    showNotification(message); // 알림 표시 함수 호출
  });

  // FCM 토큰 갱신 리스너 설정
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        await FirebaseFirestore.instance.collection('user').doc(userId).update({
          'token': newToken,
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

// 알림 표시 함수
void showNotification(RemoteMessage message) {
  final data = message.data;

  flutterLocalNotificationsPlugin.show(
    message.hashCode,
    data['title'] ?? '알림 제목 없음',
    data['body'] ?? '알림 내용 없음',
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'high_importance_channel', // 동일한 채널 ID
        'High Importance Notifications',
        importance: Importance.max,
        icon: '@mipmap/ic_launcher',
      ),
    ),
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 초기화 전에 토글 상태 확인
  isToggled = await checkInitialToggleState();
  print(isToggled);
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
      builder: (context, child) => const App(),
    ),
  );
}
