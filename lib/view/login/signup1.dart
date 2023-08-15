import 'package:flutter/material.dart';
import 'package:han_bab/controller/login_controller.dart';
import 'package:provider/provider.dart';

class Signup1Page extends StatelessWidget {
  const Signup1Page({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<LoginController>(context);

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
                      "이메일 주소를 입력해주세요",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // 한동 이메일 입력
                  TextFormField(
                    // controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    // validator: (value) {
                    //   if (value!.isEmpty) {
                    //     return "이메일을 입력해주세요";
                    //   }
                    //   return null;
                    // },
                    onSaved: (value) {
                      controller.setEmail(value!);
                    },
                    onChanged: (value) {
                      controller.setEmail(value);
                    },
                    focusNode: controller.emailFocus,
                    decoration: const InputDecoration(
                      hintText: "example@handong.ac.kr",
                      contentPadding: EdgeInsets.fromLTRB(5, 15, 15, 15),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8.0, left: 5),
                    child: Text(
                      "비밀번호를 입력해주세요",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // 비밀번호 입력폼
                  TextFormField(
                    // validator: (value) {
                    //   if (value!.isEmpty || value.length < 6) {
                    //     return "비밀번호는 최소 6자 이상 입력해주세요";
                    //   }
                    //   return null;
                    // },
                    decoration: const InputDecoration(
                      hintText: "비밀번호를 입력해주세요 (8~20자)",
                      contentPadding: EdgeInsets.fromLTRB(5, 15, 15, 15),
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
                    // validator: (value) {
                    //   if (value != userInfo['userPW']) {
                    //     return '비밀번호가 일치하지 않습니다';
                    //   }
                    //   return null;
                    // },
                    decoration: const InputDecoration(
                      hintText: "비밀번호를 한번 더 입력해주세요",
                      contentPadding: EdgeInsets.fromLTRB(5, 15, 15, 15),
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
                  //       const Padding(
                  //         padding: EdgeInsets.only(bottom: 8.0),
                  //         child: Text(
                  //           "이름",
                  //           style: TextStyle(
                  //             fontWeight: FontWeight.bold,
                  //           ),
                  //         ),
                  //       ),
                  //       TextFormField(
                  //         onChanged: (value) {
                  //           userInfo['userName'] = value;
                  //         },
                  //         validator: (value) {
                  //           if (value!.isEmpty) {
                  //             return "이름을 입력해주세요";
                  //           }
                  //           return null;
                  //         },
                  //         decoration: const InputDecoration(
                  //           hintText: "이름을 입력해주세요",
                  //           contentPadding: EdgeInsets.fromLTRB(5, 15, 15, 15),
                  //         ),
                  //       ),
                  //       const SizedBox(
                  //         height: 20,
                  //       ),
                  //       const Padding(
                  //         padding: EdgeInsets.only(bottom: 8.0),
                  //         child: Text(
                  //           "휴대폰",
                  //           style: TextStyle(
                  //             fontWeight: FontWeight.bold,
                  //           ),
                  //         ),
                  //       ),
                  //       TextFormField(
                  //         controller: _phoneNumberController,
                  //         keyboardType: TextInputType.phone,
                  //         validator: (value) {
                  //           if (value!.isEmpty || value.length != 13) {
                  //             return "올바른 전화번호를 입력해주세요";
                  //           }
                  //           return null;
                  //         },
                  //         onChanged: (value) {
                  //           userInfo['userPhone'] = value;
                  //         },
                  //         decoration: const InputDecoration(
                  //           hintText: "010-0000-0000",
                  //           contentPadding: EdgeInsets.fromLTRB(5, 15, 15, 15),
                  //         ),
                  //         inputFormatters: [MaskedInputFormatter("000-0000-0000")],
                  //       ),
                  //       const SizedBox(
                  //         height: 20,
                  //       ),
                  //       const Padding(
                  //         padding: EdgeInsets.only(bottom: 8.0),
                  //         child: Text(
                  //           "닉네임",
                  //           style: TextStyle(
                  //             fontWeight: FontWeight.bold,
                  //           ),
                  //         ),
                  //       ),
                  //       Row(
                  //         children: [
                  //           SizedBox(
                  //             width: width * 0.65,
                  //             child: TextFormField(
                  //               onChanged: (value) {
                  //                 _isClicked = false;
                  //                 userInfo['userNickName'] = value;
                  //               },
                  //               validator: (value) {
                  //                 if (value!.isEmpty) {
                  //                   return "닉네임을 입력해주세요";
                  //                 }
                  //                 if (value.length > 7) {
                  //                   return "7자 이하로 설정해주세요";
                  //                 }
                  //                 if (!_isClicked) {
                  //                   return '중복 확인을 해주세요';
                  //                 } else if (!authController.isUniqueNick.value) {
                  //                   return '중복된 닉네임이 존재합니다';
                  //                 }

                  //                 return null;
                  //               },
                  //               decoration: const InputDecoration(
                  //                 hintText: "닉네임을 입력해주세요",
                  //                 contentPadding: EdgeInsets.fromLTRB(5, 15, 15, 15),
                  //               ),
                  //             ),
                  //           ),
                  //           const SizedBox(
                  //             width: 10,
                  //           ),
                  //           Flexible(
                  //             fit: FlexFit.loose,
                  //             child: TextButton(
                  //               onPressed: () async {
                  //                 _isClicked = true;
                  //                 try {
                  //                   print('닉네임 중복 체크');
                  //                   authController.isUniqueNick.value =
                  //                       await authController
                  //                           .checkNickName(userInfo['userNickName']);
                  //                 } catch (e) {
                  //                   print(e.toString());
                  //                 }
                  //                 _tryValidation();
                  //                 if (userInfo['userNickName'] != '' &&
                  //                     userInfo['userNickName'].toString().length <= 7) {
                  //                   if (authController.isUniqueNick.value) {
                  //                     _showToast("사용하실 수 있는 닉네임입니다!", Icons.check,
                  //                         Colors.green);
                  //                   } else {
                  //                     _showToast("이미 사용하고 있는 닉네임입니다!",
                  //                         Icons.cancel_outlined, Colors.orange);
                  //                   }
                  //                 }
                  //               },
                  //               style: TextButton.styleFrom(
                  //                 foregroundColor: Colors.white,
                  //                 backgroundColor: Colors.orange,
                  //                 padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  //               ),
                  //               child: const Text('중복'),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // const Divider(
                  //   color: Color(0xffF2F2F5),
                  //   thickness: 10,
                  // ),
                  // Container(
                  //   padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                  //   child: const Row(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Padding(
                  //         padding: EdgeInsets.only(bottom: 8.0),
                  //         child: Text(
                  //           "이용약관동의",
                  //           style: TextStyle(
                  //             fontWeight: FontWeight.bold,
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // Container(
                  //   padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Row(
                  //         children: [
                  //           Expanded(
                  //             child: CheckboxListTile(
                  //               visualDensity:
                  //                   const VisualDensity(horizontal: -4, vertical: -4),
                  //               dense: true,
                  //               contentPadding: EdgeInsets.zero,
                  //               title: const Text(
                  //                 "한밥 이용약관",
                  //               ),
                  //               value: _isChecked1,
                  //               onChanged: (value) {
                  //                 setState(() {
                  //                   _isChecked1 = value!;
                  //                 });
                  //               },
                  //               activeColor: Colors.black,
                  //               checkColor: Colors.white,
                  //               checkboxShape: RoundedRectangleBorder(
                  //                 borderRadius: BorderRadius.circular(25),
                  //               ),
                  //               controlAffinity: ListTileControlAffinity.leading,
                  //             ),
                  //           ),
                  //           IconButton(
                  //             onPressed: () {
                  //               Get.to(() => const AccountTerm());
                  //             },
                  //             icon: const Icon(
                  //               Icons.arrow_forward_ios_rounded,
                  //               size: 12,
                  //             ),
                  //             padding: const EdgeInsets.only(left: 20), // 패딩 설정
                  //             constraints: const BoxConstraints(),
                  //           ),
                  //         ],
                  //       ),
                  //       Row(
                  //         children: [
                  //           Expanded(
                  //             child: CheckboxListTile(
                  //               dense: true,
                  //               visualDensity:
                  //                   const VisualDensity(horizontal: -4, vertical: -4),
                  //               contentPadding: EdgeInsets.zero,
                  //               title: const Text(
                  //                 "개인정보 수집 및 이용 동의",
                  //               ),
                  //               value: _isChecked2,
                  //               onChanged: (value) {
                  //                 setState(() {
                  //                   _isChecked2 = value!;
                  //                 });
                  //               },
                  //               activeColor: Colors.black,
                  //               checkColor: Colors.white,
                  //               checkboxShape: RoundedRectangleBorder(
                  //                   borderRadius: BorderRadius.circular(25)),
                  //               controlAffinity: ListTileControlAffinity.leading,
                  //             ),
                  //           ),
                  //           IconButton(
                  //             onPressed: () {
                  //               Get.to(() => const PrivacyTerm());
                  //             },
                  //             icon: const Icon(
                  //               Icons.arrow_forward_ios_rounded,
                  //               size: 12,
                  //             ),
                  //             padding: const EdgeInsets.only(left: 20), // 패딩 설정
                  //             constraints: const BoxConstraints(),
                  //           ),
                  //         ],
                  //       ),
                  //       Padding(
                  //         padding: const EdgeInsets.only(left: 50),
                  //         child: Visibility(
                  //           visible: _visibility,
                  //           child: const Text(
                  //             "약관에 동의해주세요",
                  //             style: TextStyle(
                  //               fontSize: 12,
                  //               color: Colors.red,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //       const SizedBox(
                  //         height: 70,
                  //       ),
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
              onPressed: () {
                Navigator.pushNamed(context, '/signup2');
              },
              child: const Text('다음'),
            ),
          ),
        ),
      ),
    );
  }
}
