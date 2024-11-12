import 'package:flutter/material.dart';

import '../../../../database/databaseService.dart';

Widget messageInputTextField(messageController, userName, uid, groupId,
    groupName, scrollController, context) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
    child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: const Color(0xFFffffff),
              border: Border.all(color: const Color(0xffC2C2C2), width: 0.5)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 8, 0),
            child: Row(children: [
              Expanded(
                  child: TextFormField(
                controller: messageController,
                style: const TextStyle(color: Colors.black, fontSize: 16),
                decoration: const InputDecoration(
                  hintText: "메시지를 입력하세요",
                  hintStyle: TextStyle(color: Color(0xff919191), fontSize: 16),
                  //회색
                  border: InputBorder.none,
                ),
              )),
              const SizedBox(
                width: 12,
              ),
              GestureDetector(
                onTap: () {
                  sendMessage(messageController, userName, uid, groupId,
                      groupName, scrollController, context);
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                      child:
                          Image.asset("./assets/icons/sendMessageButton.png")),
                ),
              )
            ]),
          ),
        ),
      ],
    ),
  );
}

sendMessage(messageController, userName, uid, groupId, groupName,
    ScrollController scrollController, context) async {
  if (messageController.text.isNotEmpty) {
    Map<String, dynamic> chatMessageMap = {
      "message": messageController.text,
      "sender": userName,
      "time": DateTime.now().toString(),
      "isEnter": 0,
      "senderId": uid,
      "orderMessage": 0
    };

    DatabaseService().sendMessage(groupId, groupName, chatMessageMap);
    messageController.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.jumpTo(0);
      }
    });
  }
}
