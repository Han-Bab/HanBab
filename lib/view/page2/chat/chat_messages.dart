import 'package:flutter/cupertino.dart';
import 'package:han_bab/widget/notification.dart';

import '../../../widget/message_tile.dart';



Widget chatMessages(chats, userName, admin, uid, scrollController) {

// Add scrollToBottom method to scroll to the bottom of the chat
  void scrollToBottom() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  return StreamBuilder(
    stream: chats,
    builder: (context, AsyncSnapshot snapshot) {
      if (snapshot.hasData) {
        // Scroll to the bottom whenever new messages are loaded.
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          scrollToBottom();
        });
      }
      return snapshot.hasData
          ? ListView.builder(
        itemCount: snapshot.data.docs.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Container(height: admin.contains(uid ?? "") ? 115 : 60); // Adjust height as needed
          }
          if (index == snapshot.data.docs.length + 1) {
            return Container(height: 70);
          }
          bool duplicateNickName = false;
          bool duplicateTime = false;
          if (index > 1 &&
              snapshot.data.docs[index - 2]['isEnter'] != 1 &&
              snapshot.data.docs[index - 1]['sender'] ==
                  snapshot.data.docs[index - 2]['sender']) {
            duplicateNickName = true;
          }
          if (index < snapshot.data.docs.length &&
              snapshot.data.docs[index - 1]['sender'] ==
                  snapshot.data.docs[index]['sender']) {
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
            sentByMe: uid ==
                snapshot.data.docs[index - 1]['senderId'],
            isEnter: snapshot.data.docs[index - 1]['isEnter'],
            time: snapshot.data.docs[index - 1]['time'],
            duplicateNickName: duplicateNickName,
            duplicateTime: duplicateTime,
          );
        },
        // Add the scrollController here
        controller: scrollController,
      )
          : Container();
    },
  );
}