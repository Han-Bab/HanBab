import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:han_bab/database/databaseService.dart';
import 'package:han_bab/view/page3/profileModify.dart';
import 'package:han_bab/view/page3/report_bug.dart';
import 'package:han_bab/view/page3/settings.dart';
import 'package:han_bab/widget/alert.dart';
import 'package:han_bab/widget/bottom_navigation.dart';
import 'package:han_bab/widget/encryption.dart';
import 'package:provider/provider.dart';

import '../../controller/hanbab_auth_provider.dart';
import '../../controller/navigation_controller.dart';
import '../../widget/appBar.dart';
import '../../widget/flutterToast.dart';
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
    if (mounted) {
      // 추가: mounted 상태 확인
      setState(() {
        data = fetchedData;
        _isLoading = false; // 데이터 로드가 완료되면 _isLoading을 false로 변경
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<HanbabAuthProvider>(context);
    final navigationService = Provider.of<NavigationController>(context);


    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          appbar(context, "메뉴"),
          Padding(
            padding: const EdgeInsets.fromLTRB(
                25, 26, 25, 26),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${data['name']}님",
                  style: const TextStyle(
                      fontSize: 22,
                      fontFamily: "PretendardMedium",
                      color: Color(0xff313131)),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileModify(
                                name: data['name'],
                                email: data['email'],
                                phone: data['phone'],
                                account: data['bankAccount'] ==
                                    "0000000000000000"
                                    ? "(계좌없음)"
                                    : decrypt(
                                    aesKey,
                                    Encrypted.fromBase16(
                                        data['bankAccount'])))));
                  },
                  child: const Row(
                    children: [
                      Text(
                        "상세보기",
                        style: TextStyle(
                            fontFamily: "PretendardMedium",
                            fontSize: 14,
                            color: Color(0xffFB973D)),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 15,
                        color: Color(0xffFB973D),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          const Divider(
            height: 5,
            thickness: 5,
            color: Color(0xffF1F1F1),
          ),
          menuContainer("./assets/icons/menu_icons/account.png", "계좌연결",
                  () {
                    initializeData();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Account(kakao: data['kakaopay'], toss: data['tossId'],)));
              }),
          const Divider(
            color: Color(0xffEDEDED),
            thickness: 1,
            height: 0,
          ),
          menuContainer("./assets/icons/menu_icons/setting.png", "환경설정",
                  () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Setting()));
              }),
          const Divider(
            color: Color(0xffEDEDED),
            thickness: 1,
            height: 0,
          ),
          menuContainer(
              "./assets/icons/menu_icons/report.png", "신고하기", () {
            navigationService.setSelectedIndex(0);
            FToast().init(context);

            FToast().showToast(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: const Color(0xff313131)),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 23),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("[채팅방-메뉴-구성원]", style: TextStyle(fontFamily: "PretendardBold", color: Colors.white),),
                          Text("에서 신고할 사용자를 선택해주세요.", style: TextStyle(color: Colors.white),),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              toastDuration: const Duration(seconds: 6),
              gravity: ToastGravity.BOTTOM,
            );
          }),
          const Divider(
            color: Color(0xffEDEDED),
            thickness: 1,
            height: 0,
          ),
          menuContainer("./assets/icons/menu_icons/feedback.png", "고객센터",
                  () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ReportBug()));
              }),
          const Divider(
            color: Color(0xffEDEDED),
            thickness: 1,
            height: 0,
          ),
          menuContainer("./assets/icons/menu_icons/logout.png", "로그아웃",
                  () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertModal(
                      text: '로그아웃 하시겠습니까?',
                      yesOrNo: true,
                      function: () {
                        authController.logout();
                        Navigator.pop(context);
                      },
                    ));
              }),
          const Divider(
            color: Color(0xffEDEDED),
            thickness: 1,
            height: 0,
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}

Widget menuContainer(String image, String text, Function function) {
  return GestureDetector(
    onTap: () {
      function();
    },
    child: Container(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Row(
          children: [
            Image.asset(
              image,
              scale: 2,
            ),
            const SizedBox(
              width: 15,
            ),
            Text(
              text,
              style:
              const TextStyle(fontSize: 16, fontFamily: "PretendardMedium"),
            )
          ],
        ),
      ),
    ),
  );
}