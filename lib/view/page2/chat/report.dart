import 'package:flutter/material.dart';

class Report extends StatelessWidget {
  Report({Key? key, required this.name}) : super(key: key);

  final String name;
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
          for(int i=0;i<5;i++)
            Column(
              children: [
                reportContainer(text[i], () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Report2(text: text[i],)));
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

class Report2 extends StatelessWidget {
  Report2({Key? key, required this.text}) : super(key: key);

  final String text;
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context)
            .unfocus();
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
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("\"$text\"", style: const TextStyle(fontFamily: "PretendardSemiBold", fontSize: 18, color: Color(0xff120101)),),
              const SizedBox(height: 29,),
              const Text("문제 상황에 대해 구체적으로 설명해주세요.", style: TextStyle(fontSize: 16),),
              const SizedBox(height: 15,),
              SizedBox(
                height: 200,
                child: TextFormField(
                  controller: textEditingController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xffC2C2C2)),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xffC2C2C2)),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hintStyle: const TextStyle(color: Color(0xffC2C2C2), fontSize: 16),
                    hintText: "신고 내용을 입력해주세요.",
                  ),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  expands: true,
                  maxLength: 300,

                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
