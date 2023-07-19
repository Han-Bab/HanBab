import 'package:flutter/material.dart';
import 'package:han_bab/controller/auth_controller.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    double screenHeight = MediaQuery.of(context).size.height;

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
            SizedBox(height: screenHeight * 0.7),

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
    );
  }
}
