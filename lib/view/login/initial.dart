import 'package:flutter/material.dart';
import 'package:han_bab/controller/signup_controller.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({super.key});

  @override
  Widget build(BuildContext context) {
    final signupController = Provider.of<SignupController>(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              /// 디자인을 위한 빈 공간 (디자인 해주세요)
              const SizedBox(height: 5),
              Image.asset(
                'assets/images/logoOrange.png',
                scale: 1.5,
              ),
              const SizedBox(height: 35),
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
                child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Lottie.asset('assets/lottie/person.json'),
                    )),
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
                      '로그인',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 48.0),
        child: GestureDetector(
          onTap: () async {
            await signupController.clearAll();
            Navigator.pushNamed(context, '/signup1');
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '회원가입',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.orange),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
