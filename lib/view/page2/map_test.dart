import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class MapTest extends StatelessWidget {
  const MapTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NaverMap(
        options: const NaverMapViewOptions(),
        onMapReady: (controller) {
          print("Naver map Opened!!");
        },
      ),
    );
  }
}
