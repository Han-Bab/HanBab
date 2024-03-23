import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:han_bab/controller/signup_controller.dart';
import 'package:han_bab/widget/appBar.dart';
import 'package:provider/provider.dart';
import '../../widget/alert.dart';
import '../../widget/button2.dart';
import 'initial.dart';

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
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              appbar(context, "회원가입"),
              Container(
                padding: const EdgeInsets.fromLTRB(24, 46, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      onChanged: (value) {
                        controller.setName(value);
                      },
                      decoration: InputDecoration(
                        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xffC2C2C2), width: 0.5)),
                        errorText: controller.nameErrorText,
                        hintText: "이름",
                        hintStyle: const TextStyle(color: Color(0xffC2C2C2),
                            fontSize: 18, fontFamily: "PretendardLight"),
                        contentPadding:
                        const EdgeInsets.fromLTRB(0, 10, 10, 10),
                      ),
                    ),
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
                        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xffC2C2C2), width: 0.5)),
                        errorText: controller.emailErrorText,
                        hintText: "이메일",
                        hintStyle: const TextStyle(color: Color(0xffC2C2C2),
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
                              enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xffC2C2C2), width: 0.5)),
                              errorText: controller.phoneErrorText,
                              hintText: "휴대폰 번호",
                              hintStyle: const TextStyle(color: Color(0xffC2C2C2),
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
                          onTap:
                              () async {
                            await controller.verifyPhoneNumber(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0xffFDB168)),
                            child: Padding(
                              padding: !controller.verifying ? const EdgeInsets.fromLTRB(12, 7, 12, 7) : const EdgeInsets.fromLTRB(20, 7, 20, 7),
                              child: Text(
                                !controller.verifying ? "인증요청" : "재요청",
                                style: const TextStyle(
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
            child: Button2(
              function: (controller.name == "" ||
                  controller.email == "" ||
                  controller.phone == "" ||
                  controller.verified == false) ? null : () async {
                // 이메일 중복 검사
                bool isEmailDuplicate =
                await controller.checkEmailDuplicate(controller.email);

                if (isEmailDuplicate) {
                  // 중복된 이메일이 있을 경우
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertModal(
                        text: '중복된 이메일입니다.',
                        yesOrNo: false,
                        function: () {
                        },
                      ));
                } else {
                  // 중복된 이메일이 없을 경우 다음 페이지로 이동
                  Navigator.pushNamed(context, '/signup2');
                }
              },
              title: '다음 단계로 이동하기',
            ),
          ),
        ),
      ),
    );
  }
}