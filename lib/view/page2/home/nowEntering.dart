import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controller/home_provider.dart';
import '../../../controller/map_provider.dart';
import '../../../database/databaseService.dart';
import '../add_room.dart';
import '../chat/chat_page.dart';
import 'home.dart';

class NowEntering extends StatefulWidget {
  const NowEntering({Key? key, required this.userName}) : super(key: key);

  final String userName;

  @override
  State<NowEntering> createState() => _NowEnteringState();
}

class _NowEnteringState extends State<NowEntering> {
  String nowRest = "";
  bool circular = false;
  late DocumentSnapshot myCurrentRest;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() {
    DatabaseService().getRest().then((value) {
      if (mounted) {
        setState(() {
          nowRest = value;
        });
      }
      if (nowRest != "") {
        DatabaseService().getCurrentRest().then((value) {
          if (mounted) {
            setState(() {
              circular = true;
              myCurrentRest = value;
            });

            if (DateTime.parse(myCurrentRest['date'])
                    .isBefore(DateTime.parse(strToday)) ||
                (DateTime.parse(myCurrentRest['date'])
                        .isAtSameMomentAs(DateTime.parse(strToday)) &&
                    DateTime.parse("$strToday " + myCurrentRest['orderTime'])
                        .isBefore(DateTime.parse("$strToday $currentTime")))) {
              setState(() {
                nowRest = "";
              });
              DatabaseService().resetRest();
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: nowRest != ""
            ? () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatPage(
                            groupId: myCurrentRest['groupId'],
                            groupName: myCurrentRest['groupName'],
                            userName: widget.userName,
                            groupTime: myCurrentRest['orderTime'],
                            groupPlace: myCurrentRest['pickup'],
                            groupCurrent:
                                int.parse(myCurrentRest['currPeople']),
                            groupAll: int.parse(myCurrentRest['maxPeople']),
                            members: myCurrentRest['members'], link: myCurrentRest['togetherOrder'],
                            // firstVisit: true
                        )));
              }
            : () {
                Provider.of<MapProvider>(context, listen: false).clearAll();
                Provider.of<HomeProvider>(context, listen: false).clearAll();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddRoomPage()));
              },
        child: Material(
          borderRadius: BorderRadius.circular(10),
          elevation: 3,
          child: Container(
            height: 88,
            decoration: BoxDecoration(
                border: Border.all(color: const Color(0xffD7D7D7)),
                borderRadius: BorderRadius.circular(10)),
            child: nowRest == ""
                ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                      children: [
                        const Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "함께 주문 시작하기",
                                style: TextStyle(
                                  color: Color(0xffFB813D),
                                    fontSize: 18,
                                    fontFamily: "PretendardSemiBold"),
                              ),
                              Text(
                                "먹고싶은 가게의 공동 구매를 시작하세요!",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: "PretendardMedium",
                                    color: Color(0xff313131)),
                              )
                            ],
                          ),
                        ),
                        Image.asset(
                          "./assets/icons/addroom.png",
                          scale: 2,
                        )
                      ],
                    ),
                )
                : circular
                    ? Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 25.0),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: myCurrentRest['imgUrl'] == ""
                                  ? BoxDecoration(
                                  border: Border.all(color: Colors.orange),
                                  borderRadius: BorderRadius.circular(6))
                                  : const BoxDecoration(),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6.0),
                                  child: Image.network(
                                    myCurrentRest['imgUrl'] == ""
                                        ? "https://firebasestorage.googleapis.com/v0/b/han-bab.appspot.com/o/hanbab_icon.png?alt=media&token=a5cf00de-d53f-4e57-8440-ef7a5f6c6e1c"
                                        : myCurrentRest['imgUrl'],
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
                            const SizedBox(width: 15,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    myCurrentRest != null
                                        ? myCurrentRest['groupName'] ?? ""
                                        : "",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontFamily: "PretendardMedium",
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(
                                    height: 1,
                                  ),
                                  const Text("주문대기중",
                                      style: TextStyle(
                                          fontFamily: "PretendardSemiBold",
                                          fontSize: 14,
                                          color: Color(0xffFC9729))),
                                ],
                              ),
                            ),
                            Image.asset(
                              "./assets/icons/moveDash.png",
                              scale: 2,
                            )
                          ],
                        ),
                    )
                    : SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                          ],
                        )),
          ),
        ));
  }
}
