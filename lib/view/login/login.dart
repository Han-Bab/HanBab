import 'package:flutter/material.dart';
import 'package:han_bab/controller/auth_controller.dart';
import 'package:han_bab/controller/navigation_controller.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<AuthController>(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xffF97E13),
                  Color(0xffFFCD96),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                      text: const TextSpan(
                    children: [
                      TextSpan(
                        text: '한밥',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 23,
                        ),
                      ),
                      TextSpan(
                        text: '과 함께 맛있는\n한 끼 먹어볼까요 :D',
                        style: TextStyle(
                          color: Color.fromARGB(255, 116, 116, 116),
                          fontSize: 23,
                        ),
                      ),
                    ],
                  )),
                  const SizedBox(
                    height: 50,
                  ),
                  // 이메일 입력
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (value) {
                      controller.setLoginEmail(value!);
                    },
                    onChanged: (value) {
                      controller.setLoginEmail(value);
                    },
                    decoration: const InputDecoration(
                      // errorText: controller.emailErrorText,
                      hintText: "이메일을 입력해주세요",
                      contentPadding: EdgeInsets.fromLTRB(5, 15, 15, 15),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  // 비밀번호 입력폼
                  TextFormField(
                    decoration: const InputDecoration(
                      // errorText: controller.passwordErrorText,
                      hintText: "비밀번호를 입력해주세요",
                      contentPadding: EdgeInsets.fromLTRB(5, 15, 15, 15),
                    ),
                    obscureText: true,
                    onSaved: (value) {
                      controller.setLoginPassword(value!);
                    },
                    onChanged: (value) {
                      controller.setLoginPassword(value);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(vertical: 34, horizontal: 28),
          child: SizedBox(
            height: 42,
            child: ElevatedButton(
              onPressed: () async {
                // if (controller.step1Validation()) {
                //   Navigator.pushNamedAndRemoveUntil(
                //       context, '/signup2', (route) => false);
                // }
                print(NavigationController().selectedIndex);
                print(controller.loginEmail);
                bool success = await controller.login();
                if (success) {
                  controller.verifyCheck(context);
                }
              },
              child: const Text('다음'),
            ),
          ),
        ),
      ),
    );
  }
}
