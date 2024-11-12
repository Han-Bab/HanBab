import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../widget/message_tile.dart';

class ChatMessages extends StatefulWidget {
  final Stream<QuerySnapshot>? chats;
  final String userName;
  final String admin;
  final String? uid;
  final ScrollController scrollController;
  final int isDeliveryTip;
  final double money;
  final dynamic adminInfo;
  final String groupId;

  const ChatMessages({
    Key? key,
    required this.chats,
    required this.userName,
    required this.admin,
    required this.uid,
    required this.scrollController,
    required this.isDeliveryTip,
    required this.money,
    required this.adminInfo,
    required this.groupId,
  }) : super(key: key);

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  late ScrollController _scrollController;
  int chatCount = 0;

  @override
  void initState() {
    _scrollController = widget.scrollController;
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.chats,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final chatDocs = snapshot.data.docs;
          bool newChat = (chatCount != chatDocs.length);
          chatCount = chatDocs.length;

          return ListView.builder(
            reverse: true,
            controller: _scrollController,
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 15),
            itemCount: chatDocs.length,
            itemBuilder: (context, index) {
              final chatData = chatDocs[index];

              // 닉네임 표시 여부: 같은 발신자 & 같은 시간 그룹의 첫 메시지
              bool showNickName = true;
              if (index < chatDocs.length - 1) {
                final nextChat = chatDocs[index + 1];
                if (chatData['senderId'] == nextChat['senderId'] &&
                    chatData['time'].toString().substring(0, 16) ==
                        nextChat['time'].toString().substring(0, 16)) {
                  showNickName = false;
                }
              }

              // 시간 표시 여부: 같은 발신자 & 같은 시간 그룹의 마지막 메시지
              bool showTime = true;
              if (index > 0) {
                final prevChat = chatDocs[index - 1];
                if (chatData['senderId'] == prevChat['senderId'] &&
                    chatData['time'].toString().substring(0, 16) ==
                        prevChat['time'].toString().substring(0, 16)) {
                  showTime = false;
                }
              }

              // 새로운 메시지가 추가되었을 때 화면 하단으로 이동
              if (index == 0 && newChat && widget.uid != chatData['senderId']) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients) {
                    _scrollController.jumpTo(0);
                  }
                });
              }

              return MessageTile(
                money: widget.money,
                message: chatData['message'],
                sender: chatData['sender'],
                sentByMe: widget.uid == chatData['senderId'],
                isEnter: chatData['isEnter'],
                time: chatData['time'],
                senderId: chatData['senderId'],
                duplicateNickName: !showNickName,
                duplicateTime: !showTime,
                orderMessage: chatData['orderMessage'],
                adminInfo: widget.adminInfo,
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
