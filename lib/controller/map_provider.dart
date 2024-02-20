import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MapProvider extends ChangeNotifier {
  var json = {};
  var restaurantInfo = {};

  bool haveKakaoInfo = false;

  String restaurantName = '';
  double latitude = 0;
  double longitude = 0;

  ValueKey mapKey = ValueKey(DateTime.now());

  void triggerInit() {
    mapKey = ValueKey(DateTime.now());

    notifyListeners();
  }

  /* 가게 고유 ID */
  String placeImageUrl = '';

  Future<void> getImageUrl(String placeId) async {
    try {
      http.Response response = await http.get(
        Uri.parse("https://place.map.kakao.com/main/v/$placeId"),
      );
      if (response.statusCode == 200) {
        json = jsonDecode(response.body);
        placeImageUrl = json['basicInfo']['mainphotourl'];
      }
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> kakaoLocalSearchKeyword(String keyword) async {
    // _searchList.clear();
    restaurantInfo = {};
    try {
      http.Response response = await http.get(
        Uri.parse(
            "https://dapi.kakao.com/v2/local/search/keyword.json?x=129.388849&y=36.103255&radius=10000&query=$keyword&size=1&category_group_code=FD6,CE7"),
        headers: {
          // 임시입니다
          "Authorization": "KakaoAK 4d056234a214748603ae4c444eae0c5d",
        },
      );
      if (response.statusCode == 200) {
        json = jsonDecode(response.body);
        List<dynamic> doc = json['documents'];
        if (doc.isEmpty) {
          haveKakaoInfo = false;
          print("아쉽게도 위치정보를 제공하지 않는 가게입니다..");
        } else {
          haveKakaoInfo = true;
          restaurantInfo = doc[0];
          restaurantName = keyword;
          latitude = double.parse(restaurantInfo['y']);
          longitude = double.parse(restaurantInfo['x']);
        }
      }
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  void clearAll() {
    json = {};
    restaurantInfo = {};
    restaurantName = '';
    placeImageUrl = '';
    latitude = 0;
    longitude = 0;

    notifyListeners();
  }
}
