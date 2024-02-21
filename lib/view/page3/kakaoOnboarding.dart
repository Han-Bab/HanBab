import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class KakaoOnboarding extends StatelessWidget {
  const KakaoOnboarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('카카오페이 연결'),
        titleTextStyle: TextStyle(
          fontSize: 20,
          color: Colors.black,
        ),
        backgroundColor: Color.fromARGB(255, 255, 234, 4), // 앱 바 배경색 설정
      ),
      body: IntroductionScreen(
        pages: [
          PageViewModel(
            title: '카카오톡 접속',
            body: "카카오톡에 접속 후 하단의 5개의 버튼 중 5번째 버튼(…)을 "
                "\n눌러 더보기란으로 이동하고 우측 상단 버튼을 클릭합니다.",
            image: ClipRRect(
              borderRadius: BorderRadius.circular(10.0), // 이미지의 테두리를 둥글게 설정
              child: Image.asset(
                'assets/images/kakao_onboarding1.png',
                fit: BoxFit.cover,
              ),
            ),
            decoration: getPageDecorationCut(screenWidth),
          ),
          PageViewModel(
            title: '송금코드 생성',
            body: "코드를 스캔하는 카메라가 뜨는 화면에서"
                "\n하단의 '송금코드' 버튼을 클릭합니다.",
            image: ClipRRect(
              borderRadius: BorderRadius.circular(10.0), // 이미지의 테두리를 둥글게 설정
              child: Image.asset(
                'assets/images/kakao_onboarding2.png',
                fit: BoxFit.cover,
              ),
            ),
            decoration: getPageDecorationCut(screenWidth),
          ),
          PageViewModel(
            title: '링크 복사',
            image: ClipRRect(
              borderRadius: BorderRadius.circular(10.0), // 이미지의 테두리를 둥글게 설정
              child: Image.asset(
                'assets/images/kakao_onboarding3.png',
                fit: BoxFit.cover,
              ),
            ),
            body: "위의 화면에서 표시된 버튼을 눌러"
                "\n카카오 송금 링크를 복사하면 끝!",
            decoration: getPageDecorationCut(screenWidth),
          ),
        ],
        showSkipButton: true,
        done: const Text(
          "done",
          style: TextStyle(color: Color.fromARGB(255, 232, 194, 42),),
        ),
        onDone: () {
          Navigator.of(context).pop();
        },
        next: const Icon(
          Icons.arrow_forward,
          color: Color.fromARGB(255, 232, 194, 42),
        ),
        skip: const Text(
          "Skip",
          style: TextStyle(color: Color.fromARGB(255, 232, 194, 42),),
        ),
        dotsDecorator: DotsDecorator(
          color: Color.fromARGB(255, 248, 230, 70),
          size: const Size(8, 8),
          activeSize: const Size(8, 8),
          activeColor: Color.fromARGB(255, 225, 187, 32),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        curve: Curves.easeInQuad,
      ),
    );
  }

  PageDecoration getPageDecorationCut(double screenWidth) {
    return PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(255, 255, 255, 255),
      ),
      titlePadding: EdgeInsets.only(bottom: 0),
      bodyTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 13,
        color: Color.fromARGB(255, 255, 255, 255),
      ),
      bodyPadding: EdgeInsets.only(bottom: screenWidth * 0.4),
      imageAlignment: Alignment.topCenter,
      imagePadding: EdgeInsets.only(top: screenWidth * 0.01),
      imageFlex: 6,

      pageColor: Colors.black,
      // boxDecoration: BoxDecoration(
      //   color: Colors.black,
      //   borderRadius: BorderRadius.circular(20), // 이미지 모서리를 둥글게 설정
      // ),
    );
  }
}
