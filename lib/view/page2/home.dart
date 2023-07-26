import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../model/restaurant.dart';
import '../../widget/bottom_navigation.dart';
import '../../widget/customToolbarShape.dart';
import 'add.dart';

// DateTime now = DateTime.now();
// String currHour = DateFormat("HH").format(now);
// String currMinute = DateFormat("mm").format(now);

String getName(String res) {
  return res.substring(res.indexOf("_") + 1);
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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
                              onSubmitted: (submittedText) {},
                            )))),
              ])),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
              child: Column(
            children: [
              SizedBox(
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
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final List<Restaurant> restaurants = snapshot.data!.docs
                        .map((DocumentSnapshot doc) =>
                            Restaurant.fromSnapshot(doc))
                        .toList();
                    return ListView.builder(
                      itemCount: restaurants.length,
                      itemBuilder: (BuildContext context, int index) {
                        final Restaurant restaurant = restaurants[index];
                        return Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 8.0, top: 8.0),
                              child: Container(
                                color: Colors.transparent,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: Container(
                                        decoration: restaurant.imgUrl
                                                .contains("hanbab_icon.png")
                                            ? BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.orange),
                                                borderRadius:
                                                    BorderRadius.circular(20))
                                            : BoxDecoration(),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            child: Image.network(
                                              restaurant.imgUrl,
                                              loadingBuilder:
                                                  (BuildContext? context,
                                                      Widget? child,
                                                      ImageChunkEvent?
                                                          loadingProgress) {
                                                if (loadingProgress == null)
                                                  return child!;
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
                                              errorBuilder:
                                                  (BuildContext? context,
                                                      Object? exception,
                                                      StackTrace? stackTrace) {
                                                return Container(
                                                  height: 120,
                                                  width: 120,
                                                  decoration: BoxDecoration(
                                                    border:
                                                        Border.all(width: 3),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                      child: Image.asset(
                                                        'assets/images/hanbab_icon.png',
                                                        scale: 5,
                                                      )),
                                                );
                                              },
                                            )),
                                      ),
                                    ), //image
                                    const SizedBox(
                                      width: 18,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                restaurant.groupName,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                restaurant.orderTime,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey[500]),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            getName(restaurant.admin),
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey[400]),
                                          ),
                                          const SizedBox(
                                            height: 35,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                String.fromCharCode(
                                                    CupertinoIcons
                                                        .person.codePoint),
                                                style: TextStyle(
                                                  inherit: false,
                                                  color: Colors.grey[500],
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w100,
                                                  fontFamily: CupertinoIcons
                                                      .person.fontFamily,
                                                  package: CupertinoIcons
                                                      .person.fontPackage,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 3,
                                              ),
                                              Text(
                                                '${restaurant.currPeople}/${restaurant.maxPeople}',
                                                style: TextStyle(
                                                    color: Colors.grey[500],
                                                    fontSize: 13),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Text(
                                                String.fromCharCode(
                                                    CupertinoIcons
                                                        .placemark.codePoint),
                                                style: TextStyle(
                                                  inherit: false,
                                                  color: Colors.grey[500],
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w100,
                                                  fontFamily: CupertinoIcons
                                                      .placemark.fontFamily,
                                                  package: CupertinoIcons
                                                      .placemark.fontPackage,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(restaurant.pickup,
                                                  style: TextStyle(
                                                      color: Colors.grey[500],
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
                            const Divider(),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),

              // Expanded(
              //   child: ListView(shrinkWrap: true, children: const [
              //     Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         SizedBox(
              //           height: 200,
              //         ),
              //         Text(
              //           "아직 모집중인 방이 없습니다.",
              //           style: TextStyle(fontSize: 17, color: Colors.grey),
              //         ),
              //         Text("아래 + 버튼을 통해 새로 방을 만들 수 있습니다.",
              //             style: TextStyle(fontSize: 17, color: Colors.grey)),
              //       ],
              //     ),
              //   ]),
              // )
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
