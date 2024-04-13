import 'package:flutter/material.dart';
import 'package:han_bab/view/login/initial.dart';

Widget appbar(BuildContext context, String title) {
  return Stack(
    children: [
      Image.asset(
        "./assets/background.png",
        fit: BoxFit.fill,
      ),
      (title != "메뉴" && title != "채팅")
          ? Positioned(
              left: 16.0, // 조정 가능한 값
              bottom: 20.0, // 조정 가능한 값
              child: GestureDetector(
                onTap: () {
                  if (title == "회원가입1") {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const InitialPage()),
                        (route) => false);
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: Image.asset(
                  "./assets/icons/arrow_back.png",
                  scale: 2,
                ),
              ),
            )
          : Container(),
      Positioned(
        left: 0,
        right: 0,
        bottom: 16.0, // 조정 가능한 값
        child: Center(
          child: Text(
            title == "회원가입1" ? "회원가입" : title, // 제목 텍스트
            style: const TextStyle(
                color: Colors.white,
                fontFamily: "PretenderMedium",
                fontSize: 18), // 제목 스타일 설정
          ),
        ),
      ),
    ],
  );
}
