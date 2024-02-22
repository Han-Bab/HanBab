import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:han_bab/view/page2/chat/chat_page.dart';
import 'package:flutter/cupertino.dart';
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
          // if (!userDoc.exists || userData == null) {
          //   return Center(child: Text('필요한 사용자 정보가 누락되었습니다.'));
          // }

          final userMap = userData as Map<String, dynamic>;
          // if (!userMap.containsKey('name') || !userMap.containsKey('groups')) {
          //   return Center(child: Text('필요한 사용자 정보가 누락되었습니다.'));
          // }

          final String userName = userMap['name'];
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
                    child: ListTile(
                      leading: Container(
                        width: 80,
                        height: 100,
                        child: groupMap['imgUrl'] != null &&
                                groupMap['imgUrl'].isNotEmpty
                            ? Image.network(groupMap['imgUrl'],
                                fit: BoxFit.cover)
                            : Image.asset('assets/images/hanbab_icon.png',
                                fit: BoxFit.cover),
                      ),
                      title: Text(groupMap['groupName']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('참여 인원: ${groupMap['currPeople']}'),
                          Text('픽업 장소: ${groupMap['pickup']}'),
                          Text('픽업 시간: ${groupMap['orderTime']}'),
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
                              members: List<String>.from(groupMap['members']), link: groupMap['togetherOrder'],
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
