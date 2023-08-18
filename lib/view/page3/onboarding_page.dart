import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('카카오 토스 연결하기'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                const Text(
                  '연결하는 법',
                  style: TextStyle(fontSize: 25),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  child: Container(
                    height: 40,
                    width: 170,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: const Color(0xFFFFEB03)),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        'Kakao',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    //Get.off(() => KakaoIntroPage());
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  child: Container(
                    height: 40,
                    width: 170,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: const Color(0xFF3268E8)),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        'Toss',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    //Get.off(() => TossIntroPage());
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
            Container(
              height: 3,
              width: 600,
              color: Colors.grey[300],
            ),
            Column(
              children: [
                const Text(
                  '연결하기',
                  style: TextStyle(fontSize: 25),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  child: Container(
                    height: 40,
                    width: 170,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: const Color(0xFFFFEB03)),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        'Kakao',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        var kakaoAccountController = TextEditingController();
                        return AlertDialog(
                          title: const Text('카카오 계좌 연결'),
                          content: TextFormField(
                            controller: kakaoAccountController,
                            decoration: const InputDecoration(
                                hintText: '링크 코드를 넣어주세요.'),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('취소'),
                            ),
                            TextButton(
                              onPressed: () {
                                var kakaoAccount = kakaoAccountController.text;
                                Navigator.pop(context);
                              },
                              child: const Text('저장'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  child: Container(
                    height: 40,
                    width: 170,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: const Color(0xFF3268E8)),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        'Toss',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        var TossAccountController = TextEditingController();
                        return AlertDialog(
                          title: const Text('카카오 계좌 연결'),
                          content: TextFormField(
                            controller: TossAccountController,
                            decoration: const InputDecoration(
                                hintText: '링크 코드를 넣어주세요.'),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('취소'),
                            ),
                            TextButton(
                              onPressed: () {
                                var TossAccount = TossAccountController.text;
                                Navigator.pop(context);
                              },
                              child: const Text('저장'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
