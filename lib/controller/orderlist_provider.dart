// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../database/databaseService.dart';
import '../model/order_info.dart';

class OrderlistProvider extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String userName = '';
  List<OrderInfo> orderList = [];

  void initOrderlist() async {
    await getUserName();
    await getUserOrderList();
  }

  Future<void> getUserName() async {
    userName = await DatabaseService().getUserName();
    print(userName);
  }

  Future<void> getUserOrderList() async {
    print('Method getUserOrderList..');
    final userData =
        await _firestore.collection('user').doc(_auth.currentUser!.uid).get();

    List<dynamic> primitiveList = userData.data()?['groups'];

    String groupId = '';
    List<String> tempList = [];
    for (var order in primitiveList) {
      /// 실제 groupId 찾는 과정
      tempList = order.split('_');
      if (tempList.isNotEmpty) {
        groupId = tempList[0].toString();
      } else {
        print('SPLIT ERROR!!');
      }
      // 그룹의 정보를 찾는 과정
      DocumentSnapshot snapshot =
          await _firestore.collection('groups').doc(groupId).get();

      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      OrderInfo info = OrderInfo(
        groupId: data['groupId'],
        groupName: data['groupName'],
        pickup: data['pickup'],
        currPeople: data['members'].length.toString(),
        maxPeople: data['maxPeople'],
        date: data['date'],
        orderTime: data['orderTime'],
        imgUrl: data['imgUrl'],
        members: data['members'],
      );

      orderList.add(info);
    }

    orderList = orderList.reversed.toList();
  }
}
