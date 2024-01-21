import 'package:flutter/material.dart';
import 'package:han_bab/controller/signup_controller.dart';
import 'package:provider/provider.dart';

import '../../widget/button.dart';

class Signup1Page extends StatelessWidget {
  const Signup1Page({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<SignupController>(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('1 / 3'),
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
        body: SingleChildScrollView(
          child: Column(
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
                          text: '을 통해 행복한 식사에\n참여해보세요',
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
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0, left: 5),
                      child: Text(
                        "이메일 주소를 입력해주세요",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // 한동 이메일 입력
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (value) {
                        controller.setEmail(value!);
                      },
                      onChanged: (value) {
                        controller.setEmail(value);
                      },
                      focusNode: controller.emailFocus,
                      decoration: InputDecoration(
                        errorText: controller.emailErrorText,
                        hintText: "example@handong.ac.kr",
                        contentPadding:
                            const EdgeInsets.fromLTRB(5, 15, 15, 15),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0, left: 5),
                      child: Text(
                        "비밀번호를 입력해주세요\n(8자 이상의 영문 + 숫자 + 특수문자 조합)",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // 비밀번호 입력폼
                    TextFormField(
                      decoration: InputDecoration(
                        errorText: controller.passwordErrorText,
                        hintText: "비밀번호를 입력해주세요",
                        contentPadding:
                            const EdgeInsets.fromLTRB(5, 15, 15, 15),
                      ),
                      obscureText: true,
                      focusNode: controller.pwFocus,
                      onSaved: (value) {
                        controller.setPassword(value!);
                      },
                      onChanged: (value) {
                        controller.setPassword(value);
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        errorText: controller.passwordConfirmErrorText,
                        hintText: "비밀번호를 한번 더 입력해주세요",
                        contentPadding:
                            const EdgeInsets.fromLTRB(5, 15, 15, 15),
                      ),
                      focusNode: controller.pwConfirmFocus,
                      obscureText: true,
                      onChanged: (value) {
                        controller.setPasswordConfirm(value);
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(vertical: 34, horizontal: 28),
          child: SizedBox(
            height: 42,
            child: Button(
              backgroundColor: Theme.of(context).primaryColor,
              function: () {
                if (controller.step1Validation()) {
                  Navigator.pushNamed(context, '/signup2');
                }
              },
              title: '다음',
            ),
          ),
        ),
      ),
    );
  }
}
