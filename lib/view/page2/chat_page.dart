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
    DatabaseService()
        .getGroupMembers(widget.groupId)
        .then((val) {
      setState(() {
        members = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: members,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['members'] != null) {
            if (snapshot.data['members'].length != 0) {
              return Scaffold(
                appBar: AppBar(
                  iconTheme: const IconThemeData(color: Colors.white),
                  centerTitle: true,
                  elevation: 0,
                  title: Text(
                    widget.groupName,
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
                      groupName: widget.groupName,
                      groupTime: widget.groupTime,
                      groupPlace: widget.groupPlace,
                      groupAll: widget.groupAll,
                      admin: admin,
                    members: snapshot.data['members']
                  ),
                ),
                body: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          border: Border(
                        bottom:
                            BorderSide(width: 1.0, color: Color(0xffE1E1E1)),
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
                                Text(widget.groupTime),
                              ],
                            ),
                            Row(
                              children: [
                                Text("장소: "),
                                Text(widget.groupPlace),
                              ],
                            ),
                            Row(
                              children: [
                                Text("인원: "),
                                Text(
                                    "${snapshot.data['members'].length}/${widget.groupAll}"),
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
                                  padding:
                                      const EdgeInsets.fromLTRB(24, 3, 8, 3),
                                  child: Row(children: [
                                    Expanded(
                                        child: TextFormField(
                                      controller: messageController,
                                      style:
                                          const TextStyle(color: Colors.black),
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
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(
                child: Text("NO MEMBERS"),
              );
            }
          } else {
            return const Center(
              child: Text("NO MEMBERS"),
            );
          }
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
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                      message: snapshot.data.docs[index]['message'],
                      sender: snapshot.data.docs[index]['sender'],
                      sentByMe: widget.userName ==
                          snapshot.data.docs[index]['sender'],
                    isEnter: snapshot.data.docs[index]['isEnter']
                  );
                },
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
        "time": DateTime.now().millisecondsSinceEpoch,
        "isEnter": 0
      };

      DatabaseService().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }
}
