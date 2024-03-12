import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:han_bab/view/page2/chat/chat_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:han_bab/view/page2/home/nowEntering.dart';
import 'package:han_bab/widget/bottom_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('채팅'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
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
          NowEntering(userName: userName);

          List<String> userGroups =
              List<String>.from(userMap['groups'].reversed);
          return ListView.builder(
            itemCount: userGroups.length,
            itemBuilder: (context, index) {
              String groupId = userGroups[index].split('_')[0];
              return StreamBuilder<DocumentSnapshot>(
                stream: _firebaseFirestore
                    .collection('groups')
                    .doc(groupId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
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

                  return Card(
                    color: Colors.white,
                    elevation: 0,
                    child: ListTile(
                      leading: SizedBox(
                        width: 100,
                        height: 100,
                        child: groupMap['imgUrl'] != null &&
                                groupMap['imgUrl'].isNotEmpty
                            ? Image.network(groupMap['imgUrl'],
                                fit: BoxFit.cover)
                            : Image.asset('assets/images/hanbab_icon.png',
                                fit: BoxFit.cover),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                groupMap['groupName'],
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "PretendardMedium"),
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    "./assets/icons/homePerson.png",
                                    scale: 1.5,
                                  ),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    '${groupMap['currPeople']}/${groupMap['maxPeople']}',
                                    style: TextStyle(
                                        fontFamily: "PretendardMedium",
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            //여기엔,,, 방장 이름 와야 하긴 함
                            height: 12,
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
                                '${groupMap['orderTime']}',
                                style: const TextStyle(
                                    color: Color(0xff313131),
                                    fontFamily: "PretendardMedium",
                                    fontSize: 12),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                            ],
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
                                  '${groupMap['pickup']}',
                                  style: const TextStyle(
                                      color: Color(0xff313131),
                                      fontFamily: "PretendardMedium",
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                        ],
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
                              groupCurrent: int.parse(groupMap['currPeople']),
                              groupAll: int.parse(groupMap['maxPeople']),
                              members: List<String>.from(groupMap['members']),
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
          );
        },
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}
