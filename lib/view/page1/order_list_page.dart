import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:han_bab/view/page2/chat/chat_page.dart';
import 'package:han_bab/view/page2/home/nowEntering.dart';
import 'package:han_bab/widget/appBar.dart';
import 'package:han_bab/widget/bottom_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../page2/home/home.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({Key? key}) : super(key: key);

  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final String _currentUserId;

  @override
  void initState() {
    super.initState();
    _currentUserId = _auth.currentUser!.uid;
  }

  String formatDate(String dateStr) {
    DateTime date = DateTime.parse(dateStr);
    String formattedDate = "${date.month}월 ${date.day}일";
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<DocumentSnapshot>(
        stream: _firebaseFirestore
            .collection('user')
            .doc(_currentUserId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            final userDoc = snapshot.data!;
            final userData = userDoc.data();
            final userMap = userData as Map<String, dynamic>;
            final String userName = userMap['name'];

            List<String> userGroups =
                List<String>.from(userMap['groups'].reversed);
            String extractSubstring(String text) {
              return text.split('_').sublist(1).join('_');
            }

            userGroups.remove(extractSubstring(userMap['currentGroup']));

            return Column(
              children: [
                appbar(context, "채팅"),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        userMap['currentGroup'] != ""
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 40),
                                child: NowEntering(userName: userName),
                              )
                            : Container(),
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(
                            "정산 완료된 채팅방",
                            style: TextStyle(
                                fontSize: 14, fontFamily: "PretendardMedium"),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        userGroups.isEmpty
                            ? const Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 50.0),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "아직 정산 완료된 방이 없습니다.",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Color(0xff919191)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: List.generate(userGroups.length,
                                        (index) {
                                      String groupId =
                                          userGroups[index].split('_')[0];
                                      return StreamBuilder<DocumentSnapshot>(
                                        stream: _firebaseFirestore
                                            .collection('groups')
                                            .doc(groupId)
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }
                                          if (!snapshot.hasData ||
                                              snapshot.data == null) {
                                            return Container();
                                          }

                                          final groupDoc = snapshot.data!;
                                          final groupData = groupDoc.data();
                                          if (!groupDoc.exists ||
                                              groupData == null) {
                                            return const ListTile(
                                              title:
                                                  Text('필요한 채팅방 정보가 누락되었습니다.'),
                                            );
                                          }

                                          final groupMap =
                                              groupData as Map<String, dynamic>;
                                          if (!groupMap
                                                  .containsKey('groupName') ||
                                              !groupMap
                                                  .containsKey('groupId') ||
                                              !groupMap.containsKey('date') ||
                                              !groupMap.containsKey('pickup') ||
                                              !groupMap
                                                  .containsKey('currPeople') ||
                                              !groupMap
                                                  .containsKey('maxPeople') ||
                                              !groupMap
                                                  .containsKey('members')) {
                                            return const ListTile(
                                              title:
                                                  Text('필요한 채팅방 정보가 누락되었습니다.'),
                                            );
                                          }

                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 30.0),
                                            child: GestureDetector(
                                              child: Container(
                                                color: Colors.transparent,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 100,
                                                      height: 100,
                                                      decoration: groupMap[
                                                                      'imgUrl'] !=
                                                                  "" &&
                                                              groupMap[
                                                                      'imgUrl'] !=
                                                                  "https://firebasestorage.googleapis.com/v0/b/han-bab.appspot.com/o/hanbab_icon.png?alt=media&token=a5cf00de-d53f-4e57-8440-ef7a5f6c6e1c"
                                                          ? const BoxDecoration()
                                                          : BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .orange),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                      child: groupMap['imgUrl'] !=
                                                                  null &&
                                                              groupMap['imgUrl']
                                                                  .isNotEmpty
                                                          ? ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              child: Opacity(
                                                                opacity: 0.5,
                                                                child: Image.network(
                                                                    groupMap[
                                                                        'imgUrl'],
                                                                    fit: BoxFit
                                                                        .cover),
                                                              ),
                                                            )
                                                          : ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              child: Opacity(
                                                                opacity: 0.5,
                                                                child: Image.asset(
                                                                    'assets/images/hanbab_icon.png',
                                                                    fit: BoxFit
                                                                        .cover),
                                                              ),
                                                            ),
                                                    ),
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
                                                              Flexible(
                                                                child: Text(
                                                                  groupMap[
                                                                      'groupName'],
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontFamily:
                                                                          "PretendardMedium"),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 12,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  groupMap['members']
                                                                              .length ==
                                                                          int.parse(
                                                                              groupMap['maxPeople'])
                                                                      ? const Icon(
                                                                          Symbols
                                                                              .person,
                                                                          color:
                                                                              Color(0xffFB3D3D),
                                                                          size:
                                                                              20,
                                                                        )
                                                                      : const Icon(
                                                                          Symbols
                                                                              .person,
                                                                          color:
                                                                              Color(0xff313131),
                                                                          size:
                                                                              20,
                                                                        ),
                                                                  const SizedBox(
                                                                    width: 3,
                                                                  ),
                                                                  Text(
                                                                    groupMap['maxPeople'] ==
                                                                            "-1"
                                                                        ? "최대 인원 제한 없음"
                                                                        : '${groupMap['members'].length}/${groupMap['maxPeople']}',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            "PretendardMedium",
                                                                        color: groupMap['members'].length == int.parse(groupMap['maxPeople'])
                                                                            ? const Color(
                                                                                0xffFB3D3D)
                                                                            : const Color(
                                                                                0xff313131),
                                                                        fontSize:
                                                                            12),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          Text(
                                                            getName(groupMap[
                                                                'admin']),
                                                            style: const TextStyle(
                                                                fontSize: 12,
                                                                color: Color(
                                                                    0xffC2C2C2)),
                                                          ),
                                                          const SizedBox(
                                                            height: 7,
                                                          ),
                                                          Row(
                                                            children: [
                                                              const Icon(
                                                                Symbols.alarm,
                                                                size: 15,
                                                              ),
                                                              const SizedBox(
                                                                width: 6,
                                                              ),
                                                              Text(
                                                                "${formatDate(groupMap['date'])} ${groupMap['orderTime']}",
                                                                style: const TextStyle(
                                                                    color: Color(
                                                                        0xff313131),
                                                                    fontFamily:
                                                                        "PretendardMedium",
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                              const SizedBox(
                                                                width: 8,
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              const Icon(
                                                                Symbols
                                                                    .monetization_on,
                                                                size: 15,
                                                              ),
                                                              const SizedBox(
                                                                width: 6,
                                                              ),
                                                              Text(
                                                                groupMap['deliveryTip'] ==
                                                                        -1
                                                                    ? "? 원"
                                                                    : "${NumberFormat('#,###').format(groupMap['deliveryTip'] / groupMap['members'].length)}원",
                                                                style: const TextStyle(
                                                                    color: Color(
                                                                        0xff313131),
                                                                    fontFamily:
                                                                        "PretendardMedium",
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                              const SizedBox(
                                                                width: 12,
                                                              ),
                                                              Text(
                                                                groupMap['deliveryTip'] ==
                                                                        -1
                                                                    ? "(? 원)"
                                                                    : "(${NumberFormat('#,###').format(groupMap['deliveryTip'])}원)",
                                                                style: const TextStyle(
                                                                    color: Color(
                                                                        0xffC2C2C2),
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              const Icon(
                                                                Symbols
                                                                    .location_on,
                                                                size: 15,
                                                              ),
                                                              const SizedBox(
                                                                width: 6,
                                                              ),
                                                              Text(
                                                                groupMap[
                                                                    'pickup'],
                                                                style: const TextStyle(
                                                                    color: Color(
                                                                        0xff313131),
                                                                    fontFamily:
                                                                        "PretendardMedium",
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 7,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ChatPage(
                                                      groupId:
                                                          groupMap['groupId'],
                                                      groupName:
                                                          groupMap['groupName'],
                                                      userName: userName,
                                                      groupTime:
                                                          groupMap['date'],
                                                      groupPlace:
                                                          groupMap['pickup'],
                                                      groupCurrent: int.parse(
                                                          groupMap[
                                                              'currPeople']),
                                                      groupAll: int.parse(
                                                          groupMap[
                                                              'maxPeople']),
                                                      members:
                                                          List<String>.from(
                                                              groupMap[
                                                                  'members']),
                                                      link: groupMap[
                                                          'togetherOrder'],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      );
                                    }),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Container();
          }
        },
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}
