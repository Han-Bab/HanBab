import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:encrypt/encrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:han_bab/color_schemes.dart';
import 'package:han_bab/widget/alert.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../database/databaseService.dart';
import '../view/app.dart';
import '../view/page2/chat/chat_page.dart';
import '../view/page2/chat/report.dart';
import 'encryption.dart';

class EndDrawer extends StatelessWidget {
  EndDrawer(
      {required this.groupId,
      required this.groupName,
      required this.groupTime,
      required this.groupPlace,
      required this.admin,
      required this.groupAll,
      required this.members,
      required this.userName,
      required this.restUrl,
      required this.close,
      required this.scrollToBottom,
      required this.deliveryTip});

  final String groupId;
  final String groupName;
  final String groupTime;
  final String groupPlace;
  final int groupAll;
  final String admin;
  final String userName;
  final List<dynamic> members;
  final String restUrl;
  final double close;
  late Uri _url;
  final Function scrollToBottom;
  final int deliveryTip;

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

  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: lightColorScheme.primary,
              height: MediaQuery.of(context).size.height * 0.07,
            ),
            const SizedBox(
              height: 19,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 21.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            groupName,
                            style: const TextStyle(
                              fontFamily: "PretendardSemiBold",
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 41,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              "방 정보",
                              style: TextStyle(
                                  fontFamily: "PretendardMedium", fontSize: 18),
                            ),
                          ),
                          admin.contains(uid)
                              ? GestureDetector(
                                  onTap: () {
                                    modifyInfo(context);
                                  },
                                  child: Image.asset(
                                    "./assets/icons/modify.png",
                                    scale: 1.8,
                                  ))
                              : Container()
                        ],
                      ),
                    ),
                    const Divider(
                      height: 16,
                      color: Color(0xffC2C2C2),
                      thickness: 0.5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 5.0, top: 7.0, right: 20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    "./assets/icons/time2.png",
                                    scale: 1.8,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text(
                                    "주문예정시간",
                                    style: TextStyle(
                                        fontFamily: "PretendardMedium",
                                        fontSize: 16,
                                        color: Color(0xff313131)),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 11,
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    "./assets/icons/money.png",
                                    scale: 1.8,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text(
                                    "전체배달팁",
                                    style: TextStyle(
                                        fontFamily: "PretendardMedium",
                                        fontSize: 16,
                                        color: Color(0xff313131)),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 11,
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    "./assets/icons/vector2.png",
                                    scale: 1.8,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text(
                                    "주문장소",
                                    style: TextStyle(
                                        fontFamily: "PretendardMedium",
                                        fontSize: 16,
                                        color: Color(0xff313131)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 19,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  groupTime,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: "PretendardMedium",
                                      color: lightColorScheme.primary),
                                ),
                                const SizedBox(
                                  height: 11,
                                ),
                                Text(
                                  deliveryTip ==
                                      -1
                                      ? "? 원"
                                      : "${NumberFormat('#,###').format(deliveryTip / members.length)}원",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "PretendardMedium",
                                      color: lightColorScheme.primary),
                                ),
                                const SizedBox(
                                  height: 11,
                                ),
                                Text(
                                  groupPlace,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "PretendardMedium",
                                    color: lightColorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 50.0, right: 20.0),
                      child: Text(
                        "구성원",
                        style: TextStyle(
                            fontFamily: "PretendardMedium", fontSize: 18),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Divider(
                      height: 0,
                      color: Color(0xffC2C2C2),
                      thickness: 0.5,
                    ),
                    memberList(context),
                    const SizedBox(
                      height: 8,
                    ),
                    const Divider(
                      height: 0,
                      color: Color(0xffC2C2C2),
                      thickness: 0.5,
                    ),
                    admin.contains(uid) ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: TextButton(
                            onPressed: close == -1
                                ? () {
                                    Navigator.pop(context);
                                    WidgetsBinding.instance!
                                        .addPostFrameCallback((_) {
                                      DatabaseService().closeRoom(groupId, 1).then(
                                          (value) => {
                                                closeRoomNotice(context, groupId,
                                                    userName, uid, scrollToBottom)
                                              });
                                    });
                                  }
                                : null,
                            child: Text(
                              "주문 마감하기",
                              style: TextStyle(
                                  color: close == -1
                                      ? Colors.black
                                      : const Color(0xffC2C2C2),
                                  fontSize: 18),
                            ),
                          ),
                        ),
                        const Divider(
                          height: 0,
                          color: Color(0xffC2C2C2),
                          thickness: 0.5,
                        ),
                      ],
                    ) : Container(),
                  ],
                ),
              ),
            ),
            Container(
              color: const Color(0xffF6F6F6),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 3, 0, 10),
                child: TextButton(
                    onPressed: close == -1 || close == -2
                        ? () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertModal(
                                    text: "방에서 나가시겠습니까?",
                                    yesOrNo: true,
                                    function: () {
                                      DatabaseService()
                                          .exitGroup(groupId, getName(userName),
                                              groupName, admin)
                                          .whenComplete(() {
                                        Map<String, dynamic> chatMessageMap = {
                                          "message": "$userName 님이 퇴장하셨습니다",
                                          "sender": userName,
                                          "time": DateTime.now().toString(),
                                          "isEnter": 1,
                                          "senderId": uid,
                                          "orderMessage": 0
                                        };

                                        DatabaseService().sendMessage(
                                            groupId, chatMessageMap);

                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const App()));
                                      });
                                    },
                                  );
                                });
                          }
                        : null,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Image.asset(
                          "./assets/icons/exit.png",
                          scale: 2,
                          color: close == -1 || close == -2
                              ? const Color(0xff1C1B1F)
                              : const Color(0xffC2C2C2),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text("방 나가기",
                            style: TextStyle(
                                fontFamily: "PretendardMedium",
                                color: close == -1 || close == -2
                                    ? const Color(0xff1C1B1F)
                                    : const Color(0xffC2C2C2),
                                fontSize: 16))
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  memberList(context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
      child: ListView.builder(
        padding: const EdgeInsets.only(
          top: 20,
          left: 8,
        ),
        itemCount: members.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0, right: 26),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Image.asset(
                        "./assets/icons/person.png",
                        scale: 2,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(getName(members[index]),
                          style: const TextStyle(
                              fontFamily: "PretendardMedium",
                              fontSize: 16,
                              color: Color(0xff313131))),
                      const SizedBox(
                        width: 10,
                      ),
                      index == 0
                          ? Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: const Color(0xff3EBABE)),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 3),
                                  child: Text(
                                    "방장",
                                    style: TextStyle(
                                        fontFamily: "PretendardSemiBold",
                                        fontSize: 10,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      getId(members[index]) == uid
                          ? CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              radius: 10,
                              child: const Text(
                                "나",
                                style: TextStyle(
                                    fontFamily: "PretendardSemiBold",
                                    fontSize: 10,
                                    color: Colors.white),
                              ))
                          : Container(),
                    ],
                  ),
                ),
                getId(members[index]) != uid
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Report(
                                        name: getName(members[index]),
                                        targetId: getId(members[index]),
                                        userName: userName,
                                      )));
                        },
                        child: Image.asset(
                          "./assets/icons/menu_icons/report.png",
                          scale: 2,
                        ))
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
    TextEditingController groupPeopleController = TextEditingController(
        text: groupAll.toString() == "-1" ? "♾️" : groupAll.toString());

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
}
