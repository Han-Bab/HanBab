import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:han_bab/controller/navigation_controller.dart';
import 'package:han_bab/controller/verify_controller.dart';
import 'package:provider/provider.dart';

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
    // User? user = FirebaseAuth.instance.currentUser;
    FToast().init(context);
    Color primaryColor = Theme.of(context).primaryColor;

    Future checkEmailVerified() async {
      // 매번 currentUser 의 정보를 reload 하고 확인
      await FirebaseAuth.instance.currentUser!.reload();

      controller
          .setEmailVerified(FirebaseAuth.instance.currentUser!.emailVerified);
    }

    Future sendVerificationEmail() async {
      try {
        final user = FirebaseAuth.instance.currentUser!;
        await user.sendEmailVerification();

        // 계속 인증코드를 다시 보낼 수 없으므로 보낼 수 있는 텀을 줌
        controller.setCanResendEmail(false);

        await Future.delayed(const Duration(seconds: 2));
        controller.setCanResendEmail(true);
      } catch (e) {
        print(e);
      }
    }

    if (controller.isEmailVerified) {
      // 인증 완료 dialog
      return NavigationController().getPageByIndex();
    } else {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Please verify your email to proceed.'),
              const SizedBox(height: 16),
              const Text('Verification not completed'),
              ElevatedButton(
                onPressed:
                    controller.canResendEmail ? sendVerificationEmail : null,
                child: const Text('Send verification email'),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  print('logout');
                  print(FirebaseAuth.instance.currentUser);
                },
                style:
                    ElevatedButton.styleFrom(padding: const EdgeInsets.all(10)),
                child: const Text('Logout'),
              ),
              ElevatedButton(
                onPressed: () async {
                  checkEmailVerified();
                  print(FirebaseAuth.instance.currentUser!.emailVerified);
                },
                style:
                    ElevatedButton.styleFrom(padding: const EdgeInsets.all(10)),
                child: const Text('Check Verificaiton'),
              ),
            ],
          ),
        ),
      );
    }
  }
}
