import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:han_bab/controller/signup_controller.dart';
import 'package:provider/provider.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

import '../../color_schemes.dart';
import '../../widget/button.dart';
import '../../widget/encryption.dart';

class Signup2Page extends StatefulWidget {
  const Signup2Page({super.key});

  @override
  State<Signup2Page> createState() => _Signup2PageState();
}

class _Signup2PageState extends State<Signup2Page> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController accountController = TextEditingController();
  var controller = null;

  @override
  void initState() {
    super.initState();
    controller = Provider.of<SignupController>(context, listen: false);
    nameController = TextEditingController(text: controller.name);
    phoneController = TextEditingController(text: controller.phone);
    accountController = TextEditingController(
        text: AccountEncryption.decryptWithAESKey(controller.encryptAccount));
  }

  @override
  void dispose() {
    // 컨트롤러들을 정리해주어야 합니다.
    nameController.dispose();
    phoneController.dispose();
    accountController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller = Provider.of<SignupController>(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('2 / 3'),
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
                      "이름을 입력해주세요",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: nameController,
                    onChanged: (value) {
                      controller.setName(value);
                    },
                    decoration: InputDecoration(
                      errorText: controller.nameErrorText,
                      hintText: "이름을 입력해주세요",
                      contentPadding: const EdgeInsets.fromLTRB(5, 15, 15, 15),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8.0, left: 5),
                    child: Text(
                      "전화번호를 입력해주세요",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          onChanged: (value) {
                            controller.setPhone(value);
                          },
                          decoration: InputDecoration(
                            errorText: controller.phoneErrorText,
                            hintText: "전화번호를 입력해주세요",
                            contentPadding:
                            const EdgeInsets.fromLTRB(5, 15, 15, 15),
                          ),
                          inputFormatters: [
                            MaskedInputFormatter("000-0000-0000")
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: !controller.verified
                            ? () async {
                          await controller.verifyPhoneNumber(context);
                        }
                            : null,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: !controller.verified
                                  ? lightColorScheme.primary
                                  : Colors.grey[300]),
                          child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text(
                              "인증요청",
                              style: TextStyle(
                                  color: !controller.verified
                                      ? Colors.white
                                      : Colors.grey[600]),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8.0, left: 5),
                    child: Text(
                      "사용하실 계좌번호를 입력해주세요 (선택)",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: accountController,
                    onChanged: (value) {
                      controller.setEncryptAccount(value);
                    },
                    decoration: const InputDecoration(
                      hintText: "예) 1002452023325 우리",
                      contentPadding: EdgeInsets.fromLTRB(5, 15, 15, 15),
                    ),
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
              child: Button(
                function: controller.verified
                    ? () {
                  if (controller.step2Validation()) {
                    Navigator.pushNamed(context, '/signup3');
                  }
                }
                    : null,
                title: '다음',
              )),
        ),
      ),
    );
  }
}