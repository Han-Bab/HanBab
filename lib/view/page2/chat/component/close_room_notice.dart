import 'package:flutter/material.dart';

import '../../../../database/databaseService.dart';

Future closeRoomNotice(
    context, groupId, groupName, userName, uid, scrollToBottom) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => Dialog(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "주문 마감, 정산 시작!",
                  style: TextStyle(
                      fontFamily: "PretendardSemiBold",
                      fontSize: 18,
                      color: Color(0xffFB813D)),
                ),
                const SizedBox(
                  height: 20,
                ),
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: '음식비를 먼저 받은 뒤',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "PretendardBold",
                            color: Colors.black),
                      ),
                      TextSpan(
                        text: ' 배달의 민족 주문을 진행해주세요!',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "TIP",
                  style: TextStyle(
                      fontSize: 12,
                      fontFamily: "PretendardMedium",
                      color: Color(0xffFB813D)),
                ),
                const Text(
                  "만약 음식값을 보내지 않는 구성원이 있다면 해당 음식을 제외하고 주문을 진행해주세요!",
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          DatabaseService().closeRoom(groupId, 2);
                          Map<String, dynamic> chatMessageMap = {
                            "message": "식비 정산 요청",
                            "sender": userName,
                            "time": DateTime.now().toString(),
                            "isEnter": 0,
                            "senderId": uid,
                            "orderMessage": 1
                          };

                          DatabaseService().sendMessage(
                              groupId, groupName, chatMessageMap);

                          scrollToBottom();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xffFB973D)),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 11.5),
                            child: Center(
                                child: Text(
                                  "정산하기",
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