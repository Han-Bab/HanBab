import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:encrypt/encrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../database/databaseService.dart';
import '../view/app.dart';
import 'encryption.dart';

class EndDrawer extends StatelessWidget {
  EndDrawer(
      {
      required this.groupId,
      required this.groupName,
      required this.groupTime,
      required this.groupPlace,
      required this.admin,
      required this.groupAll,
      required this.members,
      required this.userName})
      ;

  final String groupId;
  final String groupName;
  final String groupTime;
  final String groupPlace;
  final int groupAll;
  final String admin;
  final String userName;
  final List<dynamic> members;
  late Uri _url;

  String getName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.1, bottom: MediaQuery.of(context).size.height*0.03),
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
                      FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          "방 정보",
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.height*0.03, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width*0.005,
                      ),
                      IconButton(
                        padding: EdgeInsets.zero, // 패딩 설정
                        constraints: const BoxConstraints(),
                        onPressed: admin.contains(uid)
                            ? () {
                                modifyInfo(context);
                              }
                            : null,
                        icon: const Icon(Icons.create),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Padding(
                  padding:
                      EdgeInsets.only(left: 24.0, top: MediaQuery.of(context).size.height*0.02, bottom: MediaQuery.of(context).size.height*0.02),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "가게명: ",
                            style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.02),
                          ),
                          Text(groupName, style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.02)),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text("시간: ", style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.02)),
                          Text(groupTime, style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.02)),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text("픽업장소: ", style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.02)),
                          Text(groupPlace,
                              style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.02)),
                        ],
                      ),
                    ],
                  ),
                ),
                 SizedBox(
                  height: MediaQuery.of(context).size.height*0.04,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 24.0),
                  child: Text(
                    "대화 상대",
                    style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.03, fontWeight: FontWeight.bold),
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
                        Container(
                          height: MediaQuery.of(context).size.height*0.025,
                          child: Image.asset(
                            "./assets/icons/coin.png",
                            fit: BoxFit.cover
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "정산하기",
                          style: TextStyle(color: Colors.black, fontSize: MediaQuery.of(context).size.height*0.02),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: TextButton(
                    onPressed: () {
                      DatabaseService().gotoBaemin(groupName).then(
                          (value) => {_url = Uri.parse(value), _launchUrl()});
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height*0.028,
                          child: Image.asset(
                            "./assets/icons/baemin.png",
                            fit: BoxFit.cover
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                         Text(
                          "배민 바로가기",
                          style:
                              TextStyle(color: Color(0xff39C0C0), fontSize: MediaQuery.of(context).size.height*0.02),
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
                                  .toggleGroupJoin(groupId, getName(userName),
                                      groupName, admin)
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
                    Container(
                      height: MediaQuery.of(context).size.height*0.025,
                      child: Image.asset(
                        "./assets/icons/exit.png",
                          fit: BoxFit.cover
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text("방나가기",
                        style:
                            TextStyle(color: Color(0xff3E3E3E), fontSize: MediaQuery.of(context).size.height*0.02))
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
                Container(
                  //width: MediaQuery.of(context).size.width*0.02,
                  height: MediaQuery.of(context).size.height*0.025,
                  child: Image.asset(
                    "./assets/icons/person.png",
                   fit: BoxFit.cover
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(getName(members[index]),
                    style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.02)),
                const SizedBox(
                  width: 10,
                ),
                index == 0
                    ? Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Theme.of(context).primaryColor),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 5.0, bottom: 5.0, left: 7.0, right: 7.0),
                          child: Text(
                            "방장",
                            style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.016, color: Colors.white),
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
                          enabled: false,
                          controller: groupNameController,
                          decoration: const InputDecoration(labelText: "가게명"),
                        ),
                        TextField(
                          controller: groupTimeController,
                          decoration: const InputDecoration(
                              labelText: "주문 예정 시간", hintText: "00:00"),
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
    DatabaseService().getUserInfo(getId(admin)).then((value) => {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: MediaQuery.of(context).size.height * 0.35,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 40, 20, 30),
                          child: Column(
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                    fontSize: 24, color: Color(0xff3E3E3E)),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              value["bankAccount"] != ""
                                  ? Text(
                                      "계좌번호: ${decrypt(aesKey, Encrypted.fromBase16(value['bankAccount']))}",
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xff3E3E3E)),
                                    )
                                  : Container(),
                              const SizedBox(
                                height: 15,
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: ElevatedButton(
                                        onPressed: value['kakaoLink']
                                            ? () {
                                                _url = Uri.parse(
                                                    value['kakaopay']);
                                                _launchUrl();
                                              }
                                            : null,
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(13.0),
                                            ),
                                            backgroundColor:
                                                const Color(0xffFFEB03),
                                            foregroundColor:
                                                const Color(0xff3E3E3E)),
                                        child: const Text(
                                          "카카오페이 송금",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Color(0xff3E3E3E)),
                                        ),
                                      )),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: ElevatedButton(
                                        onPressed: value['tossLink']
                                            ? () {
                                                _url = Uri.parse(
                                                    'https://toss.me/${value["tossId"]}');
                                                _launchUrl();
                                              }
                                            : null,
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(13.0),
                                            ),
                                            backgroundColor:
                                                const Color(0xff3268E8),
                                            foregroundColor:
                                                const Color(0xffFBFBFB)),
                                        child: const Text(
                                          "토스 송금",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Color(0xffFBFBFB)),
                                        ),
                                      )),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: ElevatedButton(
                                        onPressed: value["bankAccount"] == ""
                                            ? null
                                            : () {
                                                Clipboard.setData(ClipboardData(
                                                    text:
                                                        value["bankAccount"]));
                                                AnimatedSnackBar.material(
                                                  '계좌번호가 클립보드에 복사되었습니다.',
                                                  type: AnimatedSnackBarType
                                                      .success,
                                                  mobilePositionSettings:
                                                      const MobilePositionSettings(
                                                    // topOnAppearance: 70,
                                                    // topOnDissapear: 50,
                                                    bottomOnAppearance: 50,
                                                    // bottomOnDissapear: 50,
                                                    // left: 20,
                                                    // right: 70,
                                                  ),
                                                  mobileSnackBarPosition:
                                                      MobileSnackBarPosition
                                                          .bottom,
                                                  desktopSnackBarPosition:
                                                      DesktopSnackBarPosition
                                                          .bottomLeft,
                                                ).show(context);
                                              },
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(13.0),
                                            ),
                                            backgroundColor:
                                                const Color(0xff9E9E9E),
                                            foregroundColor:
                                                const Color(0xffFBFBFB)),
                                        child: const Text(
                                          "계좌번호 복사",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Color(0xffFBFBFB)),
                                        ),
                                      ))
                                ],
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Align(
                                alignment: Alignment.topRight,
                                child: Icon(
                                  Icons.clear,
                                  color: Color(0xff717171),
                                  size: 24,
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              })
        });
  }
}
