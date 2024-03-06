import 'package:flutter/cupertino.dart';
import 'package:han_bab/widget/notification.dart';

import '../../../widget/message_tile.dart';

Widget chatMessages(chats, userName, admin, uid, scrollController) {
// Add scrollToBottom method to scroll to the bottom of the chat

  return StreamBuilder(
    stream: chats,
    builder: (context, AsyncSnapshot snapshot) {
      if (snapshot.hasData) {
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 15),
          itemCount: snapshot.data.docs.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Container(
                  height: admin.contains(uid ?? "")
                      ? 115
                      : 60); // Adjust height as needed
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
            return MessageTile(
              message: snapshot.data.docs[index - 1]['message'],
              sender: snapshot.data.docs[index - 1]['sender'],
              sentByMe: uid == snapshot.data.docs[index - 1]['senderId'],
              isEnter: snapshot.data.docs[index - 1]['isEnter'],
              time: snapshot.data.docs[index - 1]['time'],
              senderId: snapshot.data.docs[index - 1]['senderId'],
              duplicateNickName: duplicateNickName,
              duplicateTime: duplicateTime,
              orderMessage: snapshot.data.docs[index - 1]['orderMessage'],
            );
          },
          // Add the scrollController here
          controller: scrollController,
        );
      } else {
        return Container();
      }
    },
  );
}
