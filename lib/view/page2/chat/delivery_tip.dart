import 'package:flutter/material.dart';
import 'package:han_bab/database/databaseService.dart';

class DeliveryTip extends StatelessWidget {
  DeliveryTip({Key? key, required this.groupId}) : super(key: key);

  final String groupId;
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => Dialog(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(29, 23, 29, 25),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "[총 배달팁] 금액을 입력해주세요",
                              style: TextStyle(fontSize: 18),
                            ),
                            const SizedBox(
                              height: 36,
                            ),
                            TextFormField(
                              controller: textEditingController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(fontSize: 16),
                              decoration: const InputDecoration(
                                suffix: Padding(
                                  padding: EdgeInsets.only(right: 10.0),
                                  child: Text("원"),
                                ),
                                suffixStyle: TextStyle(color: Color(0xffC2C2C2), fontSize: 16),
                                isDense: true,
                                contentPadding: EdgeInsets.only(bottom: 5),
                              ),
                            ),
                            const SizedBox(
                              height: 29,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: const Color(0xffF1F1F1),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 11.5),
                                        child: Center(
                                            child: Text(
                                          "취소",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: "PretendardMedium",
                                              color: Color(0xff313131)),
                                        )),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      DatabaseService().setDeliveryTip(groupId, int.parse(textEditingController.text));
                                      Navigator.pop(context);
                                      },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: const Color(0xffFB973D),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 11.5),
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
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment(-1, 0),
              end: Alignment(1, 0),
              colors: [
                Color(0xFFF99E4B),
                Color(0xFFFF974B),
                Color(0xFFFCB853),
                Color(0xFFFBCD55),
              ],
              stops: [0, 0.1252, 0.7304, 0.9541],
            ),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.25),
                offset: Offset(0, 1),
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ],
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 11.5),
            child: Text(
              "총 배달팁 입력하기",
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: "PretendardSemiBold",
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
