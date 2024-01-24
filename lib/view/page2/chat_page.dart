import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:han_bab/view/app.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../database/databaseService.dart';
import '../../widget/endDrawer.dart';
import '../../widget/message_tile.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String groupTime;
  final String groupPlace;
  final int groupCurrent;
  final int groupAll;
  final String userName;
  final List<dynamic> members;
  late bool firstVisit;

  ChatPage(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.userName,
      required this.groupTime,
      required this.groupPlace,
      required this.groupCurrent,
      required this.groupAll,
      required this.members,
      required this.firstVisit})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();
  String admin = "";
  FocusNode _focusNode = FocusNode();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    getChatandAdmin();
    getMembers();
    super.initState();
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

  late Uri _url;

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  // Add scrollToBottom method to scroll to the bottom of the chat
  void scrollToBottom() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
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
                iconTheme: const IconThemeData(color: Colors.white),
                centerTitle: true,
                elevation: 0,
                title: Text(
                  snapshot.data['groupName'],
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Theme.of(context).primaryColor,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const App()),
                        (route) => true);
                  },
                  icon: const Icon(Icons.arrow_back_ios_new),
                ),
              ),
              endDrawer: Drawer(
                child: EndDrawer(
                    groupId: widget.groupId,
                    groupName: snapshot.data['groupName'],
                    groupTime: snapshot.data['orderTime'],
                    groupPlace: snapshot.data['pickup'],
                    groupAll: int.parse(snapshot.data['maxPeople']),
                    admin: snapshot.data['admin'],
                    userName: widget.userName,
                    members: snapshot.data['members'], restUrl: snapshot.data['restUrl'],),
              ),
              body: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        border: Border(
                      bottom: BorderSide(width: 1.0, color: Color(0xffE1E1E1)),
                    )),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 13, 13, 13),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            "./assets/icons/info.png",
                            scale: 1.8,
                          ),
                          Row(
                            children: [
                              const Text("시간: "),
                              Text(snapshot.data['orderTime']),
                            ],
                          ),
                          Row(
                            children: [
                              Text("장소: "),
                              Text(snapshot.data['pickup']),
                            ],
                          ),
                          Row(
                            children: [
                              Text("인원: "),
                              snapshot.data['maxPeople'] == "-1"
                                  ? const Text("♾️")
                                  : Text(
                                      "${snapshot.data['members'].length}/${snapshot.data['maxPeople']}"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: <Widget>[
                        if (widget.firstVisit)
                          chatMessages()
                        else
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 135.0, left: 25),
                            child: Container(
                              width: 275,
                              decoration: const BoxDecoration(
                                  color: Color(0xffF1F1F1),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(16),
                                      bottomLeft: Radius.circular(16),
                                      bottomRight: Radius.circular(16))),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15.0, 10, 15, 20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Wrap(
                                      direction: Axis.horizontal,
                                      children: [
                                        Text(
                                          "안녕하세요, ${widget.userName}님은 ",
                                          style: const TextStyle(fontSize: 16),
                                          maxLines: null,
                                          softWrap: true,
                                        ),
                                        Text(
                                          widget.groupName,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.orange,
                                            fontFamily: "PretendardSemiBold",
                                          ),
                                        ),
                                        const Text(
                                          " 공구 채팅 단체방에 ",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        const Text(
                                          "입장하셨습",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        const Text(
                                          "니다.",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    const Text(""),
                                    Row(
                                      children: [
                                        const Text(
                                          "주문예정시간: ",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Text(
                                          "${snapshot.data["date"].toString().substring(5, 7)}월 ${snapshot.data["date"].toString().substring(8, 10)}일 ${snapshot.data["orderTime"].toString().substring(0, 2)}시 ${snapshot.data["orderTime"].toString().substring(3, 5)}분",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontFamily: "PretendardSemiBold"),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "수령장소: ",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Text(
                                          "${snapshot.data["pickup"]}",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontFamily: "PretendardSemiBold"),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "최대인원: ",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Text(
                                          "${snapshot.data["maxPeople"]}",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontFamily: "PretendardSemiBold"),
                                        )
                                      ],
                                    ),
                                    const Text(""),
                                    const Text(
                                      "위 내용을 숙지하시고 채팅방에 입장해",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    const Text("주시기를 바랍니다.",
                                        style: TextStyle(fontSize: 16)),
                                    const Text(""),
                                    const Text("함께 주문하기에 참여하시겠습니까?",
                                        style: TextStyle(fontSize: 16)),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xffE6E6E6),
                                                  border: Border.all(
                                                      color: Color(0xffD6D6D6)),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: const Padding(
                                                padding: EdgeInsets.all(10.0),
                                                child: Center(
                                                    child: Text(
                                                  "아니요",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily:
                                                          "PretendardSemiBold"),
                                                )),
                                              )),
                                        )),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                            child: GestureDetector(
                                          onTap: () {
                                            String uid = FirebaseAuth
                                                .instance.currentUser!.uid;
                                            String entry =
                                                "${uid}_${widget.userName}";
                                            setState(() {
                                              widget.firstVisit = true;
                                            });
                                            DatabaseService()
                                                .enterChattingRoom(
                                                    snapshot.data["groupId"],
                                                    widget.userName,
                                                    snapshot.data["groupName"])
                                                .whenComplete(() {
                                              snapshot.data["members"]
                                                  .add(entry);
                                              Map<String, dynamic>
                                                  chatMessageMap = {
                                                "message":
                                                    "${widget.userName} 님이 입장하셨습니다",
                                                "sender": widget.userName,
                                                "time":
                                                    DateTime.now().toString(),
                                                "isEnter": 1
                                              };

                                              DatabaseService().sendMessage(
                                                  snapshot.data["groupId"],
                                                  chatMessageMap);
                                            });
                                          },
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xffFC9729),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: const Padding(
                                                padding: EdgeInsets.all(10.0),
                                                child: Center(
                                                    child: Text(
                                                  "네",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily:
                                                          "PretendardSemiBold",
                                                      color: Colors.white),
                                                )),
                                              )),
                                        )),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        Container(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 40),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Color(0xFFffffff),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 10.0, // soften the shadow
                                  )
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(24, 3, 8, 3),
                                child: Row(children: [
                                  Expanded(
                                      child: TextFormField(
                                    controller: messageController,
                                    style: const TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      hintText: widget.firstVisit == false
                                          ? "메시지를 입력할 수 없는 상태입니다"
                                          : "메시지 입력하세요",
                                      hintStyle: const TextStyle(
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
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Center(
                                          child: Image.asset(
                                              "./assets/icons/message.png")),
                                    ),
                                  )
                                ]),
                              ),
                            ),
                          ),
                        ),
                        widget.firstVisit == false
                            ? Opacity(
                                opacity: 0.7,
                                child: Container(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 40),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: const Color(0xffAFAFAF),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            24, 3, 8, 3),
                                        child: IgnorePointer(
                                          child: TextFormField(
                                            onTap: null,
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        GestureDetector(
                          onTap: widget.firstVisit == false
                              ? () {
                                  _url =
                                      Uri.parse(snapshot.data["restUrl"]);
                                  _launchUrl();
                                }
                              : snapshot.data["togetherOrder"] != ""
                                  ? () async {
                                      _url = Uri.parse(
                                          snapshot.data["togetherOrder"]);
                                      _launchUrl();
                                    }
                                  : null,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(25, 23, 25, 0),
                            child: Material(
                              borderRadius: BorderRadius.circular(5),
                              elevation: 3,
                              child: Container(
                                height: 88,
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Color(0xffD7D7D7)),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      24.0, 21, 20, 20),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: widget.firstVisit == false
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                          snapshot.data[
                                                              'groupName'],
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  "PretendardSemiBold",
                                                              fontSize: 18,
                                                              color: Colors
                                                                  .orange)),
                                                      const Text(
                                                        " 바로가기",
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontFamily:
                                                                "PretendardMedium"),
                                                      )
                                                    ],
                                                  ),
                                                  const Text(
                                                    "먹고싶은 메뉴를 확인하고 채팅방에 입장하세요!",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "PretendardMedium",
                                                        fontSize: 12,
                                                        color:
                                                            Color(0xff7F7F7F)),
                                                  )
                                                ],
                                              )
                                            : snapshot.data["togetherOrder"] !=
                                                    ""
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            snapshot.data[
                                                                'groupName'],
                                                            style: const TextStyle(
                                                                fontSize: 18,
                                                                fontFamily:
                                                                    "PretendardMedium"),
                                                          ),
                                                          const Text(
                                                            " 함께 주문하기",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "PretendardSemiBold",
                                                                fontSize: 18,
                                                                color: Colors
                                                                    .orange),
                                                          )
                                                        ],
                                                      ),
                                                      const Text(
                                                        "먹고싶은 메뉴를 확인하고 함께 주문하세요!",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "PretendardMedium",
                                                            fontSize: 12,
                                                            color: Color(
                                                                0xff7F7F7F)),
                                                      )
                                                    ],
                                                  )
                                                : TextFormField(
                                                    onFieldSubmitted: (value) {
                                                      DatabaseService()
                                                          .saveTogetherOrder(
                                                              snapshot.data[
                                                                  "groupId"],
                                                              value);
                                                    },
                                                    decoration:
                                                        const InputDecoration(
                                                      isDense: true,
                                                      border:
                                                          OutlineInputBorder(),
                                                      contentPadding:
                                                          EdgeInsets.all(10),
                                                    ),
                                                  ),
                                      ),
                                      Image.asset(
                                        "./assets/icons/moveDash.png",
                                        scale: 2,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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

  chatMessages() {
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
                    return Container(height: 120.0); // Adjust height as needed
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
                    sentByMe: widget.userName ==
                        snapshot.data.docs[index - 1]['sender'],
                    isEnter: snapshot.data.docs[index - 1]['isEnter'],
                    time: snapshot.data.docs[index - 1]['time'],
                    duplicateNickName: duplicateNickName,
                    duplicateTime: duplicateTime,
                  );
                },
                // Add the scrollController here
                controller: _scrollController,
              )
            : Container();
      },
    );
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
}
