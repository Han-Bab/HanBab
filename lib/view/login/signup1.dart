import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:han_bab/controller/signup_controller.dart';
import 'package:provider/provider.dart';

import '../../color_schemes.dart';
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
          title: const Text('회원가입'),
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
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      onChanged: (value) {
                        controller.setName(value);
                      },
                      decoration: InputDecoration(
                        errorText: controller.nameErrorText,
                        hintText: "이름",
                        hintStyle: const TextStyle(
                            fontSize: 18, fontFamily: "PretendardLight"),
                        contentPadding:
                            const EdgeInsets.fromLTRB(0, 10, 10, 10),
                      ),
                    ),
                    // TextFormField(
                    //   keyboardType: TextInputType.emailAddress,
                    //   onSaved: (value) {
                    //     controller.setEmail(value!);
                    //   },
                    //   onChanged: (value) {
                    //     controller.setEmail(value);
                    //   },
                    //   focusNode: controller.emailFocus,
                    //   decoration: InputDecoration(
                    //     errorText: controller.emailErrorText,
                    //     hintText: "example@handong.ac.kr",
                    //     contentPadding:
                    //         const EdgeInsets.fromLTRB(5, 15, 15, 15),
                    //   ),
                    // ),
                    const SizedBox(
                      height: 27,
                    ),
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
                        hintText: "이메일",
                        hintStyle: const TextStyle(
                            fontSize: 18, fontFamily: "PretendardLight"),
                        contentPadding:
                            const EdgeInsets.fromLTRB(0, 10, 10, 10),
                      ),
                    ),
                    const SizedBox(
                      height: 27,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.phone,
                            onChanged: (value) {
                              controller.setPhone(value);
                            },
                            decoration: InputDecoration(
                              errorText: controller.phoneErrorText,
                              hintText: "휴대폰 번호",
                              hintStyle: const TextStyle(
                                  fontSize: 18, fontFamily: "PretendardLight"),
                              contentPadding:
                                  const EdgeInsets.fromLTRB(0, 10, 10, 10),
                            ),
                            inputFormatters: [
                              MaskedInputFormatter("000-0000-0000")
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 18,
                        ),
                        GestureDetector(
                          onTap: !controller.verified &&
                                  controller.phone != "" &&
                                  !controller.verifying
                              ? () async {
                                  await controller.verifyPhoneNumber(context);
                                }
                              : null,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: !controller.verified &&
                                        controller.phone != "" &&
                                        !controller.verifying
                                    ? const Color(0xffFDB168)
                                    : const Color(0xffC2C2C2)),
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(12, 7, 12, 7),
                              child: Text(
                                "인증요청",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "PretendardMedium",
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 27,
                    ),
                    controller.verifying
                        ? controller.verifyCode(context)
                        : Container(),

                    // 비밀번호 입력폼
                    // TextFormField(
                    //   decoration: InputDecoration(
                    //     errorText: controller.passwordErrorText,
                    //     hintText: "비밀번호를 입력해주세요",
                    //     contentPadding:
                    //         const EdgeInsets.fromLTRB(5, 15, 15, 15),
                    //   ),
                    //   obscureText: true,
                    //   focusNode: controller.pwFocus,
                    //   onSaved: (value) {
                    //     controller.setPassword(value!);
                    //   },
                    //   onChanged: (value) {
                    //     controller.setPassword(value);
                    //   },
                    // ),

                    // TextFormField(
                    //   decoration: InputDecoration(
                    //     errorText: controller.passwordConfirmErrorText,
                    //     hintText: "비밀번호를 한번 더 입력해주세요",
                    //     contentPadding:
                    //         const EdgeInsets.fromLTRB(5, 15, 15, 15),
                    //   ),
                    //   focusNode: controller.pwConfirmFocus,
                    //   obscureText: true,
                    //   onChanged: (value) {
                    //     controller.setPasswordConfirm(value);
                    //   },
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(vertical: 34, horizontal: 28),
          child: SizedBox(
            height: 60,
            child: Button(
              function: controller.name == "" ||
                      controller.email == "" ||
                      controller.phone == "" ||
                      controller.verified == false
                  ? null
                  : () {
                      Navigator.pushNamed(context, '/signup2');
                    },
              title: '다음 단계로 이동하기',
            ),
          ),
        ),
      ),
    );
  }
}
