import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class TossOnboarding extends StatelessWidget {
  const TossOnboarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('토스페이 연결'),
        backgroundColor: Color.fromARGB(255, 1, 90, 254), // AppBar 배경색 설정
      ),
      body: IntroductionScreen(
        pages: [
          PageViewModel(
            title: "토스 앱 접속",
            body: "토스에 접속 후 전체 메뉴에서 송금 카테고리의"
                "\n'내 토스아이디' 버튼을 클릭합니다.",
            image: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0), // 테두리를 둥글게 설정
              ),
              child: Image.asset(
                "assets/images/토스1.png",
                height: screenHeight * 0.96,
              ),
            ),

            decoration: getPageDecorationFull(screenHeight, screenWidth),
          ),
          PageViewModel(
            title: "토스아이디 설명",
            body: "간단한 설명을 읽고"
                "\n하단의 버튼을 클릭합니다.",
            image: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0), // 테두리를 둥글게 설정
              ),
              child: Image.asset(
                "assets/images/토스2.png",
                height: screenHeight * 0.96,
              ),
            ),
            decoration: getPageDecorationFull(screenHeight, screenWidth),
          ),
          PageViewModel(
            title: "아이디 생성",
            body: "5글자 이상의 아이디를 입력합니다."
                "\n(영어로 만들어 두는 것이 편합니다!)",
            image: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0), // 테두리를 둥글게 설정
              ),
              child: Image.asset(
                "assets/images/토스4.jpg",
                height: screenHeight * 0.96,
              ),
            ),
            decoration: getPageDecorationFull(screenHeight, screenWidth),
          ),

          PageViewModel(
            title: "아이디 공유",
            body: "아이디 생성 후 내 프로필에서"
                "\n'내 아이디 공유' 버튼을 클릭합니다.",
            image: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0), // 테두리를 둥글게 설정
              ),
              child: Image.asset(
                "assets/images/토스6.png",
                height: screenHeight * 0.96,
              ),
            ),
            decoration: getPageDecorationFull(screenHeight, screenWidth),
          ),
          PageViewModel(
            title: "링크 복사",
            body: "위의 화면에서 표시된 버튼을 눌러"
                "\n토스 송금 링크를 복사하면 끝!",
            image: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0), // 테두리를 둥글게 설정
              ),
              child: Image.asset(
                "assets/images/토스7.png",
                height: screenHeight * 0.96,
              ),
            ),
            decoration: getPageDecorationFull(screenHeight, screenWidth),
          ),
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
          size: const Size(8, 8),
          activeSize: const Size(8, 8),
          activeColor: Colors.blue,
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        curve: Curves.easeInQuad,
      ),
    );
  }

  PageDecoration getPageDecorationFull(double screenHeight, double screenWidth) {
    return PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFFFFFFFF),
      ),
      titlePadding: EdgeInsets.only(bottom: 0),
      bodyTextStyle: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Color(0xFFFFFFFF),
      ),
      bodyPadding: EdgeInsets.only(bottom: screenHeight * 0.1),
      imagePadding: EdgeInsets.only(top: screenHeight * 0.01),
      imageFlex: 6,
      pageColor: Colors.black,
    );
  }
}
