import 'package:flutter/material.dart';

class Logout extends StatelessWidget {
  const Logout({Key? key, required this.authController}) : super(key: key);

  final authController;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Container(
          width: 358,
          height: MediaQuery.of(context).size.height * 0.3,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "로그아웃 하시겠어요?",
                  style: TextStyle(fontSize: 24, color: Color(0xff3E3E3E)),
                ),
                const SizedBox(
                  height: 60,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "취소",
                          style:
                              TextStyle(fontSize: 20, color: Color(0xffED6160)),
                        )),
                    const SizedBox(
                      width: 50,
                    ),
                    TextButton(
                        onPressed: () {
                          authController.logout();
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "확인",
                          style:
                              TextStyle(fontSize: 20, color: Color(0xff75B165)),
                        )),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
