import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:han_bab/database/databaseService.dart';

import '../../../widget/button.dart';

class Report extends StatelessWidget {
  Report({Key? key, required this.name, required this.targetId, required this.userName}) : super(key: key);

  final String name;
  final String targetId;
  final String userName;
  List<String> text = [
    "거래중 분쟁이 생겼어요.",
    "금전적인 문제를 일으켰어요.",
    "욕설 및 비방 표현을 했어요.",
    "성적 수치심을 느껴지는 이야기를 했어요.",
    "다른 문제가 있었어요."
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("신고하기"),
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 24, bottom: 35),
            child: Text(
              "'$name'님을 신고하는 이유를 알려주세요.",
              style: const TextStyle(
                  fontSize: 18,
                  fontFamily: "PretendardMedium",
                  color: Color(0xff120101)),
            ),
          ),
          const Divider(
            height: 5,
            thickness: 5,
            color: Color(0xffF1F1F1),
          ),
          for (int i = 0; i < 5; i++)
            Column(
              children: [
                reportContainer(text[i], () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Report2(
                                text: text[i], userName: userName, targetName: name, targetId: targetId,
                              )));
                }),
                const Divider(
                  color: Color(0xffEDEDED),
                  thickness: 1,
                  height: 0,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

Widget reportContainer(String text, Function function) {
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
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
              ),
            )
          ],
        ),
      ),
    ),
  );
}

class Report2 extends StatefulWidget {
  const Report2({Key? key, required this.text, required this.userName, required this.targetName, required this.targetId}) : super(key: key);

  final String text;
  final String userName;
  final String targetName;
  final String targetId;

  @override
  State<Report2> createState() => _Report2State();
}

class _Report2State extends State<Report2> {
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("신고하기"),
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
          padding: const EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 48.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "\"${widget.text}\"",
                style: const TextStyle(
                    fontFamily: "PretendardSemiBold",
                    fontSize: 18,
                    color: Color(0xff120101)),
              ),
              const SizedBox(
                height: 29,
              ),
              const Text(
                "문제 상황에 대해 구체적으로 설명해주세요.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: TextFormField(
                  controller: textEditingController,
                  onChanged: (value) {
                    setState(() {
                      textEditingController.text = value;
                    });
                  },
                  decoration: InputDecoration(
                    counterText:
                        "글자수 제한 : ${textEditingController.text.length}/300",
                    counterStyle:
                        const TextStyle(fontSize: 12, color: Colors.black),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xffC2C2C2)),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xffC2C2C2)),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hintStyle:
                        const TextStyle(color: Color(0xffC2C2C2), fontSize: 16),
                    hintText: "신고 내용을 입력해주세요.",
                  ),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  expands: true,
                  maxLength: 300,
                  textAlignVertical: TextAlignVertical.top,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                      child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.06,
                          child: Button(
                            function: textEditingController.text.isNotEmpty
                                ? () {
                              String uid = FirebaseAuth.instance.currentUser!.uid;
                              String sender = "${uid}_${widget.userName}";
                              String target = "${widget.targetId}_${widget.targetName}";
                              DatabaseService().sendFeedback(sender, target, widget.text, textEditingController.text);
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) => Dialog(
                                    child: Container(
                                      height: MediaQuery.of(context).size.height * 0.34,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Colors.white),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(29, 28, 29, 25),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                              "신고가 완료되었습니다.",
                                              style: TextStyle(
                                                  fontFamily: "PretendardSemiBold",
                                                  fontSize: 18,
                                                  color: Color(0xffFB813D)),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            const Expanded(
                                                child: Text(
                                                  "신고사항에 대해 더이상 불편함을 느끼지 않으시도록 조취하도록 하겠습니다. ",
                                                  style: TextStyle(fontSize: 16),
                                                )),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(10),
                                                          color: const Color(0xffFB973D)),
                                                      child: const Padding(
                                                        padding: EdgeInsets.symmetric(vertical: 11.5),
                                                        child: Center(
                                                            child: Text(
                                                              "확인",
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontFamily: "PretendardMedium",
                                                                  color: Colors.white),
                                                            )),
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
                                  ));
                            }
                                : null,
                            title: '신고하기',
                            backgroundColor: const Color(0xffFB973D),
                          ))),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
