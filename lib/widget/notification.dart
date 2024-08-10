import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:han_bab/view/app.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import '../database/databaseService.dart';
import '../view/page2/chat/chat_page.dart';

class FlutterLocalNotification {
  static final FlutterLocalNotification _instance = FlutterLocalNotification._internal();

  factory FlutterLocalNotification() {
    return _instance;
  }

  FlutterLocalNotification._internal();

  Future<String> getAccessToken() async {
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

    auth.AccessCredentials credentials = await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
      client,
    );

    client.close();

    return credentials.accessToken.data;
  }

  Future<List<String>> getGroupTokens(String groupId) async {
    List<String> tokens = [];

    try {
      // 그룹 문서 가져오기
      DocumentSnapshot groupSnapshot = await FirebaseFirestore.instance.collection('groups').doc(groupId).get();

      if (groupSnapshot.exists) {
        List<dynamic> members = groupSnapshot.get('members');

        for (String memberId in members) {
          // 각 멤버의 토큰 가져오기

          String me = FirebaseAuth.instance.currentUser!.uid;
          String getId(String res) {
            return res.substring(0, res.indexOf("_"));
          }
          memberId = getId(memberId);
          if(memberId != me) {
            DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
                .collection('user').doc(memberId).get();

            if (userSnapshot.exists) {
              String userToken = userSnapshot.get('token');
              tokens.add(userToken);
            }
          }
        }
      }
    } catch (e) {
      print("Error getting group tokens: $e");
    }

    return tokens;
  }

  Future<String?> postMessage(String groupId, String title, String userName, String body) async {
    String description = "";
    switch (body) {
      case "식비 정산 요청":
        description = "방장이 정산을 요청했습니다!";
        break;
      case "식비 정산 완료":
        description = "정산이 완료되었습니다. 방장이 주문중이에요!";
        break;
      case "배달의 민족 주문 완료":
        description = "주문이 완료되었어요! 배달의 민족 어플을 확인해주세요!";
        break;
      case "배달비 정산 요청":
        description = "남은 배달비를 정산해주세요!";
        break;
      default:
        description = "메세지가 왔습니다!";
    }

    final String serverKey = await getAccessToken();
    const String fcmEndpoint = "https://fcm.googleapis.com/v1/projects/han-bab/messages:send";

    // 그룹의 모든 멤버의 토큰 가져오기
    List<String> tokens = await getGroupTokens(groupId);

    for (String token in tokens) {
      final Map<String, dynamic> message = {
        "message": {
          // "token": token,
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
        final http.Response response = await http.post(
          Uri.parse(fcmEndpoint),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $serverKey',
          },
          body: jsonEncode(message),
        );
        if (response.statusCode != 200) {
          print("Error response: ${response.body}");
        }
      } on HttpException catch (error) {
        print("HttpException: ${error.message}");
      }
    }

    return "FCM request sent to all tokens";
  }
}