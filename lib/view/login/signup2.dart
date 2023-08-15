import 'package:flutter/material.dart';
import 'package:han_bab/controller/login_controller.dart';
import 'package:provider/provider.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class Signup2Page extends StatelessWidget {
  const Signup2Page({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<LoginController>(context);

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
                    onChanged: (value) {
                      controller.setName(value);
                    },
                    // validator: (value) {
                    //   if (value!.isEmpty) {
                    //     return "이름을 입력해주세요";
                    //   }
                    //   return null;
                    // },
                    decoration: const InputDecoration(
                      hintText: "이름을 입력해주세요",
                      contentPadding: EdgeInsets.fromLTRB(5, 15, 15, 15),
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
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    // validator: (value) {
                    //   if (value!.isEmpty || value.length != 13) {
                    //     return "올바른 전화번호를 입력해주세요";
                    //   }
                    //   return null;
                    // },
                    onChanged: (value) {
                      controller.setPhone(value);
                    },
                    decoration: const InputDecoration(
                      hintText: "전화번호를 입력해주세요",
                      contentPadding: EdgeInsets.fromLTRB(5, 15, 15, 15),
                    ),
                    inputFormatters: [MaskedInputFormatter("000-0000-0000")],
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
                    onChanged: (value) {
                      controller.setName(value);
                    },
                    // validator: (value) {
                    //   if (value!.isEmpty) {
                    //     return "이름을 입력해주세요";
                    //   }
                    //   return null;
                    // },
                    decoration: const InputDecoration(
                      hintText: "예) 1002452023325 우리",
                      contentPadding: EdgeInsets.fromLTRB(5, 15, 15, 15),
                    ),
                  ),

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
                Navigator.pushNamed(context, '/signup3');
              },
              child: const Text('다음'),
            ),
          ),
        ),
      ),
    );
  }
}
