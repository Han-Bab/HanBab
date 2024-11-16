import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../view/login/initial.dart';

class AlertModal extends StatefulWidget {
  const AlertModal(
      {Key? key,
      required this.text,
      required this.yesOrNo,
      required this.function})
      : super(key: key);

  final String text;
  final bool yesOrNo;
  final Function function;

  @override
  State<AlertModal> createState() => _AlertModalState();
}

class _AlertModalState extends State<AlertModal> {
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Dialog(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "./assets/icons/alertIcon.png",
                  scale: 2,
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        widget.text,
                        style: const TextStyle(fontSize: 18),
                        softWrap: true,
                        maxLines: null,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                widget.text == "정말로 계정을 탈퇴하시겠습니까?"
                    ? TextField(
                        decoration:
                            const InputDecoration(hintText: "비밀번호를 입력해주세요"),
                        controller: passwordController,
                        onChanged: (value) {
                          setState(() {
                            passwordController.text = value;
                          });
                        },
                      )
                    : Container(),
                const SizedBox(
                  height: 30,
                ),
                widget.yesOrNo == false
                    ? GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: const Color(0xffF0F0F0),
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Center(
                                    child: Text(
                                      "확인",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: "PretendardMedium"),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Row(
                        children: [
                          Expanded(
                              child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                  color: const Color(0xffF0F0F0),
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: Center(
                                  child: Text(
                                    "아니오",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: "PretendardMedium"),
                                  ),
                                ),
                              ),
                            ),
                          )),
                          const SizedBox(
                            width: 12,
                          ),
                          widget.text == "정말로 계정을 탈퇴하시겠습니까?"
                              ? Expanded(
                                  child: GestureDetector(
                                  onTap: passwordController.text.isEmpty
                                      ? null
                                      : () async {
                                          // Firebase에서 사용자 계정 탈퇴
                                          await deleteAccount(context, passwordController.text);
                                        },
                                  child: Container(
                                    height: 45,
                                    decoration: BoxDecoration(
                                        color: passwordController.text.isEmpty
                                            ? const Color(0xffF0F0F0)
                                            : Theme.of(context).primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10.0),
                                      child: Center(
                                        child: Text(
                                          "네",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontFamily: "PretendardMedium"),
                                        ),
                                      ),
                                    ),
                                  ),
                                ))
                              : Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      widget.function();
                                    },
                                    child: Container(
                                      height: 45,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: Center(
                                          child: Text(
                                            "네",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontFamily: "PretendardMedium"),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> deleteAccount(BuildContext context, String password) async {
  final currentUser = FirebaseAuth.instance.currentUser;
  try {
    // 최근 로그인 요구 처리
    final email = currentUser?.email;
    final credential = EmailAuthProvider.credential(
      email: email!,
      password: password,
    );

    // 사용자 다시 인증
    await currentUser?.reauthenticateWithCredential(credential);

    // Firestore에서 사용자 관련 데이터 삭제
    await FirebaseFirestore.instance
        .collection('user')
        .doc(currentUser?.uid)
        .delete();

    // 계정 삭제
    await currentUser?.delete();

    // 로그아웃 처리
    await FirebaseAuth.instance.signOut();

    // 초기 페이지로 이동
    Navigator.of(context).pop();
    await Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const InitialPage()),
          (Route<dynamic> route) => false,
    );
  } catch (e) {
    // 에러 처리
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertModal(
        text: "비밀번호가 틀렸습니다.\n다시 시도해주세요.",
       yesOrNo: false, function: (){Navigator.pop(context);},
      ),
    );
  }
}
