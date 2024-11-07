import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:han_bab/database/databaseService.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:shared_preferences/shared_preferences.dart';

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
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      // 1. 로컬 스토리지에서 groupId에 해당하는 데이터 가져오기
      String? tokensJson = prefs.getString(groupId);

      if (tokensJson != null) {
        // 로컬 스토리지에 데이터가 존재하는 경우
        print("로컬 스토리지에 키값 존재");
        tokens = List<String>.from(jsonDecode(tokensJson));
      } else {
        // 로컬 스토리지에 데이터가 없는 경우 Firestore에서 가져오기
        print("로컬 스토리지에 키값 존재 안함");
        DocumentSnapshot groupSnapshot = await FirebaseFirestore.instance
            .collection('groups')
            .doc(groupId)
            .get();

        if (groupSnapshot.exists) {
          List<dynamic> rawTokens = groupSnapshot.get('tokens');
          tokens = rawTokens.cast<String>();
          // Firestore에서 가져온 데이터를 로컬 스토리지에 저장
          await prefs.setString(groupId, jsonEncode(tokens));
        }
      }
    } catch (e) {
      print("Error getting group tokens: $e");
    }

    return tokens;
  }

  /// 나의 토큰은 제외하는 함수
  Future<List<String>> filterOutMyToken(List<String> tokens) async {
    try {
      String myToken = await DatabaseService().getToken();
      return tokens.where((token) => token != myToken).toList();
    } catch (e) {
      print("Error filtering out my token: $e");
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
    tokens = await filterOutMyToken(tokens);

    for (String token in tokens) {
      final Map<String, dynamic> message = {
        "message": {
          "token": token,
          // "topic": groupId,
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