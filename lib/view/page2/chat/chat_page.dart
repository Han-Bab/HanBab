import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:han_bab/view/app.dart';
import 'package:han_bab/view/page2/chat/chat_page_info.dart';
import 'package:han_bab/view/page2/chat/delivery_tip.dart';
import 'package:han_bab/view/page2/chat/togetherOrder.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../database/databaseService.dart';
import '../../../main.dart';
import '../../../widget/currencyInputFormatter.dart';
import '../../../widget/endDrawer.dart';
import 'chat_messages.dart';
import 'component/message_input_textfield.dart';

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

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();
  String admin = "";
  ScrollController scrollController = ScrollController();
  final uid = FirebaseAuth.instance.currentUser?.uid;
  late Uri _url;
  late Timer _timer;
  var adminInfo;

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  void scrollToBottom() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.jumpTo(0);
      }
    });
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  void setNotificationEnabled(bool enabled) async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: enabled,
      badge: enabled,
      sound: enabled,
    );
    setState(() {
      isInChatPage = !enabled;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getChatandAdmin();
    getMembers();
    setNotificationEnabled(false); // 알림 비활성화

    scrollToBottom();

    if (widget.addRoom) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showAdminNotice();
      });
    }
    if (widget.firstVisit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showParticipantNotice();
      });
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(
          () {}); // This setState() call will periodically update the StreamBuilder.
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
      DatabaseService().getUserInfo(getId(admin)).then((value) {
        setState(() {
          adminInfo = value;
        });
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

  void resetMembers(List<dynamic> members) {
    List ids = members.map((member) {
      return member.split('_').first;
    }).toList();

    // 추출한 ID로 resetRest 함수 실행
    for (String id in ids) {
      DatabaseService().resetRest(id);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: members,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData && snapshot.data.exists) {
          if ((snapshot.data['members'].length ==
                      int.parse(snapshot.data['maxPeople']) ||
                  (snapshot.data['orderTime'] ==
                          DateFormat("HH:mm").format(DateTime.now()) &&
                      snapshot.data['date'] ==
                          DateFormat("yyyy-MM-dd").format(DateTime.now()))) &&
              snapshot.data['close'] == -1) {
            if ((snapshot.data['members'].length ==
                int.parse(snapshot.data['maxPeople']) ||
                (snapshot.data['orderTime'] ==
                    DateFormat("HH:mm").format(DateTime.now()) &&
                    snapshot.data['date'] ==
                        DateFormat("yyyy-MM-dd").format(DateTime.now()))) &&
                snapshot.data['close'] == -1) {
              DatabaseService().closeRoom(snapshot.data['groupId'], 1).then((_) {
                if (admin.contains(uid!)) {
                  closeRoomNotice(
                    context,
                    snapshot.data['groupId'],
                    snapshot.data['groupName'],
                    widget.userName,
                    uid,
                  );
                }
              });
            }
          }

          return GestureDetector(
            onTap: () {
              final FocusScopeNode currentScope = FocusScope.of(context);
              if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
                FocusManager.instance.primaryFocus?.unfocus();
              }
            },
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity! > 0) {
                // 오른쪽으로 밀었을 때
                setNotificationEnabled(true);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const App()),
                    (route) => false);
              }
            },
            child: WillPopScope(
              onWillPop: () async {
                return false;
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
                      setNotificationEnabled(true);

                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const App()),
                          (route) => false);
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
                  groupDate: snapshot.data['date'],
                  groupTime: snapshot.data['orderTime'],
                  groupPlace: snapshot.data['pickup'],
                  groupAll: int.parse(snapshot.data['maxPeople']),
                  admin: snapshot.data['admin'],
                  userName: widget.userName,
                  members: snapshot.data['members'],
                  restUrl: snapshot.data['restUrl'],
                  close: snapshot.data['close'].toDouble(),
                  deliveryTip: snapshot.data['deliveryTip'],
                ),
                body: SafeArea(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3.0),
                          child: ChatInfo(snapshot: snapshot),
                        ),
                        Expanded(
                          child: Stack(
                            children: <Widget>[
                              ChatMessages(
                                chats: chats,
                                userName: widget.userName,
                                admin: admin,
                                uid: uid,
                                scrollController: scrollController,
                                isDeliveryTip: snapshot.data['deliveryTip'],
                                money: snapshot.data['deliveryTip'] /
                                    snapshot.data['members'].length,
                                adminInfo: adminInfo,
                                groupId: widget.groupId,
                              ),
                              Column(
                                children: [
                                  TogetherOrder(
                                    close: snapshot.data['close'] == -2
                                        ? true
                                        : false,
                                    link: snapshot.data["togetherOrder"],
                                  ),
                                  (admin.contains(uid!) &&
                                          snapshot.data["deliveryTip"] == -1)
                                      ? DeliveryTip(
                                          groupId: snapshot.data["groupId"],
                                        )
                                      : Container(),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // 정산 snackbar
                        (admin.contains(uid!) && snapshot.data["close"] >= 2)
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, right: 15.0, bottom: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: snapshot.data["close"] == 2.5
                                                ? const Color(0xff3DBABE)
                                                : const Color(0xffFB973D)),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              16, 8, 12, 8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                snapshot.data["close"] == 2
                                                    ? "식비 정산이 완료되면 알려주세요!"
                                                    : snapshot.data["close"] ==
                                                            2.5
                                                        ? "배달의 민족 주문이 완료되었나요?"
                                                        : snapshot.data[
                                                                    "close"] ==
                                                                3
                                                            ? "음식 수령 후 배달비를 정산해주세요!"
                                                            : "배달비 정산이 완료되면 알려주세요!",
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontFamily:
                                                        "PretendardSemiBold",
                                                    color: Colors.white),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  if (snapshot.data["close"] ==
                                                      2) {
                                                    Map<String, dynamic>
                                                        chatMessageMap = {
                                                      "message": "식비 정산 완료",
                                                      "sender": widget.userName,
                                                      "time": DateTime.now()
                                                          .toString(),
                                                      "isEnter": 0,
                                                      "senderId": uid,
                                                      "orderMessage": 2
                                                    };

                                                    DatabaseService()
                                                        .sendMessage(
                                                            widget.groupId,
                                                            widget.groupName,
                                                            chatMessageMap);

                                                    DatabaseService().closeRoom(
                                                        snapshot
                                                            .data["groupId"],
                                                        2.5);
                                                  } else if (snapshot
                                                          .data["close"] ==
                                                      2.5) {
                                                    Map<String, dynamic>
                                                        chatMessageMap = {
                                                      "message": "배달의 민족 주문 완료",
                                                      "sender": widget.userName,
                                                      "time": DateTime.now()
                                                          .toString(),
                                                      "isEnter": 0,
                                                      "senderId": uid,
                                                      "orderMessage": 3
                                                    };

                                                    DatabaseService()
                                                        .sendMessage(
                                                            widget.groupId,
                                                            widget.groupName,
                                                            chatMessageMap);

                                                    DatabaseService().closeRoom(
                                                        snapshot
                                                            .data["groupId"],
                                                        3);
                                                  } else if (snapshot
                                                          .data["close"] ==
                                                      3) {
                                                    inputDeliveryTip(
                                                        context,
                                                        snapshot
                                                            .data["groupId"]);
                                                  } else if (snapshot
                                                          .data["close"] ==
                                                      4) {
                                                    resetMembers(snapshot
                                                        .data["members"]);
                                                    Map<String, dynamic>
                                                        chatMessageMap = {
                                                      "message": "배달비 정산 완료",
                                                      "sender": widget.userName,
                                                      "time": DateTime.now()
                                                          .toString(),
                                                      "isEnter": 0,
                                                      "senderId": uid,
                                                      "orderMessage": 5
                                                    };

                                                    DatabaseService()
                                                        .sendMessage(
                                                            widget.groupId,
                                                            widget.groupName,
                                                            chatMessageMap);

                                                    DatabaseService()
                                                        .resetRest(uid!);
                                                    DatabaseService().closeRoom(
                                                        snapshot
                                                            .data["groupId"],
                                                        -2);
                                                  }
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                      color: Colors.white),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10.0,
                                                        vertical: 7.0),
                                                    child: Text(
                                                      snapshot.data["close"] ==
                                                              2
                                                          ? "정산완료"
                                                          : snapshot.data[
                                                                      "close"] ==
                                                                  2.5
                                                              ? "주문완료"
                                                              : snapshot.data[
                                                                          "close"] ==
                                                                      3
                                                                  ? "정산하기"
                                                                  : "정산완료",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "PretendardSemiBold",
                                                          color: snapshot.data[
                                                                      "close"] ==
                                                                  2.5
                                                              ? const Color(
                                                                  0xff3DBABE)
                                                              : const Color(
                                                                  0xffFB973D),
                                                          fontSize: 14),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                        Column(
                          children: [
                            const Divider(
                              color: Color(0xffC2C2C2),
                              thickness: 0.5,
                              height: 0,
                            ),
                            // 메시지 입력창
                            messageInputTextField(
                                messageController,
                                widget.userName,
                                uid,
                                widget.groupId,
                                widget.groupName,
                                scrollController,
                                context)
                          ],
                        ),
                      ],
                    ),
                  ),
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

  showAdminNotice() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => Dialog(
              child: Container(
                // height: MediaQuery.of(context).size.height * 0.34,
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
                            fontWeight: FontWeight.bold,
                            color: Color(0xffFB813D)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "채팅방 정보에 ‘배달팁’을 기입하시면 참여인원에 맞춰 자동으로 배달비를 계산해드려요! ",
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      RichText(
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
                              text: '에서 총 배달팁을 확인하실 수 있습니다.',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 22,
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
                                                  const Text(
                                                    "총 배달팁도 꼭 확인해주세요 ><",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontFamily:
                                                            "PretendardMedium",
                                                        color:
                                                            Color(0xff3DBABE)),
                                                  ),
                                                  const SizedBox(
                                                    height: 19,
                                                  ),
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
                                                          height: 45,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: const Color(
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
                                                          height: 45,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: const Color(
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
                                height: 45,
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
                        "원활한 주문을 위해 배달의민족 함께 주문하기 페이지로 이동합니다. 주문하실 음식을 선택해주세요!",
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 38,
                      ),
                      const Text(
                        "주문마감 전까지는 메뉴 변경이 가능해요 :) ",
                        style: TextStyle(
                            fontSize: 13,
                            fontFamily: "PretendardSemiBold",
                            color: Color(0xff3DBABE)),
                      ),
                      const SizedBox(
                        height: 19,
                      ),
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

  Future inputDeliveryTip(context, groupId) {
    TextEditingController textEditingController = TextEditingController();
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => Dialog(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(29.5, 30, 29.5, 21.33),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "총 배달팁 확인",
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: "PretendardSemiBold",
                      color: Color(0xffFB813D)),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "추가 비용이 있으면 총 배달팁을 \n수정한 뒤 정산해주세요. ",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFormField(
                  controller: textEditingController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [CurrencyInputFormatter()],
                  style: const TextStyle(fontSize: 16),
                  decoration: const InputDecoration(
                    suffix: Padding(
                      padding: EdgeInsets.only(right: 10.0),
                      child: Text("원"),
                    ),
                    suffixStyle: TextStyle(color: Colors.black, fontSize: 16),
                    isDense: true,
                    contentPadding: EdgeInsets.only(bottom: 5),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Map<String, dynamic> chatMessageMap = {
                            "message": "배달비 정산 요청",
                            "sender": widget.userName,
                            "time": DateTime.now().toString(),
                            "isEnter": 0,
                            "senderId": uid,
                            "orderMessage": 4
                          };

                          DatabaseService().sendMessage(
                              widget.groupId, widget.groupName, chatMessageMap);

                          DatabaseService().closeRoom(widget.groupId, 4);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color(0xffF1F1F1),
                              borderRadius: BorderRadius.circular(10)),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 11.5),
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
                          DatabaseService().setDeliveryTip(
                              groupId,
                              int.parse(textEditingController.text
                                  .replaceAll(',', '')));
                          Navigator.pop(context);
                          Map<String, dynamic> chatMessageMap = {
                            "message": "배달비 정산 요청",
                            "sender": widget.userName,
                            "time": DateTime.now().toString(),
                            "isEnter": 0,
                            "senderId": uid,
                            "orderMessage": 4
                          };

                          DatabaseService().sendMessage(
                              widget.groupId, widget.groupName, chatMessageMap);

                          DatabaseService().closeRoom(widget.groupId, 4);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color(0xffFB973D),
                              borderRadius: BorderRadius.circular(10)),
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
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future closeRoomNotice(context, groupId, groupName, userName, uid) {
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
