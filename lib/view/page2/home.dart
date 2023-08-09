import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:han_bab/view/page2/chat_page.dart';
import 'package:han_bab/widget/fullRoom.dart';
import 'package:intl/intl.dart';
import '../../database/databaseService.dart';
import '../../model/restaurant.dart';
import '../../widget/bottom_navigation.dart';
import '../../widget/customToolbarShape.dart';
import 'add.dart';

DateTime now = DateTime.now();
DateFormat formatter = DateFormat('yyyy-MM-dd');
String strToday = formatter.format(now);

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

  @override
  void initState() {
    getUserName();
    super.initState();
  }

  getUserName() {
    DatabaseService().getUserName().then((value) => setState(() {
          userName = value;
        }));
  }

  List<Restaurant> filterRestaurants(List<Restaurant> restaurants) {
    return restaurants.where((restaurant) {
      return restaurant.groupName.contains(searchText) &&
          restaurant.date.startsWith(strToday);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    var currentTime = DateFormat("HH:mm").format(DateTime.now());
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
                      Image.asset("assets/Logo.png", scale: 2),
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
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 8.0, bottom: 16.0),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "지금 모집중인 방",
                      style: TextStyle(fontSize: 16),
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
                              return GestureDetector(
                                onTap: () {
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
                                      DatabaseService()
                                          .enterChattingRoom(restaurant.groupId,
                                              userName, restaurant.groupName)
                                          .whenComplete(() {
                                        restaurant.members.add(entry);
                                        Map<String, dynamic> chatMessageMap = {
                                          "message": "$userName 님이 입장하셨습니다",
                                          "sender": userName,
                                          "time": DateTime.now().toString(),
                                          "isEnter": 1
                                        };

                                        DatabaseService().sendMessage(
                                            restaurant.groupId, chatMessageMap);
                                      });
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
                                                    groupPlace:
                                                        restaurant.pickup,
                                                    groupCurrent: int.parse(
                                                        restaurant.currPeople),
                                                    groupAll: int.parse(
                                                        restaurant.maxPeople),
                                                    members: restaurant.members,
                                                  )));
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
                                                )));
                                  }
                                },
                                child: Column(
                                  children: [
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
                                                          Text(
                                                            '${restaurant.members.length}/${restaurant.maxPeople}',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey[500],
                                                                fontSize: 13),
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
                                    const Divider(),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddPage()));
          },
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: const BottomNavigation(),
      ),
    );
  }
}
