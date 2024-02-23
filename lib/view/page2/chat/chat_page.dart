import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:han_bab/view/app.dart';
import 'package:han_bab/view/page2/chat/chat_page_info.dart';
import 'package:han_bab/view/page2/chat/delivery_tip.dart';
import 'package:han_bab/view/page2/chat/togetherOrder.dart';
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

  // late bool firstVisit;
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
      // required this.firstVisit
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
            showNotice();
          })
        : null;
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
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: members,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData &&
            snapshot.data?.data()?.containsKey('members') == true) {
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
              ),
              body: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    ChatInfo(snapshot: snapshot),
                    Expanded(
                      child: Stack(
                        children: <Widget>[
                          // if (widget.firstVisit)
                          chatMessages(chats, widget.userName, admin, uid,
                              scrollController)
                          // else
                          // Padding(
                          //   padding:
                          //       const EdgeInsets.only(top: 135.0, left: 25),
                          //   child: Container(
                          //     width: 275,
                          //     decoration: const BoxDecoration(
                          //         color: Color(0xffF1F1F1),
                          //         borderRadius: BorderRadius.only(
                          //             topRight: Radius.circular(16),
                          //             bottomLeft: Radius.circular(16),
                          //             bottomRight: Radius.circular(16))),
                          //     child: Padding(
                          //       padding:
                          //           const EdgeInsets.fromLTRB(15.0, 10, 15, 20),
                          //       child: Column(
                          //         mainAxisSize: MainAxisSize.min,
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           Wrap(
                          //             direction: Axis.horizontal,
                          //             children: [
                          //               Text(
                          //                 "안녕하세요, ${widget.userName}님은 ",
                          //                 style: const TextStyle(fontSize: 16),
                          //                 maxLines: null,
                          //                 softWrap: true,
                          //               ),
                          //               Text(
                          //                 widget.groupName,
                          //                 style: const TextStyle(
                          //                   fontSize: 16,
                          //                   color: Colors.orange,
                          //                   fontFamily: "PretendardSemiBold",
                          //                 ),
                          //               ),
                          //               const Text(
                          //                 " 공구 채팅 단체방에 ",
                          //                 style: TextStyle(fontSize: 16),
                          //               ),
                          //               const Text(
                          //                 "입장하셨습",
                          //                 style: TextStyle(fontSize: 16),
                          //               ),
                          //               const Text(
                          //                 "니다.",
                          //                 style: TextStyle(fontSize: 16),
                          //               ),
                          //             ],
                          //           ),
                          //           const Text(""),
                          //           Row(
                          //             children: [
                          //               const Text(
                          //                 "주문예정시간: ",
                          //                 style: TextStyle(fontSize: 16),
                          //               ),
                          //               Text(
                          //                 "${snapshot.data["date"].toString().substring(5, 7)}월 ${snapshot.data["date"].toString().substring(8, 10)}일 ${snapshot.data["orderTime"].toString().substring(0, 2)}시 ${snapshot.data["orderTime"].toString().substring(3, 5)}분",
                          //                 style: const TextStyle(
                          //                     fontSize: 16,
                          //                     fontFamily: "PretendardSemiBold"),
                          //               )
                          //             ],
                          //           ),
                          //           Row(
                          //             children: [
                          //               const Text(
                          //                 "수령장소: ",
                          //                 style: TextStyle(fontSize: 16),
                          //               ),
                          //               Text(
                          //                 "${snapshot.data["pickup"]}",
                          //                 style: const TextStyle(
                          //                     fontSize: 16,
                          //                     fontFamily: "PretendardSemiBold"),
                          //               )
                          //             ],
                          //           ),
                          //           Row(
                          //             children: [
                          //               const Text(
                          //                 "최대인원: ",
                          //                 style: TextStyle(fontSize: 16),
                          //               ),
                          //               Text(
                          //                 "${snapshot.data["maxPeople"]}",
                          //                 style: const TextStyle(
                          //                     fontSize: 16,
                          //                     fontFamily: "PretendardSemiBold"),
                          //               )
                          //             ],
                          //           ),
                          //           const Text(""),
                          //           const Text(
                          //             "위 내용을 숙지하시고 채팅방에 입장해",
                          //             style: TextStyle(fontSize: 16),
                          //           ),
                          //           const Text("주시기를 바랍니다.",
                          //               style: TextStyle(fontSize: 16)),
                          //           const Text(""),
                          //           const Text("함께 주문하기에 참여하시겠습니까?",
                          //               style: TextStyle(fontSize: 16)),
                          //           const SizedBox(
                          //             height: 15,
                          //           ),
                          //           Row(
                          //             children: [
                          //               Expanded(
                          //                   child: GestureDetector(
                          //                 onTap: () {
                          //                   Navigator.pop(context);
                          //                 },
                          //                 child: Container(
                          //                     decoration: BoxDecoration(
                          //                         color:
                          //                             const Color(0xffE6E6E6),
                          //                         border: Border.all(
                          //                             color: Color(0xffD6D6D6)),
                          //                         borderRadius:
                          //                             BorderRadius.circular(5)),
                          //                     child: const Padding(
                          //                       padding: EdgeInsets.all(10.0),
                          //                       child: Center(
                          //                           child: Text(
                          //                         "아니요",
                          //                         style: TextStyle(
                          //                             fontSize: 14,
                          //                             fontFamily:
                          //                                 "PretendardSemiBold"),
                          //                       )),
                          //                     )),
                          //               )),
                          //               const SizedBox(
                          //                 width: 10,
                          //               ),
                          //               Expanded(
                          //                   child: GestureDetector(
                          //                 onTap: () {
                          //                   String uid = FirebaseAuth
                          //                       .instance.currentUser!.uid;
                          //                   String entry =
                          //                       "${uid}_${widget.userName}";
                          //                   setState(() {
                          //                     widget.firstVisit = true;
                          //                   });
                          //                   DatabaseService()
                          //                       .enterChattingRoom(
                          //                           snapshot.data["groupId"],
                          //                           widget.userName,
                          //                           snapshot.data["groupName"])
                          //                       .whenComplete(() {
                          //                     snapshot.data["members"]
                          //                         .add(entry);
                          //                     Map<String, dynamic>
                          //                         chatMessageMap = {
                          //                       "message":
                          //                           "${widget.userName} 님이 입장하셨습니다",
                          //                       "sender": widget.userName,
                          //                       "time":
                          //                           DateTime.now().toString(),
                          //                       "isEnter": 1
                          //                     };
                          //
                          //                     DatabaseService().sendMessage(
                          //                         snapshot.data["groupId"],
                          //                         chatMessageMap);
                          //                   });
                          //                 },
                          //                 child: Container(
                          //                     decoration: BoxDecoration(
                          //                         color:
                          //                             const Color(0xffFC9729),
                          //                         borderRadius:
                          //                             BorderRadius.circular(5)),
                          //                     child: const Padding(
                          //                       padding: EdgeInsets.all(10.0),
                          //                       child: Center(
                          //                           child: Text(
                          //                         "네",
                          //                         style: TextStyle(
                          //                             fontSize: 14,
                          //                             fontFamily:
                          //                                 "PretendardSemiBold",
                          //                             color: Colors.white),
                          //                       )),
                          //                     )),
                          //               )),
                          //             ],
                          //           )
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          ,
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
                          admin.contains(uid ?? "")
                              ? Column(
                                  children: [
                                    TogetherOrder(
                                      link: snapshot.data["togetherOrder"],
                                    ),
                                    DeliveryTip(
                                      groupId: snapshot.data["groupId"],
                                    )
                                  ],
                                )
                              : Container(),
                          // widget.firstVisit == false
                          //     ? Opacity(
                          //         opacity: 0.7,
                          //         child: Container(
                          //           alignment: Alignment.bottomCenter,
                          //           child: Padding(
                          //             padding: const EdgeInsets.symmetric(
                          //                 horizontal: 20, vertical: 40),
                          //             child: Container(
                          //               decoration: BoxDecoration(
                          //                 borderRadius:
                          //                     BorderRadius.circular(30),
                          //                 color: const Color(0xffAFAFAF),
                          //               ),
                          //               child: Padding(
                          //                 padding: const EdgeInsets.fromLTRB(
                          //                     24, 3, 8, 3),
                          //                 child: IgnorePointer(
                          //                   child: TextFormField(
                          //                     onTap: null,
                          //                     decoration: const InputDecoration(
                          //                       border: InputBorder.none,
                          //                     ),
                          //                   ),
                          //                 ),
                          //               ),
                          //             ),
                          //           ),
                          //         ),
                          //       )
                          //     : Container(),
                          // GestureDetector(
                          //   onTap: widget.firstVisit == false
                          //       ? () {
                          //           _url = Uri.parse(snapshot.data["restUrl"]);
                          //           _launchUrl();
                          //         }
                          //       : snapshot.data["togetherOrder"] != ""
                          //           ? () async {
                          //               _url = Uri.parse(
                          //                   snapshot.data["togetherOrder"]);
                          //               _launchUrl();
                          //             }
                          //           : null,
                          //   child: Padding(
                          //     padding: const EdgeInsets.fromLTRB(25, 23, 25, 0),
                          //     child: Material(
                          //       borderRadius: BorderRadius.circular(5),
                          //       elevation: 3,
                          //       child: Container(
                          //         height: 88,
                          //         decoration: BoxDecoration(
                          //             border:
                          //                 Border.all(color: Color(0xffD7D7D7)),
                          //             borderRadius: BorderRadius.circular(5)),
                          //         child: Padding(
                          //           padding: const EdgeInsets.fromLTRB(
                          //               24.0, 21, 20, 20),
                          //           child: Row(
                          //             children: [
                          //               Expanded(
                          //                 child: widget.firstVisit == false
                          //                     ? Column(
                          //                         crossAxisAlignment:
                          //                             CrossAxisAlignment.start,
                          //                         children: [
                          //                           Row(
                          //                             children: [
                          //                               Text(
                          //                                   snapshot.data[
                          //                                       'groupName'],
                          //                                   style: const TextStyle(
                          //                                       fontFamily:
                          //                                           "PretendardSemiBold",
                          //                                       fontSize: 18,
                          //                                       color: Colors
                          //                                           .orange)),
                          //                               const Text(
                          //                                 " 바로가기",
                          //                                 style: TextStyle(
                          //                                     fontSize: 18,
                          //                                     fontFamily:
                          //                                         "PretendardMedium"),
                          //                               )
                          //                             ],
                          //                           ),
                          //                           const Text(
                          //                             "먹고싶은 메뉴를 확인하고 채팅방에 입장하세요!",
                          //                             style: TextStyle(
                          //                                 fontFamily:
                          //                                     "PretendardMedium",
                          //                                 fontSize: 12,
                          //                                 color:
                          //                                     Color(0xff7F7F7F)),
                          //                           )
                          //                         ],
                          //                       )
                          //                     : snapshot.data["togetherOrder"] !=
                          //                             ""
                          //                         ? Column(
                          //                             crossAxisAlignment:
                          //                                 CrossAxisAlignment
                          //                                     .start,
                          //                             children: [
                          //                               Row(
                          //                                 children: [
                          //                                   Text(
                          //                                     snapshot.data[
                          //                                         'groupName'],
                          //                                     style: const TextStyle(
                          //                                         fontSize: 18,
                          //                                         fontFamily:
                          //                                             "PretendardMedium"),
                          //                                   ),
                          //                                   const Text(
                          //                                     " 함께 주문하기",
                          //                                     style: TextStyle(
                          //                                         fontFamily:
                          //                                             "PretendardSemiBold",
                          //                                         fontSize: 18,
                          //                                         color: Colors
                          //                                             .orange),
                          //                                   )
                          //                                 ],
                          //                               ),
                          //                               const Text(
                          //                                 "먹고싶은 메뉴를 확인하고 함께 주문하세요!",
                          //                                 style: TextStyle(
                          //                                     fontFamily:
                          //                                         "PretendardMedium",
                          //                                     fontSize: 12,
                          //                                     color: Color(
                          //                                         0xff7F7F7F)),
                          //                               )
                          //                             ],
                          //                           )
                          //                         : TextFormField(
                          //                             onFieldSubmitted: (value) {
                          //                               DatabaseService()
                          //                                   .saveTogetherOrder(
                          //                                       snapshot.data[
                          //                                           "groupId"],
                          //                                       value);
                          //                             },
                          //                             decoration:
                          //                                 const InputDecoration(
                          //                               isDense: true,
                          //                               border:
                          //                                   OutlineInputBorder(),
                          //                               contentPadding:
                          //                                   EdgeInsets.all(10),
                          //                             ),
                          //                           ),
                          //               ),
                          //               Image.asset(
                          //                 "./assets/icons/moveDash.png",
                          //                 scale: 2,
                          //               )
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
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
        "isEnter": 0
      };

      DatabaseService().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        messageController.clear();
      });

      // Add call to scrollToBottom here
      scrollToBottom();
    }
  }

  showNotice() {
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
                        "[총 배달팁]을 입력해주세요!",
                        style: TextStyle(
                            fontFamily: "PretendardSemiBold",
                            fontSize: 18,
                            color: Color(0xffFB813D)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Expanded(
                          child: Text(
                        "채팅방에 총 배달비를 입력해두면\n배달비를 자동으로 나누어 계산해줘요!",
                        style: TextStyle(fontSize: 16),
                      )),
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
                                                    "메뉴도 담아주세요!",
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
                                                  const Text(
                                                    "[함께 주문 바로가기]에서 메뉴를 담고\n빠른 주문을 진행하세요!",
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                  const SizedBox(
                                                    height: 45,
                                                  ),
                                                  const Expanded(
                                                      child: Text(
                                                    "총 배달팁도 꼭 확인해주세요 ><",
                                                    style: TextStyle(
                                                        fontSize: 16,
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
                                    "확인",
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
}
