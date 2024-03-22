import 'package:flutter/material.dart';
import 'package:han_bab/view/page3/tossOnboarding.dart';
import 'package:han_bab/widget/appBar.dart';
import '../../database/databaseService.dart';
import 'kakaoOnboarding.dart';

class Account extends StatefulWidget {
  const Account({Key? key, required this.kakao, required this.toss}) : super(key: key);

  final String kakao;
  final String toss;

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final TextEditingController textEditingController1 = TextEditingController();
  final TextEditingController textEditingController2 = TextEditingController();

  bool done1 = false;
  bool done2 = false;

  @override
  void initState() {
    textEditingController1.text = widget.kakao;
    if(textEditingController1.text != "") done1 = true;
    textEditingController2.text = widget.toss;
    if(textEditingController2.text != "") done2 = true;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: appbar(context, "계좌연결"),
        body: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 20, 24, 0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "연결 계좌",
                    style: TextStyle(
                        fontFamily: "PretendardMedium",
                        fontSize: 18,
                        color: Color(0xff120101)),
                  ),
                  const SizedBox(
                    height: 27,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 4,
                          spreadRadius: 0,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 23.0, vertical: 21.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "./assets/images/kakao.png",
                                      scale: 2,
                                    ),
                                    const SizedBox(
                                      width: 14.5,
                                    ),
                                    const Text(
                                      "카카오 페이",
                                      style: TextStyle(
                                          fontFamily: "PretendardSemiBold",
                                          fontSize: 20),
                                    )
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => KakaoOnboarding(width: MediaQuery.of(context).size.width * 0.4,)));
                                },
                                child: const Row(
                                  children: [
                                    Text(
                                      "연결방법 확인하기",
                                      style: TextStyle(
                                          fontFamily: "PretendardMedium",
                                          fontSize: 12,
                                          color: Color(0xffFB973D)),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 13,
                                      color: Color(0xffFB973D),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 21.5,
                          ),
                          Stack(
                            children: [
                              TextFormField(
                                enabled: done1 ? false : true,
                                onChanged: (value) {
                                  setState(() {
                                    textEditingController1.text = value;
                                  });
                                },
                                controller: textEditingController1,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xffC2C2C2)),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xffC2C2C2)),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  hintStyle: const TextStyle(fontSize: 14, color: Color(0xffC2C2C2)),
                                  hintText: "송금코드를 입력해주세요",
                                  fillColor: Colors.white70,
                                ),
                                style: const TextStyle(fontSize: 16),
                              ),
                              // Image
                              done1 ? Positioned.fill(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        done1 = false;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 13.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "./assets/icons/modify2.png",
                                            scale: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ) : Container(),
                            ],
                          ),

                          textEditingController1.text.isNotEmpty ? const SizedBox(height: 15,) : Container(),
                          textEditingController1.text.isNotEmpty ? GestureDetector(
                            onTap: done1 ? null : () {
                              setState(() {
                                done1 = true;
                              });
                              DatabaseService().saveSocialAccount(textEditingController1.text, true);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('연결되었습니다.'),
                                duration: Duration(seconds: 5),
                              ));
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(7),color: !done1 ? const Color(0xffFB973D) : const Color(0xffC2C2C2),),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                                      child: Center(child: Text(!done1 ? "등록" : "등록완료", style: const TextStyle(fontSize: 14, fontFamily: "PretendardMedium", color: Colors.white),)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ) : Container()
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 27,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 4,
                          spreadRadius: 0,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 23.0, vertical: 21.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "./assets/images/toss.png",
                                      scale: 2,
                                    ),
                                    const SizedBox(
                                      width: 14.5,
                                    ),
                                    const Text(
                                      "토스 페이",
                                      style: TextStyle(
                                          fontFamily: "PretendardSemiBold",
                                          fontSize: 20),
                                    )
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TossOnboarding(width: MediaQuery.of(context).size.width * 0.2,)));
                                },
                                child: const Row(
                                  children: [
                                    Text(
                                      "연결방법 확인하기",
                                      style: TextStyle(
                                          fontFamily: "PretendardMedium",
                                          fontSize: 12,
                                          color: Color(0xffFB973D)),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 13,
                                      color: Color(0xffFB973D),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 21.5,
                          ),
                          Stack(
                            children: [
                              TextFormField(
                                enabled: done2 ? false : true,
                                onChanged: (value) {
                                  setState(() {
                                    textEditingController2.text = value;
                                  });
                                },
                                controller: textEditingController2,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xffC2C2C2)),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xffC2C2C2)),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  hintStyle: const TextStyle(fontSize: 14, color: Color(0xffC2C2C2)),
                                  hintText: "토스 아이디를 입력해주세요",
                                  fillColor: Colors.white70,
                                ),
                                style: const TextStyle(fontSize: 16),
                              ),
                              // Image
                              done2 ? Positioned.fill(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        done2 = false;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 13.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "./assets/icons/modify2.png",
                                            scale: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ) : Container(),
                            ],
                          ),

                          textEditingController2.text.isNotEmpty ? const SizedBox(height: 15,) : Container(),
                          textEditingController2.text.isNotEmpty ? GestureDetector(
                            onTap: done2 ? null : () {
                              setState(() {
                                done2 = true;
                              });
                              DatabaseService().saveSocialAccount(textEditingController2.text, false);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('연결되었습니다.'),
                                duration: Duration(seconds: 5),
                              ));
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(7),color: !done2 ? const Color(0xffFB973D) : const Color(0xffC2C2C2),),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                                      child: Center(child: Text(!done2 ? "등록" : "등록완료", style: const TextStyle(fontSize: 14, fontFamily: "PretendardMedium", color: Colors.white),)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ) : Container()
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}