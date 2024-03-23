import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:han_bab/widget/alert.dart';
import 'package:han_bab/widget/floatingAnimation.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../database/databaseService.dart';
import '../../../model/restaurant.dart';
import '../chat/chat_page.dart';
import 'home.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key, required this.searchText, required this.userName})
      : super(key: key);

  final String searchText;
  final String userName;

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  late Timer _timer; // 타이머 변수 추가
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    // 초기화 시 타이머 시작
    _startTimer();
  }

  @override
  void dispose() {
    // 위젯이 dispose될 때 타이머 종료
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    // 1초 간격으로 현재 시간을 업데이트
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {}); // setState를 호출하여 UI를 업데이트
    });
  }

  List<Restaurant> filterRestaurants(List<Restaurant> restaurants) {
    // 날짜(date)를 우선순위로 정렬하고, 날짜가 같은 경우 주문 시간(orderTime)을 다음 우선순위로 정렬합니다.
    restaurants.sort((a, b) {
      // 먼저 날짜(date)를 비교하여 오름차순으로 정렬합니다.
      int dateComparison =
          DateTime.parse(a.date).compareTo(DateTime.parse(b.date));
      if (dateComparison != 0) {
        return dateComparison;
      } else {
        // 날짜(date)가 같은 경우에는 주문 시간(orderTime)을 비교하여 오름차순으로 정렬합니다.
        return a.orderTime.compareTo(b.orderTime);
      }
    });

    return restaurants.where((restaurant) {
      if (restaurant.members.isEmpty) {
        DatabaseService().deleteRestaurantDocument(restaurant.groupId);
      }

      // 현재 날짜와 주문 날짜가 같은 경우에 대해서만 시간을 비교하고,
      // 주문 날짜가 현재 날짜보다 이후인 경우에는 모든 시간을 고려하지 않습니다.
      // 현재 시간 이전인 경우에만 리스트에 포함시킵니다.
      if (DateTime.parse(restaurant.date)
          .isAtSameMomentAs(DateTime.parse(strToday))) {
        if (DateTime.now().isBefore(DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          DateFormat("HH:mm").parse(restaurant.orderTime).hour,
          DateFormat("HH:mm").parse(restaurant.orderTime).minute,
        ))) {
          return restaurant.members.isNotEmpty &&
              restaurant.groupName.contains(widget.searchText) && restaurant.close == -1;
        } else {
          return false;
        }
      } else if (DateTime.parse(restaurant.date)
          .isAfter(DateTime.parse(strToday))) {
        return restaurant.members.isNotEmpty &&
            restaurant.groupName.contains(widget.searchText) &&
            restaurant.close == -1;
      } else {
        return false;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('groups')
            .where('date', isGreaterThanOrEqualTo: strToday)
            .orderBy("date")
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final List<Restaurant> restaurants = filterRestaurants(snapshot
              .data!.docs
              .map((DocumentSnapshot doc) => Restaurant.fromSnapshot(doc))
              .toList());
          return restaurants.isEmpty
              ? noRoom()
              : ListView.builder(
                  itemCount: restaurants.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Restaurant restaurant = restaurants[index];

                    return GestureDetector(
                      onTap: () async {
                        String entry = "${uid}_${widget.userName}";

                        if (!restaurant.members.contains(entry)) {
                          if (restaurant.members.length ==
                              int.parse(restaurant.maxPeople)) {
                            // 이미 방이 다 찼다.
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertModal(
                                    text: "이미 방이 찼습니다.",
                                    yesOrNo: false,
                                    function: () {}));
                          } else {
                            // 방이 인원이 다 안찼다.
                            await DatabaseService()
                                .enterOnlyOneRest(context, restaurant.groupName,
                                    restaurant.groupId)
                                .then((value) => {
                                      if (value)
                                        {
                                          // 새로 방을 들어가는 경우
                                          showModalBottomSheet(
                                            constraints: BoxConstraints(
                                              maxHeight: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.5,
                                            ),
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(
                                                          20.0)),
                                            ),
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            context: context,
                                            builder: (BuildContext context) {
                                              return chatInfo(
                                                  restaurant, entry);
                                            },
                                          ),
                                        }
                                    });
                          }
                        } else {
                          // 이미 방에 들어가 있는 경우
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatPage(
                                        groupId: restaurant.groupId,
                                        groupName: restaurant.groupName,
                                        userName: widget.userName,
                                        groupTime: restaurant.orderTime,
                                        groupPlace: restaurant.pickup,
                                        groupCurrent:
                                            int.parse(restaurant.currPeople),
                                        groupAll:
                                            int.parse(restaurant.maxPeople),
                                        members: restaurant.members,
                                        link: restaurant.togetherOrder,
                                        // firstVisit: true,
                                      )));
                        }
                      },
                      child: yesRoom(restaurant),
                    );
                  },
                );
        },
      ),
    );
  }

  Widget noRoom() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "아직 모집중인 방이 없습니다.",
            style: TextStyle(fontSize: 16, color: Color(0xff919191)),
          ),
          Text(
            "'함께 주문 시작하기' 버튼으로 방을 만들 수 있습니다.",
            style: TextStyle(fontSize: 16, color: Color(0xff919191)),
          ),
        ],
      ),
    );
  }

  Widget yesRoom(restaurant) {
    Widget image() {
      return SizedBox(
        width: 100,
        height: 100,
        child: Container(
          decoration: restaurant.imgUrl == "" ||
                  restaurant.imgUrl ==
                      "https://firebasestorage.googleapis.com/v0/b/han-bab.appspot.com/o/hanbab_icon.png?alt=media&token=a5cf00de-d53f-4e57-8440-ef7a5f6c6e1c"
              ? BoxDecoration(
                  border: Border.all(color: Colors.orange),
                  borderRadius: BorderRadius.circular(10))
              : const BoxDecoration(),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                restaurant.imgUrl == ""
                    ? "https://firebasestorage.googleapis.com/v0/b/han-bab.appspot.com/o/hanbab_icon.png?alt=media&token=a5cf00de-d53f-4e57-8440-ef7a5f6c6e1c"
                    : restaurant.imgUrl,
                loadingBuilder: (BuildContext? context, Widget? child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child!;
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                fit: BoxFit.cover,
              )),
        ),
      );
    }

    String getTimeDifference(String orderTimeString, String date) {
      DateTime now = DateTime.now();
      DateTime orderTime = DateTime(
        now.year,
        now.month,
        now.day,
        DateFormat("HH:mm").parse(orderTimeString).hour,
        DateFormat("HH:mm").parse(orderTimeString).minute,
      );
      Duration difference = orderTime.difference(now);

      DateTime orderDate = DateTime.parse(date);
      if (orderDate.year != now.year ||
          orderDate.month != now.month ||
          orderDate.day != now.day) {
        return "내일";
      }

      if (difference.inMinutes <= 10) {
        return '${difference.inMinutes}분후 마감';
      } else {
        return "";
      }
    }

    String entry = "${uid}_${widget.userName}";
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Stack(
        children: [
          Container(
            color: Colors.transparent,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                image(), //image
                const SizedBox(
                  width: 18,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            restaurant.groupName,
                            style: const TextStyle(
                                fontSize: 16, fontFamily: "PretendardMedium"),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: [
                              restaurant.members.length ==
                                      int.parse(restaurant.maxPeople)
                                  ? Image.asset(
                                      "./assets/icons/fullHomePerson.png",
                                      scale: 1.5,
                                    )
                                  : Image.asset(
                                      "./assets/icons/homePerson.png",
                                      scale: 1.5,
                                    ),
                              const SizedBox(
                                width: 3,
                              ),
                              Text(
                                restaurant.maxPeople == "-1"
                                    ? "최대 인원 제한 없음"
                                    : '${restaurant.members.length}/${restaurant.maxPeople}',
                                style: TextStyle(
                                    fontFamily: "PretendardMedium",
                                    color: restaurant.members.length ==
                                            int.parse(restaurant.maxPeople)
                                        ? const Color(0xffFB3D3D)
                                        : const Color(0xff313131),
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        getName(restaurant.admin),
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xffC2C2C2)),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            "./assets/icons/time2.png",
                            scale: 2.3,
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Text(
                            restaurant.orderTime,
                            style: const TextStyle(
                                color: Color(0xff313131),
                                fontFamily: "PretendardMedium",
                                fontSize: 12),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            getTimeDifference(
                                restaurant.orderTime, restaurant.date),
                            style: const TextStyle(
                                fontSize: 12, color: Color(0xffFB813D)),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 1, top: 2),
                        child: Row(
                          children: [
                            Image.asset(
                              "./assets/icons/money.png",
                              scale: 2.3,
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Text(
                              restaurant.deliveryTip == -1
                                  ? "? 원"
                                  : "${NumberFormat('#,###').format(restaurant.deliveryTip / restaurant.members.length)}원",
                              style: const TextStyle(
                                  color: Color(0xff313131),
                                  fontFamily: "PretendardMedium",
                                  fontSize: 12),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Text(
                              "(${NumberFormat('#,###').format(restaurant.deliveryTip)}원)",
                              style: const TextStyle(
                                  color: Color(0xffC2C2C2), fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 1, top: 2),
                        child: Row(
                          children: [
                            Image.asset(
                              "./assets/icons/vector2.png",
                              scale: 2.3,
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Text(
                              restaurant.pickup,
                              style: const TextStyle(
                                  color: Color(0xff313131),
                                  fontFamily: "PretendardMedium",
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (restaurant.members.contains(entry))
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white.withOpacity(0.8),
                ),
                child: const Center(
                    child: Text(
                  "현재 참여 중입니다.",
                  style: TextStyle(
                      fontFamily: "PretendardSemiBold",
                      color: Color(0xffFB813D),
                      fontSize: 16),
                )),
              ),
            ),
        ],
      ),
    );
  }

  Widget chatInfo(restaurant, entry) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                  child: Text(
                    '참여하실 함께주문 정보를 확인해주세요!',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                Divider(
                  color: Color(0xffC2C2C2),
                  thickness: 0.5,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 30, right: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.groupName.isNotEmpty
                          ? restaurant.groupName
                          : "가게 정보 없음",
                      style: TextStyle(
                        fontFamily: "PretendardSemiBold",
                        fontSize: 24,
                        color: Theme.of(context).primaryColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    restaurant.restUrl != ""
                        ? GestureDetector(
                            onTap: () {
                              void launchURL(String url) async {
                                Uri uri = Uri.parse(url);
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              }

                              launchURL(restaurant.restUrl);
                            },
                            child: Image.asset(
                              "./assets/images/kakaoMap.png",
                              scale: 1.7,
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
              restaurant.restUrl != ""
                  ? Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: FloatingAnimation(
                        child: Image.asset(
                          "./assets/images/kakaoMap2.png",
                          scale: 2,
                        ),
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.only(bottom: 25),
                    ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      CupertinoIcons.person_crop_circle,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "최대 인원",
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "PretendardMedium",
                          color: Color(0xff313131)),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      "${restaurant.maxPeople}명",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 14,
                          fontFamily: "PretendardMedium"),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.place_outlined,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "주문 장소",
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "PretendardMedium",
                          color: Color(0xff313131)),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      restaurant.pickup,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 14,
                          fontFamily: "PretendardMedium"),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.alarm_rounded,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "주문 시간",
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "PretendardMedium",
                          color: Color(0xff313131)),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      restaurant.orderTime,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 14,
                          fontFamily: "PretendardMedium"),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor:
                                  const Color.fromRGBO(230, 230, 230, 1),
                              foregroundColor: Colors.black,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("취소",
                                style: TextStyle(
                                    fontFamily: "PretendardMedium",
                                    fontSize: 16))),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () async {
                              DatabaseService()
                                  .enterChattingRoom(restaurant.groupId,
                                      widget.userName, restaurant.groupName)
                                  .whenComplete(() {
                                restaurant.members.add(entry);
                                Map<String, dynamic> chatMessageMap = {
                                  "message": "${widget.userName} 님이 입장하셨습니다",
                                  "sender": widget.userName,
                                  "time": DateTime.now().toString(),
                                  "isEnter": 1,
                                  "senderId": uid,
                                  "orderMessage": 0
                                };
                                DatabaseService().setReset(restaurant.date,
                                    restaurant.groupId, restaurant.groupName);
                                DatabaseService().sendMessage(
                                    restaurant.groupId, chatMessageMap);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatPage(
                                              groupId: restaurant.groupId,
                                              groupName: restaurant.groupName,
                                              userName: widget.userName,
                                              groupTime: restaurant.orderTime,
                                              groupPlace: restaurant.pickup,
                                              groupCurrent: int.parse(
                                                  restaurant.currPeople),
                                              groupAll: int.parse(
                                                  restaurant.maxPeople),
                                              members: restaurant.members,
                                              link: restaurant.togetherOrder,
                                              firstVisit: true,
                                            )));
                              });
                            },
                            child: const Text("참여하기",
                                style: TextStyle(
                                    fontFamily: "PretendardSemiBold",
                                    fontSize: 16))),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
