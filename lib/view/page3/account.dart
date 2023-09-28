import 'package:flutter/material.dart';
import 'package:han_bab/widget/accountAlert.dart';
import 'package:han_bab/widget/hoverButton.dart';

class Account extends StatelessWidget {
  const Account({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("소설계좌 연결"),
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 22, 24, 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              HoverButton(
                title: Image.asset("assets/images/kakao.png"),
                function: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AccountAlert(kakao: true,));
                },
              ),
              const SizedBox(
                height: 35,
              ),
              HoverButton(
                title: Image.asset("assets/images/toss.png"),
                function: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AccountAlert(kakao: false,));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
