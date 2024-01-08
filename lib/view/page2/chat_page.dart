import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:han_bab/view/app.dart';
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

  const ChatPage(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.userName,
      required this.groupTime,
      required this.groupPlace,
      required this.groupCurrent,
      required this.groupAll,
      required this.members})
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
                    members: snapshot.data['members']),
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
                              Text(
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
                        chatMessages(),
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
                                    decoration: const InputDecoration(
                                      hintText: "메시지 입력하세요",
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
                        Padding(
                          padding: const EdgeInsets.fromLTRB(25, 27, 25, 0),
                          child: Material(
                            borderRadius: BorderRadius.circular(5),
                            elevation: 3,
                            child: Container(
                              height: 88,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xffD7D7D7)),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(24.0, 21, 20, 20),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                snapshot.data['groupName'],
                                                style: TextStyle(fontSize: 18),
                                              ),
                                              const Text(
                                                " 함께 주문하기",
                                                style: TextStyle(
                                                    fontSize: 18, color: Colors.orange),
                                              )
                                            ],
                                          ),
                                          const Text(
                                            "먹고싶은 메뉴를 확인하고 함께 주문하세요!",
                                            style: TextStyle(
                                                fontSize: 12, color: Color(0xff7F7F7F)),
                                          )
                                        ],
                                      ),
                                    ),
                                    Image.asset("./assets/icons/moveDash.png", scale: 2,)
                                  ],
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
