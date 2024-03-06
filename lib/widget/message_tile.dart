import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../database/databaseService.dart';

class MessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final bool sentByMe;
  final int isEnter;
  final String time;
  final bool duplicateNickName;
  final bool duplicateTime;
  final int orderMessage;
  final String senderId;

  const MessageTile(
      {Key? key,
      required this.message,
      required this.sender,
      required this.sentByMe,
      required this.isEnter,
      required this.time,
      required this.duplicateNickName,
      required this.duplicateTime,
      required this.orderMessage,
      required this.senderId})
      : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  void launchUrl(String link) async {
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      throw "Could not launch $link";
    }
  }

  @override
  Widget build(BuildContext context) {
    //isEnter == 1 'Enter' or 'Exit'
    //isEnter == 0 'Chats'
    return widget.isEnter == 1
        ? Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xffF1F1F1)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.message,
                    style: const TextStyle(
                        color: Color(0xff717171),
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          )
        : Container(
            padding: EdgeInsets.only(
                top: 4,
                bottom: 4,
                left: widget.sentByMe ? 0 : 19,
                right: widget.sentByMe ? 19 : 0),
            alignment:
                widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: widget.sentByMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                !widget.duplicateNickName
                    ? Text(
                        widget.sentByMe ? "나" : widget.sender.toUpperCase(),
                        style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xff3E3E3E),
                            letterSpacing: -0.5),
                      )
                    : Container(),
                Row(
                  mainAxisAlignment: !widget.sentByMe
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    !widget.duplicateTime
                        ? widget.sentByMe
                            //시간
                            ? Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 50),
                                    child: Text(
                                      DateFormat('h:mm a')
                                          .format(DateTime.parse(widget.time)),
                                      style: const TextStyle(
                                          fontSize: 10,
                                          color: Color(0xff717171)),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                ],
                              )
                            : Container()
                        : Container(),
                    // 메시지
                    widget.orderMessage == 1
                        ? orderCard1() : widget.orderMessage == 2 ? orderCard2()
                        : Flexible(
                            child: Container(
                              margin: widget.duplicateTime
                                  ? widget.sentByMe
                                      ? const EdgeInsets.only(left: 50)
                                      : const EdgeInsets.only(right: 50)
                                  : null,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              decoration: BoxDecoration(
                                  borderRadius: widget.sentByMe
                                      ? const BorderRadius.only(
                                          topLeft: Radius.circular(16),
                                          bottomRight: Radius.circular(16),
                                          bottomLeft: Radius.circular(16),
                                        )
                                      : const BorderRadius.only(
                                          topRight: Radius.circular(16),
                                          bottomLeft: Radius.circular(16),
                                          bottomRight: Radius.circular(16),
                                        ),
                                  color: widget.sentByMe
                                      ? const Color(0xFF75B165)
                                      : const Color(0xFFF1F1F1)),
                              child: Linkify(
                                text: widget.message,
                                onOpen: (link) => launchUrl(link.url),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: widget.sentByMe
                                        ? Colors.white
                                        : const Color(0xFF3E3E3E)),
                                linkStyle: TextStyle(
                                    color: widget.sentByMe
                                        ? Colors.yellow
                                        : Colors.blue,
                                    decoration: TextDecoration.none),
                              ),
                            ),
                          ),
                    //시간
                    !widget.duplicateTime
                        ? !widget.sentByMe
                            ? Row(
                                children: [
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 30.0, right: 50),
                                    child: Text(
                                        DateFormat('h:mm a').format(
                                            DateTime.parse(widget.time)),
                                        style: const TextStyle(
                                            fontSize: 10,
                                            color: Color(0xff717171))),
                                  ),
                                ],
                              )
                            : Container()
                        : Container(),
                  ],
                ),
              ],
            ),
          );
  }
}

Widget orderCard1() {
  return Flexible(
    child: Stack(
      children: [
        Image.asset(
          "./assets/icons/chat_icons/card1.png",
          scale: 2,
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: 35.0, left: 25),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              const Text(
                "식비 정산 요청",
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: "PretendardSemiBold",
                    color: Color(0xffFB813D)),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "송금하실 결제 수단을 선택해주세요.",
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(
                height: 25,
              ),
              Column(
                children: [
                  GestureDetector(
                      onTap: () {
                        // DatabaseService()
                        //     .getUserInfo(
                        //     widget.senderId)
                        //     .then((value) => {
                        //
                        // });
                      },
                      child: Image.asset(
                        "./assets/icons/chat_icons/kakaopay.png",
                        scale: 2,
                      )),
                  const SizedBox(
                    height: 5,
                  ),
                  Image.asset(
                    "./assets/icons/chat_icons/toss.png",
                    scale: 2,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Image.asset(
                    "./assets/icons/chat_icons/personal.png",
                    scale: 2,
                  ),
                ],
              )
            ],
          ),
        )
      ],
    ),
  );
}

Widget orderCard2() {
  return Flexible(
    child: Stack(
      children: [
        Image.asset(
          "./assets/icons/chat_icons/card2.png",
          scale: 2,
        ),
        const Padding(
          padding: EdgeInsets.only(
              top: 35.0, left: 25),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                "식비 정산 완료",
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: "PretendardSemiBold",
                    color: Color(0xffFB813D)),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "주문이 완료되면 다시 알려드릴게요!",
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(
                height: 15,
              ),
              Text("TIP", style: TextStyle(fontFamily: "PretendardMedium", fontSize: 12, color: Color(0xffFB813D)),),
              Text("만약 주문이 진행되지 않으면 방장에게 \n연락하거나 신고해주세요!", style: TextStyle(fontSize: 14),)
            ],
          ),
        )
      ],
    ),
  );
}