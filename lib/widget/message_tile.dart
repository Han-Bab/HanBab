import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../database/databaseService.dart';
import 'alert.dart';
import 'encryption.dart';

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
  final double money;
  final adminInfo;

  const MessageTile(
      {super.key,
      required this.message,
      required this.sender,
      required this.sentByMe,
      required this.isEnter,
      required this.time,
      required this.duplicateNickName,
      required this.duplicateTime,
      required this.orderMessage,
      required this.senderId,
      required this.money,
      required this.adminInfo});

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
                        ? orderCard1(context, widget.adminInfo)
                        : widget.orderMessage == 2
                            ? orderCard2(context)
                            : widget.orderMessage == 3
                                ? orderCard3(context)
                                : widget.orderMessage == 4
                                    ? orderCard4(
                                        context, widget.money, widget.adminInfo)
                                    : widget.orderMessage == 5
                                        ? orderCard5(context)
                                        : Flexible(
                                            child: Container(
                                              margin: widget.duplicateTime
                                                  ? widget.sentByMe
                                                      ? const EdgeInsets.only(
                                                          left: 50)
                                                      : const EdgeInsets.only(
                                                          right: 50)
                                                  : null,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 16),
                                              decoration: BoxDecoration(
                                                  borderRadius: widget.sentByMe
                                                      ? const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  16),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  16),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  16),
                                                        )
                                                      : const BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  16),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  16),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  16),
                                                        ),
                                                  color: widget.sentByMe
                                                      ? const Color(0xFF75B165)
                                                      : const Color(
                                                          0xFFF1F1F1)),
                                              child: Linkify(
                                                text: widget.message,
                                                onOpen: (link) =>
                                                    launchUrl(link.url),
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: widget.sentByMe
                                                        ? Colors.white
                                                        : const Color(
                                                            0xFF3E3E3E)),
                                                linkStyle: TextStyle(
                                                    color: widget.sentByMe
                                                        ? Colors.yellow
                                                        : Colors.blue,
                                                    decoration:
                                                        TextDecoration.none),
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

Widget orderCard1(context, adminInfo) {
  return Flexible(
    child: Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 3.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 0.5),
                )
              ],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  sendMoney(context, adminInfo)
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 22.5),
          child: Image.asset(
            "./assets/icons/chat_icons/flag.png",
            scale: 2,
          ),
        ),
      ],
    ),
  );
}

Widget orderCard2(context) {
  return Flexible(
    child: Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 3.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 0.5),
                )
              ],
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Padding(
              padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "TIP",
                    style: TextStyle(
                        fontFamily: "PretendardMedium",
                        fontSize: 12,
                        color: Color(0xffFB813D)),
                  ),
                  Text(
                    "만약 주문이 진행되지 않으면 방장에게 \n연락하거나 신고해주세요!",
                    style: TextStyle(fontSize: 13),
                  )
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 22.5),
          child: Image.asset(
            "./assets/icons/chat_icons/flag.png",
            scale: 2,
          ),
        ),
      ],
    ),
  );
}

Widget orderCard3(context) {
  return Flexible(
    child: Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 3.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 0.5),
                )
              ],
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Padding(
              padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "배달의 민족 주문 완료",
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: "PretendardSemiBold",
                        color: Color(0xff3DBABE)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "[배달의 민족] 배송 시작 알림에 따라 \n주문 장소로 모여주세요!",
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 22.5),
          child: Image.asset(
            "./assets/icons/chat_icons/flag2.png",
            scale: 2,
          ),
        ),
      ],
    ),
  );
}

Widget orderCard4(context, money, adminInfo) {
  return Flexible(
    child: Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 3.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 0.5),
                )
              ],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "배달비 정산 요청",
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: "PretendardSemiBold",
                        color: Color(0xffFB813D)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "${NumberFormat('#,###').format(money)}원",
                          style: const TextStyle(
                              fontSize: 20,
                              fontFamily: "PretendardSemiBold",
                              color: Colors.black),
                        ),
                        const TextSpan(
                          text: ' 씩 보내주세요.',
                          style: TextStyle(
                              fontFamily: "PretendardMedium",
                              fontSize: 16,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  sendMoney(context, adminInfo)
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 22.5),
          child: Image.asset(
            "./assets/icons/chat_icons/flag.png",
            scale: 2,
          ),
        ),
      ],
    ),
  );
}

Widget orderCard5(context) {
  return Flexible(
    child: Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 3.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 0.5),
                )
              ],
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Padding(
              padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "배달비 정산 완료",
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: "PretendardSemiBold",
                        color: Color(0xffFB813D)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "모든 거래가 마무리 되었습니다 :)  함께하는 가치있는 소비를 응원해요!",
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 22.5),
          child: Image.asset(
            "./assets/icons/chat_icons/flag.png",
            scale: 2,
          ),
        ),
      ],
    ),
  );
}

Widget sendMoney(context, adminInfo) {
  Uri _url;

  bool _isValidUrl(String url) {
    final Uri? uri = Uri.tryParse(url);
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }


  Future<void> _launchUrl(Uri url) async {
    if (!_isValidUrl(url.toString())) {
      // URL 형식이 유효하지 않은 경우
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertModal(
            text: '잘못된 링크입니다.',
            yesOrNo: false,
            function: () {
            },
          )
      );
      return; // 함수 종료
    }

    // URL 형식이 유효한 경우, URL 열기 시도
    if (!await launchUrl(url)) {
      // URL을 성공적으로 열 수 없는 경우
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertModal(
          text: '잘못된 링크입니다.',
          yesOrNo: false,
          function: () {
          },
        )
      );
    }
  }



  double width = MediaQuery.of(context).size.width;
  return Column(
    children: [
      adminInfo != null && adminInfo['kakaoLink']
          ? GestureDetector(
              onTap: () {
                _url = Uri.parse(adminInfo['kakaopay']);
                _launchUrl(_url);
              },
              child: sendBar("kakaopay", false, width))
          : sendBar("kakaopay", true, width),
      const SizedBox(
        height: 10,
      ),
      adminInfo != null && adminInfo['tossLink']
          ? GestureDetector(
              onTap: () {
                _url = Uri.parse(adminInfo["tossId"]);
                _launchUrl(_url);
              },
              child: sendBar("toss", false, width))
          : sendBar("toss", true, width),
      const SizedBox(
        height: 10,
      ),
      adminInfo != null && adminInfo['bankAccount'] != "0000000000000000"
          ? GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(
                    text: decrypt(aesKey,
                        Encrypted.fromBase16(adminInfo['bankAccount']))));
                AnimatedSnackBar.material(
                  '계좌번호가 클립보드에 복사되었습니다.',
                  type: AnimatedSnackBarType.success,
                  duration: const Duration(seconds: 4),
                  mobilePositionSettings: const MobilePositionSettings(
                    bottomOnAppearance: 50,
                  ),
                  mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                  desktopSnackBarPosition: DesktopSnackBarPosition.bottomLeft,
                ).show(context);
              },
              child: sendBar("personal", false, width))
          : sendBar("personal", true, width),
    ],
  );
}

Widget sendBar(String account, bool opacity, double width) {
  String korean;
  if (account == "kakaopay") {
    korean = "카카오페이";
  } else if (account == "toss") {
    korean = "토스페이";
  } else {
    korean = "계인계좌";
  }

  return Opacity(
    opacity: opacity ? 0.3 : 1,
    child: Container(
      width: width * 0.62,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 2,
            spreadRadius: 0,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Image.asset(
              "./assets/icons/chat_icons/$account.png",
              scale: 2,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              "$korean로 송금하기",
              style: TextStyle(fontFamily: "PretendardMedium", fontSize: 14),
            )
          ],
        ),
      ),
    ),
  );
}
