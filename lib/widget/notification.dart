import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:han_bab/view/app.dart';
import '../view/page2/chat/chat_page.dart';

import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;


class FlutterLocalNotification {
  static final FlutterLocalNotification _instance = FlutterLocalNotification._internal();
  StreamSubscription<RemoteMessage>? _messageSubscription; // 리스너 구독을 관리하기 위한 변수

  factory FlutterLocalNotification() {
    return _instance;
  }

  FlutterLocalNotification._internal();

  // void init() {
  //   _messageSubscription?.cancel(); // 기존의 메시지 리스너 구독을 취소합니다.
  //   _messageSubscription = FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
  //     if (!isChatScreenActive) {
  //       RemoteNotification? notification = message.notification;
  //
  //       if (notification != null && message.data.values.first != token) {
  //         FlutterLocalNotificationsPlugin().show(
  //           notification.hashCode,
  //           notification.title,
  //           notification.body,
  //           const NotificationDetails(
  //             android: AndroidNotificationDetails(
  //               'high_importance_channel',
  //               'high_importance_notification',
  //               importance: Importance.max,
  //               // icon: '@mipmap/ic_launcher'
  //             ),
  //           ),
  //         );
  //       }
  //     }
  //   });
  // }

  void dispose() {
    _messageSubscription?.cancel(); // 앱이 종료될 때 리스너 구독을 취소합니다.
  }

  Future<String> getAccessToken() async {
    //Your client ID and client secret obtained from Google Cloud Condole
    final serviceAccountJson = await rootBundle.loadString('assets/data/notification.json');

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    //Obtain the access token
    auth.AccessCredentials credentials = await auth.obtainAccessCredentialsViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
        scopes,
        client
    );

    //Close the HTTP clinet
    client.close();

    //Return the access token
    return credentials.accessToken.data;
  }


  Future<String?> postMessage(String groupId, String title, String userName, String body) async {
    String description = "";
    switch (body) {
      case "식비 정산 요청" :
        description = "방장이 정산을 요청했습니다!";
        break;
      case "식비 정산 완료" :
        description = "정산이 완료되었습니다. 방장이 주문중이에요!";
        break;
      case "배달의 민족 주문 완료" :
        description = "주문이 완료되었어요! 배달의 민족 어플을 확인해주세요!";
        break;
      case "배달비 정산 요청" :
        description = "남은 배달비를 정산해주세요!";
        break;
      default :
        description = "메세지가 왔습니다!";
    }

    final String serverKey = await getAccessToken(); // Your FCM server key (accessToken)
    const String fcmEndpoint = "https://fcm.googleapis.com/v1/projects/han-bab/messages:send";
    // final String currentFCMToken = await FirebaseMessaging.instance.getToken();

    final Map<String, dynamic> message = {
      "message": {
        // "token": [
        //   "fqe5t-RETEn9j96i-wDnhW:APA91bEp0X-Fpss5JrGmEe_0j0ykNbiNd4nKNLTOMkKVafAu4zJtzOZ4MAF-1SzqtRUeYdw5yJ4EA3ezH_1ZpZDJXtGLJz5o0nWDjWp2KsKhlN7Q_oWYWBCn_PBg9xZ9P-2LH7SVwx1I",
        //   "fNYsddZ5lkc9kRgwuoKm8c:APA91bGwjad8u6yWbnJsZlh7I_tgOLsC17mnFc7PJcTEHKS2fDkKRV7s9ui0zgc5-SLwRBQHJsw7up0E7xfbJrNCFqwL9QfoK-AdnARXOmAcud1O6-barMtcQrtDBXzNmc6gbDVbWufE",
        // ],
        "topic": groupId,

        "notification": {
          "title": "[$title] $body",
          "body": description,
          "image": "./assets/images/hanbab_icon.png"
        },
        "data": {
          "click_action": "FCM Test Click Action",
          "senderId": token,
        },
        "android": {
          "notification": {
            "click_action": "Android Click Action",
          }
        },
        "apns": {
          "payload": {
            "aps": {
              "category": "Message Category",
              "content-available": 1,
              "sound": "default",
            }
          }
        }
      }
    };

    try {
      // String? accessToken = "ya29.a0AcM612x31tX-XF5wUVTHNmQ46lxAtrDLofdCTcQw9RXbd7Ch7uXPk1qv3UTPdbjrAnbm2_OgfotByfxxpMmkbwi6vI6hfFemRj9PquZnhBOxgDi7Wr1cRifbTtbBfOXdO5Py_myC4cqLMrW6_Rmq3uexYxfB3vKGGZDFaCgYKARkSARESFQHGX2MiRJ242nbUL4SyJfIcO41o0A0171";
      final http.Response response = await http.post(
          Uri.parse(fcmEndpoint),
          headers: <String, String> {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $serverKey',
          },
          body: jsonEncode(message),
      );
      if (response.statusCode == 200) {
        return "FCM request successful";
      } else {
        return response.statusCode.toString();
      }
    } on HttpException catch (error) {
      return error.message;
    }
  }

}