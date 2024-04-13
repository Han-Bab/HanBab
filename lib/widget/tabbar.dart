import 'package:flutter/material.dart';

Widget tabBar() {
  TabController tabController = TabController(
    length: 3,
    vsync: ScrollableState(),
    initialIndex: 0,
  );

  return TabBar(
    controller: tabController,
    labelColor: Colors.black,
    unselectedLabelColor: Colors.grey,
    labelStyle: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    unselectedLabelStyle: const TextStyle(
      fontSize: 16,
    ),

    /// 탭바 클릭시 나오는 splash effect 컬러
    overlayColor: MaterialStatePropertyAll(
      Colors.blue.shade100,
    ),

    /// 탭바 클릭할 때 나오는 splash effect의 radius
    splashBorderRadius: BorderRadius.circular(20),

    /// 기본 인디캐이터의 컬러
    indicatorColor: Colors.black,

    /// indicator에서  UnderlineTabIndicator를 사용하지 않을 경우
    /// 0으로 설정할 것
    indicatorWeight: 5,

    /// 인디캐이터의 기본 사이즈를 label에 맞출지,
    /// 탭 좌우 사이즈에 맞출지 설정
    indicatorSize: TabBarIndicatorSize.label,

    /// 탭바의 상하좌우에 적용하는 패딩
    padding: const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 20,
    ),

    /// 라벨에 주는 패딩
    labelPadding: const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 10,
    ),

    /// 인디캐이터의 패딩
    indicatorPadding: const EdgeInsets.all(5),

    /// 커스텀 인디캐이터
    indicator: BoxDecoration(
      color: Colors.green.shade400,
      shape: BoxShape.circle,
      border: Border.all(
        color: Colors.orange,
        width: 5,
      ),
    ),

    isScrollable: true,

    onTap: (index) {},
    tabs: const [
      Tab(text: "기숙사"),
      Tab(text: "학과건물"),
      Tab(text: "기타"),
    ],
  );
}
