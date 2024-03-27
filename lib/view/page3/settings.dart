import 'package:flutter/material.dart';
import 'package:han_bab/view/page3/webview.dart';
import 'package:han_bab/widget/appBar.dart';

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
        ],
      ),
    );
  }
}
