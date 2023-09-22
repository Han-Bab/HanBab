import 'package:flutter/material.dart';
import 'package:han_bab/database/databaseService.dart';
import 'package:han_bab/view/page3/kakaoOnboarding.dart';
import 'package:han_bab/view/page3/tossOnboarding.dart';
import '../color_schemes.dart';

class AccountAlert extends StatelessWidget {
  AccountAlert({Key? key, required this.kakao}) : super(key: key);

  final bool kakao;
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Dialog(
        child: Container(
            width: 100,
            height: MediaQuery.of(context).size.height * 0.16,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Stack(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: kakao ? "카카오페이 링크" : "토스 아이디",
                          hintText: kakao
                              ? "ex) https://qr.kakaopay.com/xxxxxxxxx"
                              : "ex) 한밥",
                          hintStyle: const TextStyle(
                              fontSize: 12, color: Color(0xff919191)),
                        ),
                        controller: textEditingController,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          DatabaseService().saveSocialAccount(
                              textEditingController.text, kakao);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('연결되었습니다.'),
                            duration: Duration(seconds: 5),
                          ));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: lightColorScheme.primary,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 5),
                            child: Text(
                              "저장",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                        onTap: () {
                          kakao
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const KakaoOnboarding()))
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const TossOnboarding()));
                        },
                        child: const Icon(
                          Icons.help_outline,
                          size: 20,
                          color: Color(0xff919191),
                        )),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.clear,
                          color: Color(0xff919191),
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }
}
