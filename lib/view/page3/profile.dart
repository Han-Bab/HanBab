import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:han_bab/color_schemes.dart';
import 'package:han_bab/controller/auth_controller.dart';
import 'package:han_bab/database/databaseService.dart';
import 'package:han_bab/view/page3/profileModify.dart';
import 'package:han_bab/view/page3/report_bug.dart';
import 'package:han_bab/widget/bottom_navigation.dart';
import 'package:han_bab/widget/logout.dart';
import 'package:provider/provider.dart';

import 'account.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late DocumentSnapshot data;
  bool _isLoading = true; // 데이터 로드 상태를 저장하는 변수 추가
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  // initState에서 실행될 비동기 데이터 초기화 함수
  Future<void> initializeData() async {
    final fetchedData = await DatabaseService().getUserInfo(uid);
    setState(() {
      data = fetchedData;
      _isLoading = false; // 데이터 로드가 완료되면 _isLoading을 false로 변경
    });
  }

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
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                data['name'],
                                style: const TextStyle(
                                  color: Color(0xff3E3E3E),
                                  fontSize: 25,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                data['email'],
                                style: const TextStyle(
                                  color: Color(0xff3E3E3E),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                height: 1,
                              ),
                              Text(
                                data['phone'],
                                style: const TextStyle(
                                  color: Color(0xff3E3E3E),
                                  fontSize: 13,
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
                                        color: Color(0xff3E3E3E),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 7),
                                      child: Container(
                                        height: 25,
                                        width: 85,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: data['kakaoLink']
                                              ? Color(0xFFFFEB03)
                                              : Color(0xffE1E1E1),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Kakao',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: data['kakaoLink']
                                                  ? Colors.black
                                                  : Colors.white,
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
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: data['tossLink']
                                              ? Color(0xFF3268E8)
                                              : Color(0xffE1E1E1),
                                        ),
                                        child: const Center(
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfileModify(
                                        name: data['name'],
                                        email: data['email'],
                                        phone: data['phone'],
                                        account: data['bankAccount'])));
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            foregroundColor: const Color(0xff3E3E3E),
                            side: BorderSide(color: lightColorScheme.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          child: const Text(
                            "프로필 관리",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: ListTile(
                    leading: SizedBox(
                        width: 24,
                        height: 24,
                        child: Image.asset("assets/icons/coin.png")),
                    title: const Text(
                      '소셜계좌 연결하기',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff3E3E3E),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Account()));
                    },
                  ),
                ),
                const Divider(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: ListTile(
                    leading: SizedBox(
                        width: 24,
                        height: 24,
                        child: Image.asset("assets/icons/help.png")),
                    title: const Text(
                      '고객센터',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff3E3E3E),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ReportBug()));
                    },
                  ),
                ),
                const Divider(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: ListTile(
                    leading: SizedBox(
                        width: 24,
                        height: 24,
                        child: Image.asset("assets/icons/exit.png")),
                    title: const Text(
                      '로그아웃',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff3E3E3E),
                      ),
                    ),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => Logout(
                                authController: authController,
                              ));
                    },
                  ),
                ),
              ],
            ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}
