import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:han_bab/controller/map_provider.dart';
import 'package:han_bab/view/page2/add_room.dart';
import 'package:han_bab/view/page2/chat/chat_page.dart';
import 'package:han_bab/widget/fullRoom.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../controller/home_provider.dart';
import '../../database/databaseService.dart';
import '../../model/restaurant.dart';
import '../../widget/bottom_navigation.dart';
import '../../widget/customToolbarShape.dart';

DateTime now = DateTime.now();
DateFormat formatter = DateFormat('yyyy-MM-dd');
String strToday = formatter.format(now);
var currentTime = DateFormat("HH:mm").format(now);


String getName(String res) {
  return res.substring(res.indexOf("_") + 1);
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchText = "";
  String userName = "";
  late DocumentSnapshot myCurrentRest;
  bool circular = false;
  String nowRest = "";

  @override
  void initState() {
    print("Home Tab Initialize...");
    getData();
    super.initState();
  }

  getData() {
    DatabaseService().getUserName().then((value) {
      if (mounted) {
        setState(() {
          userName = value;
        });
      }
    });
    DatabaseService().getRest().then((value) {
      if (mounted) {
        setState(() {
          nowRest = value;
        });
      }
      if(nowRest != "") {
        DatabaseService().getCurrentRest().then((value) {
          if (mounted) {
            setState(() {
              circular = true;
              myCurrentRest = value;
            });
            print(DateTime.parse(myCurrentRest['date']));
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

  List<Restaurant> filterRestaurants(List<Restaurant> restaurants) {
    return restaurants.where((restaurant) {
      if (restaurant.members.isEmpty) {
        DatabaseService().deleteRestaurantDocument(restaurant.groupId);
      }
      return restaurant.members.isNotEmpty &&
          restaurant.groupName.contains(searchText) &&
          ((DateTime.parse(restaurant.date)
                  .isAtSameMomentAs(DateTime.parse(strToday))) ||
              (DateTime.parse(restaurant.date)
                  .isAfter(DateTime.parse(strToday))));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Container(
              color: Colors.transparent,
              child: Stack(fit: StackFit.loose, children: <Widget>[
                Container(
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: const CustomPaint(
                      painter: CustomToolbarShape(lineColor: Colors.orange),
                    )),
                Align(
                  alignment: const Alignment(0.0, 0.1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/logoWhite.png", scale: 2),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        "한동 밥먹자",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                Align(
                    alignment: const Alignment(0.0, 1.25),
                    child: Container(
                        height: MediaQuery.of(context).size.height / 14.5,
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        child: Container(
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 20.0,
                                  // shadow
                                  spreadRadius: .5,
                                  // set effect of extending the shadow
                                  offset: Offset(
                                    0.0,
                                    5.0,
                                  ),
                                )
                              ],
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(20, 20, 0, 20),
                                  filled: true,
                                  fillColor: Colors.white,
                                  suffixIcon: const Padding(
                                    padding: EdgeInsets.only(right: 20.0),
                                    child: Icon(
                                      Icons.search,
                                      color: Colors.orange,
                                      size: 30,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.white, width: 1),
                                      borderRadius: BorderRadius.circular(25)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.white, width: 1),
                                      borderRadius: BorderRadius.circular(25))),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              onSubmitted: (submittedText) {
                                setState(() {
                                  searchText = submittedText;
                                });
                              },
                            )))),
              ])),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
              child: Column(
            children: [
              // ElevatedButton(onPressed: (){
              //   FirebaseAuth.instance.signOut();
              // }, child: Text("dd")),
              const SizedBox(
                height: 15,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 8.0, bottom: 16.0),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "현재 참여중인 채팅방",
                      style: TextStyle(
                          fontSize: 14, fontFamily: "PretendardMedium"),
                    )),
              ),
              GestureDetector(
                onTap: nowRest != "" ? () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatPage(
                              groupId: myCurrentRest['groupId'],
                              groupName: myCurrentRest['groupName'],
                              userName: userName,
                              groupTime: myCurrentRest['orderTime'],
                              groupPlace: myCurrentRest['pickup'],
                              groupCurrent:
                                  int.parse(myCurrentRest['currPeople']),
                              groupAll: int.parse(myCurrentRest['maxPeople']),
                              members: myCurrentRest['members'],
                              firstVisit: true)));
                } : () {
                  Provider.of<MapProvider>(context, listen: false).clearAll();
                  Provider.of<HomeProvider>(context, listen: false).clearAll();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const AddRoomPage()));
                },
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
                      child: nowRest == "" ? Row(
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: Text("함께 주문 시작하기", style: TextStyle(fontSize: 18, fontFamily: "PretendardMedium"),)),
                                Text("먹고싶은 가게의 공동 구매를 시작하세요!", style: TextStyle(fontSize: 12, fontFamily: "PretendardMedium", color: Color(0xffFC9729)),)
                              ],
                            ),
                          ),
                          Image.asset("./assets/icons/addroom.png", scale: 2,)
                        ],
                      ) : circular
                          ? Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            myCurrentRest != null
                                                ? myCurrentRest['groupName'] ??
                                                    ""
                                                : "",
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontFamily: "PretendardMedium",
                                            ),
                                          ),
                                          const Text(" 주문대기중",
                                              style: TextStyle(
                                                  fontFamily:
                                                      "PretendardSemiBold",
                                                  fontSize: 18,
                                                  color: Colors.orange)),
                                        ],
                                      ),
                                      Text(
                                        "주문마감 : ${myCurrentRest != null ? myCurrentRest['orderTime']?.toString()?.substring(0, 2) ?? "" : ""}시 ${myCurrentRest != null ? myCurrentRest['orderTime']?.toString()?.substring(3, 5) ?? "" : ""}분",
                                        style: const TextStyle(
                                          fontFamily: "PretendardMedium",
                                          fontSize: 12,
                                          color: Color(0xff7F7F7F),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Image.asset(
                                  "./assets/icons/moveDash.png",
                                  scale: 2,
                                )
                              ],
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
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 8.0, bottom: 16.0),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "지금 모집중인 방",
                      style: TextStyle(
                          fontSize: 14, fontFamily: "PretendardMedium"),
                    )),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('groups')
                      .where('orderTime', isGreaterThanOrEqualTo: currentTime)
                      .orderBy("orderTime")
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final List<Restaurant> restaurants = filterRestaurants(
                        snapshot.data!.docs
                            .map((DocumentSnapshot doc) =>
                                Restaurant.fromSnapshot(doc))
                            .toList());
                    var yesterdayDate = "";
                    return restaurants.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.only(bottom: 40.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "아직 모집중인 방이 없습니다.",
                                  style: TextStyle(
                                      fontSize: 16, color: Color(0xff919191)),
                                ),
                                Text(
                                  "아래 + 버튼을 통해 새로 방을 만들 수 있습니다.",
                                  style: TextStyle(
                                      fontSize: 16, color: Color(0xff919191)),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: restaurants.length,
                            itemBuilder: (BuildContext context, int index) {
                              final Restaurant restaurant = restaurants[index];

                              var yesterday = false;
                              if (yesterdayDate != restaurant.date) {
                                yesterday = true;
                              }
                              yesterdayDate = restaurant.date;

                              return GestureDetector(
                                onTap: () async {
                                  String uid =
                                      FirebaseAuth.instance.currentUser!.uid;
                                  String entry = "${uid}_$userName";
                                  if (!restaurant.members.contains(entry)) {
                                    if (restaurant.members.length ==
                                        int.parse(restaurant.maxPeople)) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              const FullRoom());
                                    } else {
                                      await DatabaseService()
                                          .enterOnlyOneRest(
                                              context,
                                              restaurant.groupName,
                                              restaurant.groupId)
                                          .then((value) => {
                                                if (value)
                                                  {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    ChatPage(
                                                                      groupId:
                                                                          restaurant
                                                                              .groupId,
                                                                      groupName:
                                                                          restaurant
                                                                              .groupName,
                                                                      userName:
                                                                          userName,
                                                                      groupTime:
                                                                          restaurant
                                                                              .orderTime,
                                                                      groupPlace:
                                                                          restaurant
                                                                              .pickup,
                                                                      groupCurrent:
                                                                          int.parse(
                                                                              restaurant.currPeople),
                                                                      groupAll:
                                                                          int.parse(
                                                                              restaurant.maxPeople),
                                                                      members:
                                                                          restaurant
                                                                              .members,
                                                                      firstVisit:
                                                                          false,
                                                                    )))
                                                  }
                                              });
                                    }
                                  } else {
                                    // print("Entry already exists.");
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChatPage(
                                                  groupId: restaurant.groupId,
                                                  groupName:
                                                      restaurant.groupName,
                                                  userName: userName,
                                                  groupTime:
                                                      restaurant.orderTime,
                                                  groupPlace: restaurant.pickup,
                                                  groupCurrent: int.parse(
                                                      restaurant.currPeople),
                                                  groupAll: int.parse(
                                                      restaurant.maxPeople),
                                                  members: restaurant.members,
                                                  firstVisit: true,
                                                )));
                                  }
                                },
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        const SizedBox(
                                            width: 8, child: Divider()),
                                        const SizedBox(
                                          width: 2,
                                        ),
                                        yesterday
                                            ? Text(restaurant.date)
                                            : Container(),
                                        const SizedBox(
                                          width: 2,
                                        ),
                                        const Expanded(child: Divider()),
                                      ],
                                    ),
                                    Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0, top: 8.0),
                                          child: Container(
                                            color: Colors.transparent,
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 100,
                                                  height: 100,
                                                  child: Container(
                                                    decoration: restaurant
                                                            .imgUrl
                                                            .contains("hanbab")
                                                        ? BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .orange),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20))
                                                        : const BoxDecoration(),
                                                    child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.0),
                                                        child: Image.network(
                                                          restaurant.imgUrl,
                                                          loadingBuilder:
                                                              (BuildContext?
                                                                      context,
                                                                  Widget? child,
                                                                  ImageChunkEvent?
                                                                      loadingProgress) {
                                                            if (loadingProgress ==
                                                                null) {
                                                              return child!;
                                                            }
                                                            return Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                                value: loadingProgress
                                                                            .expectedTotalBytes !=
                                                                        null
                                                                    ? loadingProgress
                                                                            .cumulativeBytesLoaded /
                                                                        loadingProgress
                                                                            .expectedTotalBytes!
                                                                    : null,
                                                              ),
                                                            );
                                                          },
                                                          fit: BoxFit.cover,
                                                        )),
                                                  ),
                                                ), //image
                                                const SizedBox(
                                                  width: 18,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            restaurant
                                                                .groupName,
                                                            style: const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Text(
                                                            restaurant
                                                                .orderTime,
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .grey[500]),
                                                          )
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        getName(
                                                            restaurant.admin),
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            color: Colors
                                                                .grey[400]),
                                                      ),
                                                      const SizedBox(
                                                        height: 35,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            String.fromCharCode(
                                                                CupertinoIcons
                                                                    .person
                                                                    .codePoint),
                                                            style: TextStyle(
                                                              inherit: false,
                                                              color: Colors
                                                                  .grey[500],
                                                              fontSize: 16.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w100,
                                                              fontFamily:
                                                                  CupertinoIcons
                                                                      .person
                                                                      .fontFamily,
                                                              package:
                                                                  CupertinoIcons
                                                                      .person
                                                                      .fontPackage,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 3,
                                                          ),
                                                          restaurant.maxPeople ==
                                                                  "-1"
                                                              ? Text(
                                                                  "최대 인원 제한 없음",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                              .grey[
                                                                          500],
                                                                      fontSize:
                                                                          13),
                                                                )
                                                              : Text(
                                                                  '${restaurant.members.length}/${restaurant.maxPeople}',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                              .grey[
                                                                          500],
                                                                      fontSize:
                                                                          13),
                                                                ),
                                                          const SizedBox(
                                                            width: 20,
                                                          ),
                                                          Text(
                                                            String.fromCharCode(
                                                                CupertinoIcons
                                                                    .placemark
                                                                    .codePoint),
                                                            style: TextStyle(
                                                              inherit: false,
                                                              color: Colors
                                                                  .grey[500],
                                                              fontSize: 16.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w100,
                                                              fontFamily:
                                                                  CupertinoIcons
                                                                      .placemark
                                                                      .fontFamily,
                                                              package:
                                                                  CupertinoIcons
                                                                      .placemark
                                                                      .fontPackage,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                              restaurant.pickup,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                          .grey[
                                                                      500],
                                                                  fontSize: 13))
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Positioned.fill(
                                          child: Visibility(
                                            visible: restaurant
                                                    .members.length ==
                                                int.parse(restaurant.maxPeople),
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.black
                                                    .withOpacity(0.4),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                  },
                ),
              ),
            ],
          )),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     Provider.of<MapProvider>(context, listen: false).clearAll();
        //     Provider.of<HomeProvider>(context, listen: false).clearAll();
        //     Navigator.push(context,
        //         MaterialPageRoute(builder: (context) => const AddRoomPage()));
        //   },
        //   child: const Icon(Icons.add),
        // ),
        bottomNavigationBar: const BottomNavigation(),
      ),
    );
  }
}
