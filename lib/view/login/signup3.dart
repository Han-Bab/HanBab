import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:han_bab/controller/signup_controller.dart';
import 'package:han_bab/widget/config.dart';
import 'package:provider/provider.dart';

import '../../widget/button.dart';

class Signup3Page extends StatelessWidget {
  const Signup3Page({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<SignupController>(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('3 / 3'),
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
                          text: '을 사용하기 전\n약관에 동의해주세요 :)',
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              controller
                                  .setAllSelected(!controller.allSelected);
                            },
                            child: Row(
                              children: [
                                Checkbox(
                                  value: controller.allSelected,
                                  visualDensity: VisualDensity.compact,
                                  onChanged: (selected) {
                                    controller.setAllSelected(selected!);
                                  },
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  '모두 동의합니다',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(),
                          GestureDetector(
                            onTap: () {
                              controller.setOption1Selected(
                                  !controller.option1Selected);
                            },
                            child: Row(
                              children: [
                                Checkbox(
                                  value: controller.option1Selected,
                                  visualDensity: VisualDensity.compact,
                                  onChanged: (selected) {
                                    controller.setOption1Selected(selected!);
                                  },
                                ),
                                const SizedBox(width: 10),
                                const Expanded(
                                  child: Text(
                                    '한밥 이용약관 동의',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              controller.setOption2Selected(
                                  !controller.option2Selected);
                            },
                            child: Row(
                              children: [
                                Checkbox(
                                  value: controller.option2Selected,
                                  visualDensity: VisualDensity.compact,
                                  onChanged: (selected) {
                                    controller.setOption2Selected(selected!);
                                  },
                                ),
                                const SizedBox(width: 10),
                                const Expanded(
                                  child: Text(
                                    '개인정보 수집 및 이용 동의',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
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
              function: () async {
                if (controller.optionsValidation()) {
                  // DEBUG
                  controller.printAll();
                  await controller.register();
                  Future.delayed(const Duration(seconds: 1));
                  try {
                    final user = FirebaseAuth.instance.currentUser!;
                    await user.sendEmailVerification();
                  } catch (e) {
                    print(e);
                  }
                  Navigator.pushNamed(context, '/verify');
                } else {
                  FToast().init(context);
                  FToast().showToast(
                    child: toastTemplate('약관에 동의해주세요', Icons.check,
                        Theme.of(context).primaryColor),
                    gravity: ToastGravity.CENTER,
                  );
                }
              },
              title: '회원가입',
            ),
          ),
        ),
      ),
    );
  }
}
