import 'package:flutter/material.dart';
import '../database/databaseService.dart';
import '../view/page2/home.dart';


class EndDrawer extends StatefulWidget {
  const EndDrawer(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.groupTime,
      required this.groupPlace,
      required this.admin,
      required this.groupAll})
      : super(key: key);

  final String groupId;
  final String groupName;
  final String groupTime;
  final String groupPlace;
  final int groupAll;
  final String admin;

  @override
  State<EndDrawer> createState() => _EndDrawerState();
}

class _EndDrawerState extends State<EndDrawer> {
  Stream? members;

  @override
  void initState() {
    getMembers();
    super.initState();
  }

  getMembers() async {
    DatabaseService()
        .getGroupMembers(widget.groupId)
        .then((val) {
      setState(() {
        members = val;
      });
    });
  }

  String getName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  @override
  Widget build(BuildContext context) {
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
                        onPressed: () {
                          modifyInfo();
                        },
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
                          Text(widget.groupName,
                              style: const TextStyle(fontSize: 20)),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          const Text("시간: ", style: TextStyle(fontSize: 20)),
                          Text(widget.groupTime,
                              style: const TextStyle(fontSize: 20)),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          const Text("픽업장소: ", style: TextStyle(fontSize: 20)),
                          Text(widget.groupPlace,
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
                      calculateMoney();
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
                                  .toggleGroupJoin(widget.groupId,
                                      getName(widget.admin), widget.groupName)
                                  .whenComplete(() {
                                Navigator.pushReplacement(
                                    context, MaterialPageRoute(builder: (context) => const HomePage()));
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
    return StreamBuilder(
      stream: members,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['members'] != null) {
            if (snapshot.data['members'].length != 0) {
              return Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: snapshot.data['members'].length,
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
                          Text(getName(snapshot.data['members'][index]),
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
                                        top: 5.0,
                                        bottom: 5.0,
                                        left: 7.0,
                                        right: 7.0),
                                    child: Text(
                                      "방장",
                                      style: TextStyle(
                                          fontSize: 13, color: Colors.white),
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

  void modifyInfo() {
    TextEditingController groupNameController =
        TextEditingController(text: widget.groupName);
    TextEditingController groupTimeController =
        TextEditingController(text: widget.groupTime);
    TextEditingController groupPlaceController =
        TextEditingController(text: widget.groupPlace);
    TextEditingController groupPeopleController =
        TextEditingController(text: widget.groupAll.toString());

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0))),
            contentPadding: const EdgeInsets.only(top: 30.0),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.5,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 20),
                child: Column(
                  children: [
                    const Text(
                      "수정하기",
                      style: TextStyle(fontSize: 24),
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
                                const InputDecoration(labelText: "주문 예정 시간"),
                          ),
                          TextField(
                            controller: groupPlaceController,
                            decoration:
                                const InputDecoration(labelText: "수령 장소"),
                          ),
                          TextField(
                            controller: groupPeopleController,
                            decoration:
                                const InputDecoration(labelText: "최대 인원"),
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
                            onPressed: () {},
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
        });
  }

  void calculateMoney() {
    String name = getName(widget.admin);
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
