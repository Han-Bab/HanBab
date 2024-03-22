import 'package:flutter/material.dart';

import 'customToolbarShape.dart';

PreferredSize appbar(BuildContext context, String title) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(80),
    child: Stack(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width, // 전체 화면 너비로 설정
          height: 100, // 원래의 높이를 유지하거나 적절한 값으로 변경
          child: const CustomPaint(
            painter: CustomToolbarShape(lineColor: Colors.orange),
          ),
        ),
        (title != "메뉴" && title != "채팅") ?
        Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 15),
          child: Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    "./assets/icons/arrow_back.png",
                    scale: 2,
                  ))),
        ) : Container(),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              title, // 제목 텍스트
              style: const TextStyle(
                  color: Colors.white,
                  fontFamily: "PretenderMedium",
                  fontSize: 18), // 제목 스타일 설정
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: MediaQuery.of(context).size.width, // 전체 화면 너비로 설정
            height: 20,
            color: Colors.white, // 백그라운드 컬러 설정
          ),
        ),
      ],
    ),
  );
}
