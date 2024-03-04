import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:han_bab/view/app.dart';
import 'package:han_bab/view/page2/chat/chat_page_info.dart';
import 'package:han_bab/view/page2/chat/delivery_tip.dart';
import 'package:han_bab/view/page2/chat/togetherOrder.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../database/databaseService.dart';
import '../../../widget/endDrawer.dart';
import 'chat_messages.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String groupTime;
  final String groupPlace;
  final int groupCurrent;
  final int groupAll;
  final String userName;
  final List<dynamic> members;
  final bool firstVisit;
  final bool addRoom;
  final String link;

  const ChatPage(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.userName,
      required this.groupTime,
      required this.groupPlace,
      required this.groupCurrent,
      required this.groupAll,
      required this.members,
      this.firstVisit = false,
      this.addRoom = false,
      required this.link})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();
  String admin = "";
  final FocusNode _focusNode = FocusNode();
  ScrollController scrollController = ScrollController();
  final uid = FirebaseAuth.instance.currentUser?.uid;
  late Uri _url;
  late Timer _timer;

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  @override
  void initState() {
    getChatandAdmin();
    getMembers();
    super.initState();
    widget.addRoom
        ? WidgetsBinding.instance!.addPostFrameCallback((_) {
            showAdminNotice();
          })
        : null;
    widget.firstVisit
        ? WidgetsBinding.instance!.addPostFrameCallback((_) {
            showParticipantNotice();
          })
        : null;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {}); // 이 setState() 호출은 StreamBuilder를 주기적으로 업데이트합니다.
    });
  }

  getChatandAdmin() {
    DatabaseService().getChats(widget.groupId).then((val) {
      setState(() {
        chats = val;
      });
    });
    DatabaseService().getGroupAdmin(widget.groupId).then((val) {
      setState(() {
        admin = val;
      });
    });
  }

  Stream? members;

  getMembers() async {
    DatabaseService().getGroupMembers(widget.groupId).then((val) {
      setState(() {
        members = val;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: members,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          // print(DateTime.now());
          if ((snapshot.data['members'].length ==
                      int.parse(snapshot.data['maxPeople']) ||
                  (snapshot.data['orderTime'] ==
                          DateFormat("HH:mm").format(DateTime.now()) &&
                      snapshot.data['date'] ==
                          DateFormat("yyyy-MM-dd").format(DateTime.now()))) &&
              snapshot.data['close'] == -1) {
            DatabaseService().closeRoom(snapshot.data['groupId'], 0);
          }
          if (snapshot.data['close'] == 0) {
            WidgetsBinding.instance!.addPostFrameCallback((_) {
              DatabaseService()
                  .closeRoom(snapshot.data['groupId'], 1)
                  .then((value) => {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) => Dialog(
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.34,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          29, 28, 29, 25),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            "주문 마감, 정산 시작!",
                                            style: TextStyle(
                                                fontFamily:
                                                    "PretendardSemiBold",
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
                                                  text: '먼저 ',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black),
                                                ),
                                                TextSpan(
                                                  text: '음식비를 정산',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontFamily:
                                                          "PretendardBold",
                                                      color: Colors.black),
                                                ),
                                                TextSpan(
                                                  text:
                                                      '해주세요. 꼭 식비 정산을 완료하고 주문을 진행해주세요!',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 34,
                                          ),
                                          const Expanded(
                                              child: Text(
                                            "음식값을 보내지 않는 구성원이 있다면 해당 음식을 제외하고 주문을 진행해주세요!",
                                            style: TextStyle(fontSize: 14),
                                          )),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: const Color(
                                                            0xffFB973D)),
                                                    child: const Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 11.5),
                                                      child: Center(
                                                          child: Text(
                                                        "확인",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontFamily:
                                                                "PretendardMedium",
                                                            color:
                                                                Colors.white),
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
                                ))
                      });
            });
          }

          return GestureDetector(
            onTap: () {
              if (!_focusNode.hasFocus) {
                FocusScope.of(context).unfocus();
              }
            },
            child: Scaffold(
              appBar: AppBar(
                scrolledUnderElevation: 0,
                iconTheme: const IconThemeData(color: Colors.black),
                centerTitle: true,
                elevation: 0,
                title: Text(
                  snapshot.data['groupName'],
                  style: const TextStyle(
                      fontFamily: "PretendardMedium",
                      color: Colors.black,
                      fontSize: 18),
                ),
                leading: IconButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const App()),
                        (route) => true);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 20,
                  ),
                ),
              ),
              endDrawer: EndDrawer(
                groupId: widget.groupId,
                groupName: snapshot.data['groupName'],
                groupTime: snapshot.data['orderTime'],
                groupPlace: snapshot.data['pickup'],
                groupAll: int.parse(snapshot.data['maxPeople']),
                admin: snapshot.data['admin'],
                userName: widget.userName,
                members: snapshot.data['members'],
                restUrl: snapshot.data['restUrl'],
                close: snapshot.data['close'],
              ),
              body: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    ChatInfo(snapshot: snapshot),
                    Expanded(
                      child: Stack(
                        children: <Widget>[
                          chatMessages(chats, widget.userName, admin, uid,
                              scrollController),
                          Container(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 40),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const SizedBox(
                                    height: 32,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                      color: const Color(0xFFffffff),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.25),
                                            blurRadius: 13.0,
                                            // soften the shadow
                                            offset: const Offset(0, 0.5))
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          24, 3, 8, 3),
                                      child: Row(children: [
                                        Expanded(
                                            child: TextFormField(
                                          controller: messageController,
                                          style: const TextStyle(
                                              color: Colors.black),
                                          decoration: const InputDecoration(
                                            hintText:
                                                // widget.firstVisit == false ? "메시지를 입력할 수 없는 상태입니다" :
                                                "메시지 입력하세요",
                                            hintStyle: TextStyle(
                                                color: Color(0xff919191),
                                                fontSize: 16),
                                            //회색
                                            border: InputBorder.none,
                                          ),
                                        )),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            sendMessage();
                                          },
                                          child: Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            child: Center(
                                                child: Image.asset(
                                                    "./assets/icons/message.png")),
                                          ),
                                        )
                                      ]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              TogetherOrder(
                                link: snapshot.data["togetherOrder"],
                              ),
                              admin.contains(uid ?? "")
                                  ? DeliveryTip(
                                      groupId: snapshot.data["groupId"],
                                    )
                                  : Container(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Center(
              child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ));
        }
      },
    );
  }

  void scrollToBottom() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": widget.userName,
        "time": DateTime.now().toString(),
        "isEnter": 0,
        "senderId": uid
      };

      DatabaseService().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        messageController.clear();
      });

      // Add call to scrollToBottom here
      scrollToBottom();
    }
  }

  showAdminNotice() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => Dialog(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.34,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(29, 28, 29, 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "총배달팁 입력해주세요",
                        style: TextStyle(
                            fontFamily: "PretendardSemiBold",
                            fontSize: 18,
                            color: Color(0xffFB813D)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "채팅방 정보에 ‘배달팁’을 기입하시면  참여인원에 맞춰 자동으로 배달비를  계산해드려요! ",
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Expanded(
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: '[배민] -[함께주문하기]',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "PretendardSemiBold",
                                    color: Colors.black),
                              ),
                              TextSpan(
                                text: '에서  총 배달팁을 확인하실 수 있습니다.',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) => Dialog(
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.34,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.white),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      29, 28, 29, 25),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Text(
                                                    "주문할 메뉴를 결정하셨나요?",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "PretendardSemiBold",
                                                        fontSize: 18,
                                                        color:
                                                            Color(0xff3DBABE)),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  RichText(
                                                    text: const TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: '[함께 주문 바로가기]',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontFamily:
                                                                  "PretendardBold",
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        TextSpan(
                                                          text:
                                                              '에서 메뉴를 담고 빠르게 주문해보세요!',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 60,
                                                  ),
                                                  const Expanded(
                                                      child: Text(
                                                    "총 배달팁도 꼭 확인해주세요 ><",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontFamily:
                                                            "PretendardMedium",
                                                        color:
                                                            Color(0xff3DBABE)),
                                                  )),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                          child:
                                                              GestureDetector(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: Color(
                                                                  0xffF1F1F1)),
                                                          child: const Center(
                                                              child: Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        11.5),
                                                            child: Text(
                                                              "나중에 담기",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "PretendardMedium",
                                                                  color: Color(
                                                                      0xff313131),
                                                                  fontSize: 16),
                                                            ),
                                                          )),
                                                        ),
                                                      )),
                                                      const SizedBox(
                                                        width: 12,
                                                      ),
                                                      Expanded(
                                                          child:
                                                              GestureDetector(
                                                        onTap: () {
                                                          _url = Uri.parse(
                                                              widget.link);
                                                          _launchUrl();
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: Color(
                                                                  0xff3DBABE)),
                                                          child: const Center(
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          11.5),
                                                              child: Text(
                                                                "메뉴 담기",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "PretendardMedium",
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ))
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
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0xffFB973D)),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 11.5),
                                  child: Center(
                                      child: Text(
                                    "다음",
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

  showParticipantNotice() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => Dialog(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.34,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(29, 28, 29, 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "주문할 메뉴를 담아주세요!",
                        style: TextStyle(
                            fontFamily: "PretendardSemiBold",
                            fontSize: 18,
                            color: Color(0xff3DBABE)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "원활한 주문을 위해 배달의민족 함께  주문하기 페이지로 이동합니다. 주문하실 음식을 선택해주세요!",
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 38,
                      ),
                      const Expanded(
                          child: Text(
                        "주문마감 전까지는 메뉴 변경이 가능해요 :) ",
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "PretendardSemiBold",
                            color: Color(0xff3DBABE)),
                      )),
                      Row(
                        children: [
                          Expanded(
                              child: GestureDetector(
                            onTap: () {
                              _url = Uri.parse(widget.link);
                              _launchUrl();
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color(0xff3DBABE)),
                              child: const Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 11.5),
                                  child: Text(
                                    "메뉴 선택하기",
                                    style: TextStyle(
                                        fontFamily: "PretendardMedium",
                                        color: Colors.white,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                          ))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ));
  }
}
