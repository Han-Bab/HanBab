import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../database/databaseService.dart';
import '../view/app.dart';
import '../view/page2/home.dart';

class EndDrawer extends StatelessWidget {
  const EndDrawer(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.groupTime,
      required this.groupPlace,
      required this.admin,
      required this.groupAll,
      required this.members,
      required this.userName})
      : super(key: key);

  final String groupId;
  final String groupName;
  final String groupTime;
  final String groupPlace;
  final int groupAll;
  final String admin;
  final String userName;
  final List<dynamic> members;

  String getName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return Padding(
      padding: const EdgeInsets.only(top: 100.0, bottom: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 24.0),
                  child: Row(
                    children: [
                      const Text(
                        "방 정보",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      IconButton(
                        padding: EdgeInsets.zero, // 패딩 설정
                        constraints: const BoxConstraints(),
                        onPressed: admin.contains(uid) ? () {
                          modifyInfo(context);
                        } : null,
                        icon: const Icon(Icons.create),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 24.0, top: 20, bottom: 40),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text(
                            "가게명: ",
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(groupName, style: const TextStyle(fontSize: 20)),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          const Text("시간: ", style: TextStyle(fontSize: 20)),
                          Text(groupTime, style: const TextStyle(fontSize: 20)),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          const Text("픽업장소: ", style: TextStyle(fontSize: 20)),
                          Text(groupPlace,
                              style: const TextStyle(fontSize: 20)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 24.0),
                  child: Text(
                    "대화 상대",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(),
                memberList(),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: TextButton(
                    onPressed: () {
                      calculateMoney(context);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "./assets/icons/coin.png",
                          scale: 1.8,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          "정산하기",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0))),
                        title: const Text("방 나가기"),
                        content: const Text("이 방에서 나가시겠습니까? "),
                        actions: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              DatabaseService()
                                  .toggleGroupJoin(
                                      groupId, getName(userName), groupName, admin)
                                  .whenComplete(() {
                                Map<String, dynamic> chatMessageMap = {
                                  "message": "$userName 님이 퇴장하셨습니다",
                                  "sender": userName,
                                  "time": DateTime.now().toString(),
                                  "isEnter": 1
                                };

                                DatabaseService()
                                    .sendMessage(groupId, chatMessageMap);

                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const App()));
                              });
                            },
                            icon: const Icon(
                              Icons.done,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      );
                    });
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "./assets/icons/exit.png",
                      scale: 1.8,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text("방나가기",
                        style:
                            TextStyle(color: Color(0xff3E3E3E), fontSize: 16))
                  ],
                ),
              )),
        ],
      ),
    );
  }

  memberList() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: members.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return ListTile(
            title: Row(
              children: [
                Image.asset(
                  "./assets/icons/person.png",
                  scale: 2,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(getName(members[index]),
                    style: const TextStyle(fontSize: 20)),
                const SizedBox(
                  width: 10,
                ),
                index == 0
                    ? Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Theme.of(context).primaryColor),
                        child: const Padding(
                          padding: EdgeInsets.only(
                              top: 5.0, bottom: 5.0, left: 7.0, right: 7.0),
                          child: Text(
                            "방장",
                            style: TextStyle(fontSize: 13, color: Colors.white),
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
          );
        },
      ),
    );
  }

  void modifyInfo(BuildContext context) {
    TextEditingController groupNameController =
        TextEditingController(text: groupName);
    TextEditingController groupTimeController =
        TextEditingController(text: groupTime);
    TextEditingController groupPlaceController =
        TextEditingController(text: groupPlace);
    TextEditingController groupPeopleController =
        TextEditingController(text: groupAll.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 26),
              child: Column(
                children: [
                  const Text(
                    "수정하기",
                    style: TextStyle(fontSize: 24, color: Color(0xff3E3E3E)),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextField(
                          controller: groupNameController,
                          decoration: const InputDecoration(labelText: "가게명"),
                        ),
                        TextField(
                          controller: groupTimeController,
                          decoration:
                              const InputDecoration(labelText: "주문 예정 시간", hintText: "00:00"),
                        ),
                        TextField(
                          controller: groupPlaceController,
                          decoration: const InputDecoration(labelText: "수령 장소"),
                        ),
                        TextField(
                          controller: groupPeopleController,
                          decoration: const InputDecoration(labelText: "최대 인원"),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "취소",
                            style: TextStyle(
                                fontSize: 20, color: Color(0xffED6160)),
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                      TextButton(
                          onPressed: () {
                            DatabaseService().modifyGroupInfo(
                                groupId,
                                groupNameController.text,
                                groupTimeController.text,
                                groupPlaceController.text,
                                groupPeopleController.text);
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "수정",
                            style: TextStyle(
                                fontSize: 20, color: Color(0xff75B165)),
                          ))
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void calculateMoney(BuildContext context) {
    String name = getName(admin);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            contentPadding: const EdgeInsets.only(top: 20.0),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.height * 0.3,
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 20.0, right: 20),
                child: Column(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "계좌번호: ",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Column(
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  backgroundColor: const Color(0xffFFEB03),
                                  foregroundColor: const Color(0xff3E3E3E)),
                              child: const Text(
                                "카카오페이 송금",
                                style: TextStyle(fontSize: 18),
                              ),
                            )),
                        SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  backgroundColor: const Color(0xff3268E8),
                                  foregroundColor: const Color(0xffFBFBFB)),
                              child: const Text(
                                "토스 송금",
                                style: TextStyle(fontSize: 18),
                              ),
                            )),
                        SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  backgroundColor: const Color(0xff9E9E9E),
                                  foregroundColor: const Color(0xffFBFBFB)),
                              child: const Text(
                                "계좌번호 복사",
                                style: TextStyle(fontSize: 18),
                              ),
                            ))
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
