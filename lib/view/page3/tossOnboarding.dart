import 'package:flutter/material.dart';
// import 'package:onboarding/onboarding.dart';
import 'package:introduction_screen/introduction_screen.dart';

class TossOnboarding extends StatelessWidget {
  const TossOnboarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
            title: "토스 앱 접속",
            body: "토스에 접속 후 전체 메뉴에서 송금 카테고리의"
                "\n'내 토스아이디' 버튼을 클릭합니다.",
            image: Image.asset("assets/images/토스1.png"),
            decoration: getPageDecorationFull()),
        PageViewModel(
            title: "토스아이디 설명",
            body: "간단한 설명을 읽고"
                "\n하단의 버튼을 클릭합니다.",
            image: Image.asset("assets/images/토스2.png"),
            decoration: getPageDecorationFull()),
        // 칸 때문에 3 없앰
        PageViewModel(
            title: "아이디 생성",
            body: "5글자 이상의 아이디를 입력합니다."
                "\n(영어로 만들어 두는 것이 편합니다!)",
            image: Image.asset("assets/images/토스4.jpg"),
            decoration: getPageDecorationFull()),
        // 필요없어 보여서 없앰
        PageViewModel(
            title: "아이디 공유",
            body: "아이디 생성 후 내 프로필에서"
                "\n'내 아이디 공유' 버튼을 클릭합니다.",
            image: Image.asset("assets/images/토스6.png"),
            decoration: getPageDecorationFull()),
        PageViewModel(
            title: "링크 복사",
            body: "위의 화면에서 표시된 버튼을 눌러"
                "\n토스 송금 링크를 복사하면 끝!",
            image: Image.asset("assets/images/토스7.png"),
            decoration: getPageDecorationFull()),
      ],
      showSkipButton: true,
      done: const Text(
        "done",
        style: TextStyle(color: Colors.blue),
      ),
      onDone: () {
        Navigator.of(context).pop();
      },
      next: const Icon(
        Icons.arrow_forward,
        color: Colors.blue,
      ),
      skip: const Text(
        "Skip",
        style: TextStyle(color: Colors.blue),
      ),
      dotsDecorator: DotsDecorator(
        color: Colors.lightBlueAccent,
        size: const Size(10, 10),
        activeSize: const Size(20, 10),
        activeColor: Colors.blue,
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      curve: Curves.bounceOut,
    );
  }

  PageDecoration getPageDecorationFull() {
    return const PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      titlePadding: EdgeInsets.only(bottom: 10),
      bodyTextStyle: TextStyle(
        fontSize: 18,
        color: Colors.white70,
      ),
      imagePadding: EdgeInsets.only(top: 70),
      imageFlex: 5,
      pageColor: Color(0xFF3268E8),
    );
  }
}
