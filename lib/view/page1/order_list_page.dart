import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:han_bab/view/page2/chat/chat_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:han_bab/view/page2/home/nowEntering.dart';
import 'package:han_bab/widget/appBar.dart';
import 'package:han_bab/widget/bottom_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

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
    // 날짜 문자열을 DateTime 객체로 파싱합니다.
    DateTime date = DateTime.parse(dateStr);

    // 날짜를 "월 일" 형식으로 포맷합니다.
    String formattedDate = "${date.month}월 ${date.day}일";

    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbar(context, "채팅"),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _firebaseFirestore
            .collection('user')
            .doc(_currentUserId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('주문 내역이 없습니다.'));
          }

          final userDoc = snapshot.data!;
          final userData = userDoc.data();
          final userMap = userData as Map<String, dynamic>;
          final String userName = userMap['name'];

          //현재 참여 중인 채팅방을 불러오는 게 이거인 것 같아서
          //함수 호출로 넣었는데 뭔가 안 되는 것 같아...

          List<String> userGroups =
              List<String>.from(userMap['groups'].reversed);
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
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
                    style:
                        TextStyle(fontSize: 14, fontFamily: "PretendardMedium"),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: userGroups.length,
                    itemBuilder: (context, index) {
                      String groupId = userGroups[index].split('_')[0];
                      return StreamBuilder<DocumentSnapshot>(
                        stream: _firebaseFirestore
                            .collection('groups')
                            .doc(groupId)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (!snapshot.hasData || snapshot.data == null) {
                            return Container();
                          }

                          final groupDoc = snapshot.data!;
                          final groupData = groupDoc.data();
                          if (!groupDoc.exists || groupData == null) {
                            return ListTile(
                              title: Text('필요한 채팅방 정보가 누락되었습니다.'),
                            );
                          }

                          final groupMap = groupData as Map<String, dynamic>;
                          if (!groupMap.containsKey('groupName') ||
                              !groupMap.containsKey('groupId') ||
                              !groupMap.containsKey('date') ||
                              !groupMap.containsKey('pickup') ||
                              !groupMap.containsKey('currPeople') ||
                              !groupMap.containsKey('maxPeople') ||
                              !groupMap.containsKey('members')) {
                            return ListTile(
                              title: Text('필요한 채팅방 정보가 누락되었습니다.'),
                            );
                          }

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 30.0),
                            child: GestureDetector(
                              child: Container(
                                color: Colors.transparent,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: groupMap['imgUrl'] != "" &&
                                              groupMap['imgUrl'] != "https://firebasestorage.googleapis.com/v0/b/han-bab.appspot.com/o/hanbab_icon.png?alt=media&token=a5cf00de-d53f-4e57-8440-ef7a5f6c6e1c"
                                          ? const BoxDecoration()
                                          : BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.orange),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                      child: groupMap['imgUrl'] != null &&
                                              groupMap['imgUrl'].isNotEmpty
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Opacity(
                                                opacity: 0.5,
                                                child: Image.network(
                                                    groupMap['imgUrl'],
                                                    fit: BoxFit.cover),
                                              ),
                                            )
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Opacity(
                                                opacity: 0.5,
                                                child: Image.asset(
                                                    'assets/images/hanbab_icon.png',
                                                    fit: BoxFit.cover),
                                              ),
                                            ),
                                    ),
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
                                                groupMap['groupName'],
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontFamily:
                                                        "PretendardMedium"),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Row(
                                                children: [
                                                  groupMap['members'].length ==
                                                          int.parse(groupMap[
                                                              'maxPeople'])
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
                                                    groupMap['maxPeople'] == "-1"
                                                        ? "최대 인원 제한 없음"
                                                        : '${groupMap['members'].length}/${groupMap['maxPeople']}',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "PretendardMedium",
                                                        color: groupMap['members']
                                                                    .length ==
                                                                int.parse(groupMap[
                                                                    'maxPeople'])
                                                            ? const Color(
                                                                0xffFB3D3D)
                                                            : const Color(
                                                                0xff313131),
                                                        fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Text(
                                            getName(groupMap['admin']),
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Color(0xffC2C2C2)),
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
                                                "${formatDate(groupMap['date'])} ${groupMap['orderTime']}",
                                                style: const TextStyle(
                                                    color: Color(0xff313131),
                                                    fontFamily:
                                                        "PretendardMedium",
                                                    fontSize: 12),
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              // Text(
                                              //   getTimeDifference(
                                              //       restaurant.orderTime, restaurant.date),
                                              //   style: const TextStyle(
                                              //       fontSize: 12, color: Color(0xffFB813D)),
                                              // )
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 1, top: 2),
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
                                                  groupMap['deliveryTip'] == -1
                                                      ? "? 원"
                                                      : "${NumberFormat('#,###').format(groupMap['deliveryTip'] / groupMap['members'].length)}원",
                                                  style: const TextStyle(
                                                      color: Color(0xff313131),
                                                      fontFamily:
                                                          "PretendardMedium",
                                                      fontSize: 12),
                                                ),
                                                const SizedBox(
                                                  width: 12,
                                                ),
                                                Text(
                                                  groupMap['deliveryTip'] == -1
                                                      ? "(? 원)"
                                                      : "(${NumberFormat('#,###').format(groupMap['deliveryTip'])}원)",
                                                  style: const TextStyle(
                                                      color: Color(0xffC2C2C2),
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 1, top: 2),
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
                                                  groupMap['pickup'],
                                                  style: const TextStyle(
                                                      color: Color(0xff313131),
                                                      fontFamily:
                                                          "PretendardMedium",
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
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
                                    builder: (context) => ChatPage(
                                      groupId: groupMap['groupId'],
                                      groupName: groupMap['groupName'],
                                      userName: userName,
                                      groupTime: groupMap['date'],
                                      groupPlace: groupMap['pickup'],
                                      groupCurrent:
                                          int.parse(groupMap['currPeople']),
                                      groupAll:
                                          int.parse(groupMap['maxPeople']),
                                      members: List<String>.from(
                                          groupMap['members']),
                                      link: groupMap['togetherOrder'],
                                      // firstVisit: true,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}
