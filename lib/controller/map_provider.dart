import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MapProvider extends ChangeNotifier {
  final _searchList = ['현재 검색결과가 없습니다'];
  get searchList => _searchList;

  var json = {};

  Map<String, dynamic> selectedJson = {};
  String selectedName = '';
  double selectedLatitude = 0;
  double selectedLongitude = 0;

  void setSelectedJson(String selection) {
    selectedJson =
        json['documents'].firstWhere((d) => d['place_name'] == selection);

    print(selectedJson);

    selectedName = selection;
    selectedLatitude = double.parse(selectedJson['y']);
    selectedLongitude = double.parse(selectedJson['x']);

    notifyListeners();
  }

  Future<void> kakaoLocalSearchKeyword(String keyword) async {
    _searchList.clear();
    try {
      http.Response response = await http.get(
        Uri.parse(
            "https://dapi.kakao.com/v2/local/search/keyword.json?x=129.388849&y=36.103255&radius=10000&query=$keyword&size=5&category_group_code=FD6,CE7"),
        headers: {
          // 임시입니다
          "Authorization": "KakaoAK 4d056234a214748603ae4c444eae0c5d",
        },
      );
      if (response.statusCode == 200) {
        json = jsonDecode(response.body);
        // print(json['documents']);
        for (var item in json['documents']) {
          _searchList.add(item['place_name']);
        }
      }
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  void clearAll() {
    _searchList.clear();
    json = {};
    selectedJson = {};
    selectedName = '';
    selectedLatitude = 0;
    selectedLongitude = 0;

    notifyListeners();
  }
}
