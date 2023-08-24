import 'package:flutter/material.dart';
import 'package:han_bab/controller/auth_controller.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            /// 디자인을 위한 빈 공간 (디자인 해주세요)
            SizedBox(height: 5),
            Image.asset(
              'assets/images/logoOrange.png',
              scale: 2,
            ),
            SizedBox(height: 35),
            const Text(
              '서로의 뜻을 모아 모두가 행복한 시간',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xff717171),
              ),
            ),
            const Text(
              '한동 밥먹자에서 시작하세요',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xff717171),
              ),
            ),

            Expanded(
              child: Stack(
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: Lottie.asset('assets/lottie/person.json'),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 35, left: 194),
                    child: Container(
                      color: Color(0xffFFFBFF),
                      width: 140,
                      height: 250,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 120, bottom: 90.0),
                    child: Container(height: 300,child: Lottie.asset('assets/lottie/chatting.json')),
                  )
                ],
              ),
            ),

            /// 이메일 로그인 버튼
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: SizedBox(
                width: screenWidth,
                height: screenHeight * 0.065,
                child: ElevatedButton(
                  onPressed: () {
                    // authController.signInWithGoogle();
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(10),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: const Text(
                    '이메일로 로그인',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            // const SizedBox(height: 20),

            /// 구글 로그인 버튼
            // ElevatedButton(
            //   onPressed: () {
            //     authController.signInWithGoogle();
            //   },
            //   style: ElevatedButton.styleFrom(
            //     padding: const EdgeInsets.all(10),
            //     backgroundColor: Colors.white,
            //   ),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Image.asset('assets/images/glogo.png'),
            //       const Text(
            //         'Google 로그인',
            //         style: TextStyle(
            //           fontSize: 15,
            //           color: Colors.black,
            //         ),
            //       ),
            //       Opacity(
            //         opacity: 0,
            //         child: Image.asset('assets/images/glogo.png'),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 48.0),
        child: TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/signup1');
          },
          child: const Text(
            '아직 한밥 회원이 아니신가요?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}