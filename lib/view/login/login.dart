import 'package:flutter/material.dart';
import 'package:han_bab/controller/auth_controller.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: Column(
          children: [
            /// 디자인을 위한 빈 공간 (디자인 해주세요)
            SizedBox(height: screenHeight * 0.55),

            /// 이메일 로그인 버튼
            SizedBox(
              width: screenWidth,
              height: screenHeight * 0.065,
              child: ElevatedButton(
                onPressed: () {
                  authController.signInWithGoogle();
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
            const SizedBox(height: 20),

            /// 구글 로그인 버튼
            ElevatedButton(
              onPressed: () {
                authController.signInWithGoogle();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(10),
                backgroundColor: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('assets/images/glogo.png'),
                  const Text(
                    'Google 로그인',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  Opacity(
                    opacity: 0,
                    child: Image.asset('assets/images/glogo.png'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24.0),
        child: TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/signup1');
          },
          child: const Text('아직 한밥 회원이 아니신가요?'),
        ),
      ),
    );
  }
}
