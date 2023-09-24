import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:han_bab/view/page3/profile.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:han_bab/controller/navigation_controller.dart';
import 'package:provider/provider.dart';

class KakaoOnboarding extends StatelessWidget {
  const KakaoOnboarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
            title: '카카오페이',
            body: '마음 놓고\n'
                '금융하다',
            image: Image.asset('assets/images/kakao_onboarding.jpg'),
            decoration: getPageDecorationFull()),
        PageViewModel(
            // 두번째 페이지
            title: '카카오페이',
            body: '필요할 때 언제든\n'
                '마음 놓고 결제!',
            image: Image.asset('assets/images/kakao_onboarding_1.png'),
            decoration: getPageDecorationCut()),
        PageViewModel(
            // 세번째 페이지
            title: '카카오페이',
            image: Image.asset('assets/images/kakao_onboarding_2.png'),
            body: '편하고 빠르게\n'
                '마음 놓고 송금!',
            decoration: getPageDecorationCut()),
        PageViewModel(
            // 네번째 페이지
            title: '카카오페이',
            image: Image.asset('assets/images/kakao_onboarding_3.png'),
            body: '돈이 보이니\n'
                '마음 놓고 투자!',
            decoration: getPageDecorationCut()),
      ],
      done: const Text(
        '완료',
        style: TextStyle(
          fontSize: 20,
          color: Color.fromARGB(255, 255, 215, 0),
        ),
      ),
      onDone: () {
        Navigator.of(context).pop();
      },
      next: const Icon(
        Icons.arrow_forward_ios,
        color: Color.fromARGB(255, 255, 215, 0),
        size: 24.0,
      ),
      showBackButton: true,
      back: const Icon(
        Icons.arrow_back_ios,
        color: Color.fromARGB(255, 255, 215, 0),
        size: 24.0,
      ),
      dotsDecorator: DotsDecorator(
        color: const Color.fromARGB(255, 255, 255, 130),
        activeColor: const Color.fromARGB(255, 255, 215, 0),
        size: const Size(7, 7),
        activeSize: Size(10, 10),
        spacing: EdgeInsets.all(8),
      ),
    );
  }

  PageDecoration getPageDecorationFull() {
    return const PageDecoration(
      titlePadding: EdgeInsets.only(top: 50, bottom: 100),
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      bodyTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 40,
        color: Colors.black,
      ),
      pageColor: Color.fromARGB(255, 245, 245, 245), // 배경색상
    );
  }

  PageDecoration getPageDecorationCut() {
    return const PageDecoration(
      titlePadding: EdgeInsets.only(top: 50, bottom: 100),
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      imagePadding: const EdgeInsets.all(20),
      bodyTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 40,
        color: Colors.black,
      ),
      pageColor: Color.fromARGB(255, 245, 245, 245), // 배경색상
    );
  }
}
