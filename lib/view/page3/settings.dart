import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:han_bab/view/login/initial.dart';
import 'package:han_bab/view/page3/webview.dart';
import 'package:han_bab/widget/appBar.dart';

import '../../widget/alert.dart';

class Setting extends StatelessWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          appbar(context, "환경설정"),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WebView(title: "이용약관"),
                ),
              );
            },
            child: Container(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25.0, 25, 0, 25),
                child: Row(
                  children: [
                    Image.asset(
                      "./assets/icons/settings1.png",
                      scale: 2,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    const Text(
                      "이용약관",
                      style: TextStyle(
                          fontFamily: "PretendardMedium",
                          fontSize: 18,
                          color: Color(0xff313131)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Divider(
            height: 0,
            color: Color(0xffEDEDED),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WebView(title: "개인정보처리방침"),
                ),
              );
            },
            child: Container(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(left: 25.0, top: 25, bottom: 25),
                child: Row(
                  children: [
                    Image.asset(
                      "./assets/icons/settings2.png",
                      scale: 2,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    const Text(
                      "개인정보처리방침",
                      style: TextStyle(
                          fontFamily: "PretendardMedium",
                          fontSize: 18,
                          color: Color(0xff313131)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Divider(
            height: 0,
            color: Color(0xffEDEDED),
          ),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Not yet'),
                ),
              );
            },
            child: Container(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(left: 25.0, top: 25, bottom: 25),
                child: Row(
                  children: [
                    Image.asset(
                      "./assets/icons/settings3.png",
                      scale: 2,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    const Text(
                      "알림설정",
                      style: TextStyle(
                          fontFamily: "PretendardMedium",
                          fontSize: 18,
                          color: Color(0xff313131)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Divider(
            height: 0,
            color: Color(0xffEDEDED),
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertModal(
                        text: '정말로 계정을 탈퇴하시겠습니까?',
                        yesOrNo: true,
                        function: () async {
                          // Firebase에서 사용자 계정 탈퇴
                          final currentUser = FirebaseAuth.instance.currentUser;
                          if (currentUser != null) {
                            // Firestore에서 사용자 관련 데이터 삭제
                            await FirebaseFirestore.instance
                                .collection('user')
                                .doc(currentUser.uid)
                                .delete();
                            // 계정 탈퇴 후 로그아웃 처리
                            await currentUser.delete();
                            await FirebaseAuth.instance.signOut();
                          }
                          // 계정 탈퇴 후 로그아웃 처리
                          await FirebaseAuth.instance.signOut();
                          Navigator.of(context).pop();
                          await Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const InitialPage()),
                              (Route<dynamic> route) => false);
                        },
                      ));
            },
            child: Container(
              color: Colors.transparent,
              child: const Padding(
                padding: EdgeInsets.only(left: 25.0, top: 25, bottom: 25),
                child: Row(
                  children: [
                    Icon(Icons.delete_outline),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      "계정탈퇴",
                      style: TextStyle(
                          fontFamily: "PretendardMedium",
                          fontSize: 18,
                          color: Color(0xff313131)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
