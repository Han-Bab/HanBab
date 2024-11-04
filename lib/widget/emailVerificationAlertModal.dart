import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Emailverificationalertmodal extends StatefulWidget {
  final String text;
  final bool yesOrNo;
  final Function function;

  const Emailverificationalertmodal({
    Key? key,
    required this.text,
    required this.yesOrNo,
    required this.function,
  }) : super(key: key);

  @override
  State<Emailverificationalertmodal> createState() => _AlertModalState();
}

class _AlertModalState extends State<Emailverificationalertmodal> {
  bool isVerified = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startVerificationCheck();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startVerificationCheck() {
    // 2초마다 이메일 인증 상태 확인
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      await FirebaseAuth.instance.currentUser?.reload();
      var user = FirebaseAuth.instance.currentUser;

      if (user != null && user.emailVerified) {
        setState(() {
          isVerified = true;
        });
        _timer.cancel(); // 인증이 완료되면 타이머 중지
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
                height: 30,
              ),
                  GestureDetector(
                onTap: isVerified ? () => widget.function() : null,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: isVerified ? const Color(0xffF0F0F0) : Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Center(
                            child: Text(
                              isVerified ? "완료" : "미완료",
                              style: const TextStyle(
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
            ],
          ),
        ),
      ),
    );
  }
}
