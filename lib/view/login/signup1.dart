import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:han_bab/controller/signup_controller.dart';
import 'package:han_bab/widget/appBar.dart';
import 'package:provider/provider.dart';
import '../../widget/alert.dart';
import '../../widget/button2.dart';

class Signup1Page extends StatelessWidget {
  Signup1Page({super.key});

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<SignupController>(context);
    final _formKey = GlobalKey<FormState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                appbar(context, "회원가입1"),
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 46, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '이름을 입력하세요';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffC2C2C2), width: 0.5)),
                          errorText: controller.nameErrorText,
                          hintText: "이름",
                          hintStyle: const TextStyle(
                              color: Color(0xffC2C2C2), fontSize: 18, fontFamily: "PretendardLight"),
                          contentPadding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                        ),
                      ),
                      const SizedBox(height: 27),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '이메일을 입력하세요';
                          }
                          // 이메일 형식 검사 및 도메인 검사
                          final emailRegex = RegExp(r'^[\w-\.]+@handong\.ac\.kr$');
                          if (!emailRegex.hasMatch(value)) {
                            return '유효한 @handong.ac.kr 이메일을 입력하세요';
                          }
                          return null;
                        },
                        focusNode: controller.emailFocus,
                        decoration: InputDecoration(
                          enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffC2C2C2), width: 0.5)),
                          errorText: controller.emailErrorText,
                          hintText: "이메일        예시) example@handong.ac.kr",
                          hintStyle: const TextStyle(
                              color: Color(0xffC2C2C2), fontSize: 18, fontFamily: "PretendardLight"),
                          contentPadding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                        ),
                      ),
                      const SizedBox(height: 27),
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '휴대폰 번호를 입력하세요';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffC2C2C2), width: 0.5)),
                          errorText: controller.phoneErrorText,
                          hintText: "휴대폰 번호",
                          hintStyle: const TextStyle(
                              color: Color(0xffC2C2C2), fontSize: 18, fontFamily: "PretendardLight"),
                          contentPadding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                        ),
                        inputFormatters: [
                          MaskedInputFormatter("000-0000-0000")
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(vertical: 34, horizontal: 28),
          child: SizedBox(
            height: 60,
            child: Button2(
              function: (nameController.text.isEmpty ||
                  emailController.text.isEmpty ||
                  phoneController.text.isEmpty) ? null : () async {
                if (_formKey.currentState!.validate()) {
                  // 버튼을 눌렀을 때 모든 값을 controller에 저장
                  controller.setName(nameController.text);
                  controller.setEmail(emailController.text);
                  controller.setPhone(phoneController.text);

                  bool isEmailDuplicate = await controller.checkEmailDuplicate(controller.email);
                  if (isEmailDuplicate) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertModal(
                        text: '중복된 이메일입니다.',
                        yesOrNo: false,
                        function: () {},
                      ),
                    );
                  } else {
                    Navigator.pushNamed(context, '/signup2');
                  }
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
