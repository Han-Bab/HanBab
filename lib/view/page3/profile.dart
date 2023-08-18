import 'package:flutter/material.dart';
import 'package:han_bab/controller/auth_controller.dart';
import 'package:han_bab/widget/bottom_navigation.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:han_bab/view/page3/onboarding_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("프로필"),
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
        actions: [
          IconButton(
              onPressed: () {
                authController.logout();
              },
              icon: const Icon(Icons.logout_rounded),
            color: Colors.black54,
          ),
        ],
      ),
      body: GestureDetector(
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "닉네임",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "hanbab@gmail.com",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "010 - 1234 - 5678",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 1,
                              height: 110,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 28,
                                  child: Text(
                                    '연결 계좌',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 7),
                                    child: Container(
                                      height: 25,
                                      width: 85,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Color(0xFFFFEB03),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.only(top: 2),
                                        child: Text(
                                          'Kakao',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 7),
                                    child: Container(
                                      height: 25,
                                      width: 85,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Color(0xFF3268E8),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.only(top: 2),
                                        child: Text(
                                          'Toss',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: width,
                      child: ElevatedButton(
                        onPressed: () {
                          // Get.off(() => EditProfile(),
                          //     transition: Transition.rightToLeft);
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          side: const BorderSide(color: Colors.black12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: const Text(
                          "프로필 관리",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: const SizedBox(
                  width: 26,
                  height: 26,
                  child: Icon(
                    Icons.monetization_on_outlined,
                  ),
                ),
                title: const Text(
                  '계좌 연결하기',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                  ),
                ),
                onTap: () {
                  Get.to(() => const OnboardingPage(), transition: Transition.zoom);
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: Container(
                  width: 20,
                  height: 20,
                  child: const Icon(
                    Icons.message,
                  ),
                ),
                title: const Text(
                  '고객센터',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                  ),
                ),
                onTap: () {
                  // Get.to(() => ReportBug(), transition: Transition.rightToLeft);
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: Container(
                  width: 23,
                  height: 23,
                  child: const Icon(
                    Icons.logout_outlined,
                  ),
                ),
                title: const Text(
                  '로그아웃',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                  ),
                ),
                onTap: () {
                  authController.logout();
                  // AuthController.instance.logout();
                  // AuthController.instance.logoutGoogle();
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}
