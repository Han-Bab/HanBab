import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:han_bab/database/databaseService.dart';

import '../../../widget/message_tile.dart';

int chatCount = 0;

Widget chatMessages(
  Stream<QuerySnapshot>? chats,
  String userName,
  String admin,
  String? uid,
  ScrollController scrollController,
  int isDeliveryTip,
  double money,
  dynamic adminInfo,
  String groupId,
) {
  return StreamBuilder(
    stream: chats,
    builder: (context, AsyncSnapshot snapshot) {
      if (snapshot.hasData) {
        bool newChat = (chatCount != snapshot.data.docs.length) ? true : false;
        chatCount = snapshot.data.docs.length;
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 15),
          itemCount: snapshot.data.docs.length + 1,
          controller: scrollController, // Attach the scroll controller here
          itemBuilder: (context, index) {
            if (index == 0) {
              return Container(
                height: (admin.contains(uid ?? "") && isDeliveryTip == -1) ? 115 : 60,
              );
            }

            // isEnter가 1일 때 senderId로 토큰 확인 및 저장
            if (snapshot.data.docs[index - 1]['isEnter'] == 1) {
              String message = snapshot.data.docs[index - 1]['message'];
              String senderId = snapshot.data.docs[index - 1]['senderId'];

              if (message.contains("입장")) {
                // "입장" 처리
                DatabaseService().getToken(senderId).then((token) async {
                  if (token != null && token.isNotEmpty) {
                    await DatabaseService().saveToken(groupId, token);
                  }
                });
              } else if (message.contains("퇴장")) {
                // "퇴장" 처리
                DatabaseService().getToken(senderId).then((token) async {
                  if (token != null && token.isNotEmpty) {
                    await DatabaseService().deleteToken(groupId, token);
                  }
                });
              }
            }

            bool duplicateNickName = false;
            bool duplicateTime = false;

            if (index > 1 &&
                snapshot.data.docs[index - 2]['isEnter'] != 1 &&
                snapshot.data.docs[index - 1]['senderId'] ==
                    snapshot.data.docs[index - 2]['senderId']) {
              duplicateNickName = true;
            }

            if (index < snapshot.data.docs.length &&
                snapshot.data.docs[index - 1]['senderId'] ==
                    snapshot.data.docs[index]['senderId']) {
              if (snapshot.data.docs[index - 1]['time']
                      .toString()
                      .substring(0, 16) ==
                  snapshot.data.docs[index]['time']
                      .toString()
                      .substring(0, 16)) {
                duplicateTime = true;
              }
            }
            if (newChat && uid != snapshot.data.docs[index - 1]['senderId']) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (scrollController.hasClients) {
                  // 현재 스크롤 위치
                  double currentPosition =
                      scrollController.position.pixels + 50;
                  // 스크롤 가능한 최대 위치
                  double maxScrollPosition =
                      scrollController.position.maxScrollExtent;
                  // print(currentPosition);
                  // print(maxScrollPosition);
                  print(scrollController.position.viewportDimension);
                  // 스크롤이 맨 아래에 있는지 확인
                  if (scrollController.position.maxScrollExtent > 0) {
                    if (currentPosition >= maxScrollPosition) {
                      // 스크롤을 위로 올리기 (원하는 만큼)
                      scrollController.animateTo(
                        maxScrollPosition +
                            MediaQuery.of(context).size.height * 0.02,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.ease,
                      );
                    }
                  }
                }
              });
            }
            return MessageTile(
              money: money,
              message: snapshot.data.docs[index - 1]['message'],
              sender: snapshot.data.docs[index - 1]['sender'],
              sentByMe: uid == snapshot.data.docs[index - 1]['senderId'],
              isEnter: snapshot.data.docs[index - 1]['isEnter'],
              time: snapshot.data.docs[index - 1]['time'],
              senderId: snapshot.data.docs[index - 1]['senderId'],
              duplicateNickName: duplicateNickName,
              duplicateTime: duplicateTime,
              orderMessage: snapshot.data.docs[index - 1]['orderMessage'],
              adminInfo: adminInfo,
            );
          },
        );
      } else {
        return Container();
      }
    },
  );
}
