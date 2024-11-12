import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:han_bab/color_schemes.dart';
import 'package:han_bab/widget/alert.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:provider/provider.dart';
import '../controller/home_provider.dart';
import '../controller/map_provider.dart';
import '../database/databaseService.dart';
import '../view/app.dart';
import '../view/page2/add_room.dart';
import '../view/page2/chat/chat_page.dart';
import '../view/page2/chat/report.dart';

class EndDrawer extends StatelessWidget {
  EndDrawer(
      {super.key,
      required this.groupId,
      required this.groupName,
      required this.groupDate,
      required this.groupTime,
      required this.groupPlace,
      required this.admin,
      required this.groupAll,
      required this.members,
      required this.userName,
      required this.restUrl,
      required this.close,
      required this.deliveryTip});

  final String groupId;
  final String groupName;
  final String groupDate;
  final String groupTime;
  final String groupPlace;
  final int groupAll;
  final String admin;
  final String userName;
  final List<dynamic> members;
  final String restUrl;
  final double close;
  final int deliveryTip;

  String getName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  final uid = FirebaseAuth.instance.currentUser!.uid;
  bool isProcessing = false; // 중복 클릭 방지 변수 추가

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final mapProvider = Provider.of<MapProvider>(context);

    return SafeArea(
      bottom: false,
      child: Drawer(
        shape: const RoundedRectangleBorder(),
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: lightColorScheme.primary,
                height: MediaQuery.of(context).size.height * 0.02,
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
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: AutoSizeText(
                          groupName,
                          style: const TextStyle(
                            fontFamily: "PretendardSemiBold",
                            fontSize: 18,
                          ),
                        ),
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
                                    fontFamily: "PretendardMedium",
                                    fontSize: 18),
                              ),
                            ),
                            admin.contains(uid)
                                ? GestureDetector(
                                    onTap: close == -1
                                        ? () {
                                            modifyInfo(context, homeProvider,
                                                mapProvider);
                                          }
                                        : null,
                                    child: Icon(
                                      Symbols.border_color,
                                      size: 22,
                                      color: close != -1
                                          ? const Color(0xffC2C2C2)
                                          : const Color(0xff313131),
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
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Symbols.alarm,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "주문예정시간",
                                      style: TextStyle(
                                          fontFamily: "PretendardMedium",
                                          fontSize: 16,
                                          color: Color(0xff313131)),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 11,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Symbols.monetization_on,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "전체배달팁",
                                      style: TextStyle(
                                          fontFamily: "PretendardMedium",
                                          fontSize: 16,
                                          color: Color(0xff313131)),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 11,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Symbols.location_on,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
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
                                    deliveryTip == -1
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
                      admin.contains(uid)
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: TextButton(
                                    onPressed: close == -1
                                        ? () {
                                            Navigator.pop(context);
                                            WidgetsBinding.instance!
                                                .addPostFrameCallback((_) {
                                              DatabaseService()
                                                  .closeRoom(groupId, 1)
                                                  .then((value) => {
                                                        closeRoomNotice(
                                                          context,
                                                          groupId,
                                                          groupName,
                                                          userName,
                                                          uid,
                                                        )
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
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
                color: const Color(0xffF6F6F6),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 3, 0, 10),
                  child: TextButton(
                      onPressed: close == -1 || close == -2
                          ? () async {
                              // 버튼 클릭 작업 시작
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertModal(
                                      text: "방에서 나가시겠습니까?",
                                      yesOrNo: true,
                                      function: () async {
                                        if (isProcessing) return; // 중복 클릭 방지
                                        isProcessing = true;
                                        await DatabaseService()
                                            .exitGroup(
                                                groupId,
                                                getName(userName),
                                                groupName,
                                                admin)
                                            .whenComplete(() async {
                                          Map<String, dynamic> chatMessageMap =
                                              {
                                            "message": "$userName 님이 퇴장하셨습니다",
                                            "sender": userName,
                                            "time": DateTime.now().toString(),
                                            "isEnter": 1,
                                            "senderId": uid,
                                            "orderMessage": 0,
                                          };

                                          await DatabaseService().sendMessage(
                                              groupId,
                                              groupName,
                                              chatMessageMap);

                                          DatabaseService()
                                              .deleteGroup(groupId);

                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const App()));
                                        });
                                        isProcessing = false; // 작업 완료 후 다시 활성화
                                      },
                                    );
                                  });
                            }
                          : null,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            Icons.exit_to_app_rounded,
                            size: 25,
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
                      const Icon(Icons.account_circle),
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
                        child: const Icon(Symbols.emergency_home))
                    : Container()
              ],
            ),
          );
        },
      ),
    );
  }

  void modifyInfo(BuildContext context, HomeProvider homeProvider,
      MapProvider mapProvider) {
    mapProvider.restaurantName = groupName;
    homeProvider.setSelectedValue("$groupAll명");
    homeProvider.pickUpPlaceController.text = groupPlace;

    final DateTime date = DateTime.parse(groupDate);
    if (date.day == DateTime.now().day) {
      homeProvider.setSelectedDatesIndex(0);
    } else {
      homeProvider.setSelectedDatesIndex(1);
    }
    homeProvider.setSelectedHoursIndex(int.parse(groupTime.split(":")[0]));
    homeProvider.setSelectedMinutesIndex(int.parse(groupTime.split(":")[1]));

    homeProvider.groupId = groupId;

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const AddRoomPage(isModify: true)));
  }
}
