import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:han_bab/controller/verify_controller.dart';
import 'package:han_bab/view/app.dart';
import 'package:han_bab/widget/config.dart';
import 'package:provider/provider.dart';

import '../../controller/signup_controller.dart';

class EmailVerifyPage extends StatefulWidget {
  const EmailVerifyPage({super.key});

  @override
  State<EmailVerifyPage> createState() => _EmailVerifyPageState();
}

class _EmailVerifyPageState extends State<EmailVerifyPage> {
  Timer? timer;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<VerifyController>(context);
    final signUpInfo = Provider.of<SignupController>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    // User? user = FirebaseAuth.instance.currentUser;
    FToast().init(context);
    Color primaryColor = Theme.of(context).primaryColor;

    Future checkEmailVerified() async {
      // 매번 currentUser 의 정보를 reload 하고 확인
      await FirebaseAuth.instance.currentUser!.reload();
      controller
          .setEmailVerified(FirebaseAuth.instance.currentUser!.emailVerified);

      if (controller.isEmailVerified) {
        FToast().showToast(
          child: toastTemplate("환영합니다! ${signUpInfo.name}님", Icons.celebration,
              Theme.of(context).primaryColor),
          gravity: ToastGravity.BOTTOM,
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => const App()), // MyApp 를 메인 페이지로 교체해 주세요.
          (route) => false, // 모든 이전 루트를 제거하여 새로운 페이지로 이동합니다
        );
      } else {
        FToast().showToast(
          child: toastTemplate("이메일을 다시 인증해주세요", Icons.cancel, Colors.red),
          gravity: ToastGravity.CENTER,
        );
      }
    }

    Future sendVerificationEmail() async {
      try {
        final user = FirebaseAuth.instance.currentUser!;
        await user.sendEmailVerification();
        FToast().showToast(
          child: toastTemplate(
              "인증 메일을 재전송했습니다", Icons.send, Theme.of(context).primaryColor),
          gravity: ToastGravity.CENTER,
        );

        // 계속 인증코드를 다시 보낼 수 없으므로 보낼 수 있는 텀을 줌
        controller.setCanResendEmail(false);

        await Future.delayed(const Duration(seconds: 2));
        controller.setCanResendEmail(true);
      } catch (e) {
        print(e);
      }
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 60, 30, 0),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '한밥',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 28,
                ),
              ),
            ),
            const Divider(),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Image.asset(
                      'assets/images/logoOrange.png',
                      scale: 1.5,
                    ),
                  ),
                  const Text(
                    '이메일 인증',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 24),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        const TextSpan(text: "안녕하세요, "),
                        TextSpan(
                          text: signUpInfo.name == "" ? "사용자" : signUpInfo.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(
                          text: "님\n",
                        ),
                        const TextSpan(
                            text: "한밥 서비스 이용을 위해 이메일 주소 인증을 요청하셨습니다.\n"),
                        const TextSpan(
                            text: "이메일 주소 인증 후, 서비스를 정상적으로 이용하실 수 있습니다."),
                      ],
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ),
                  // ElevatedButton(
                  //   onPressed: controller.canResendEmail
                  //       ? sendVerificationEmail
                  //       : null,
                  //   child: const Text('Send verification email'),
                  // ),
                  const SizedBox(
                    height: 24,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      print(FirebaseAuth.instance.currentUser!.emailVerified);
                      checkEmailVerified();
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(screenWidth * 0.6, 42),
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Text(
                        '이메일 확인',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      print('logout');
                      print(FirebaseAuth.instance.currentUser);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(screenWidth * 0.6, 42),
                      //   backgroundColor: Theme.of(context).primaryColor,
                      //   foregroundColor: Colors.white,
                    ),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Text(
                        '돌아가기',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: TextButton(
          onPressed: controller.canResendEmail ? sendVerificationEmail : null,
          child: const Text(
            '인증 메일이 도착하지 않으셨나요?',
            // style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
