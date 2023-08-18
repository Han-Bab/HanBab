import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:han_bab/widget/bottom_navigation.dart';

import '../../database/databaseService.dart';
import '../../model/order_info.dart';
import '../page2/chat_page.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({super.key});

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  late Future<void> _orderListFuture;

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  List<dynamic> orderList = [];
  List<OrderInfo> orderInfoList = [];
  String userName = '';

  void getUserName() {
    DatabaseService().getUserName().then((value) {
      if (mounted) {
        setState(() {
          userName = value;
        });
      }
    });
  }

  Future<void> getUserOrderList() async {
    final userData =
        await _firestore.collection('user').doc(_auth.currentUser!.uid).get();

    orderList = userData.data()?['groups'];

    String groupId = '';
    List<String> tempList = [];
    for (var order in orderList) {
      /// 실제 groupId 찾는 과정
      tempList = order.split('_');
      if (tempList.isNotEmpty) {
        groupId = tempList[0].toString();
      } else {
        if (kDebugMode) {
          print('SPLIT ERROR!!');
        }
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

      orderInfoList.add(info);
    }

    orderInfoList = orderInfoList.reversed.toList();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserName();
    _orderListFuture = getUserOrderList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "주문내역",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xffF97E13),
                Color(0xffFFCD96),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: _orderListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.done) {
            // print(orderInfoList);
            if (orderInfoList.isEmpty) {
              return const Center(child: Text('주문 내역이 없습니다.'));
            } else {
              return ListView.builder(
                itemCount: orderInfoList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            groupId: orderInfoList[index].groupId!,
                            groupName: orderInfoList[index].groupName!,
                            userName: userName,
                            groupTime: orderInfoList[index].date!,
                            groupPlace: orderInfoList[index].pickup!,
                            groupCurrent:
                                int.parse(orderInfoList[index].currPeople!),
                            groupAll:
                                int.parse(orderInfoList[index].maxPeople!),
                            members: orderInfoList[index].members!,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            color: Colors.transparent,
                            child: Row(
                              children: [
                                /// 가게 이미지
                                SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: Container(
                                    decoration: orderInfoList[index]
                                            .imgUrl!
                                            .contains("hanbab_icon.png")
                                        ? BoxDecoration(
                                            border: Border.all(
                                                color: Colors.orange),
                                            borderRadius:
                                                BorderRadius.circular(20))
                                        : const BoxDecoration(),
                                    child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        child: Image.network(
                                          orderInfoList[index].imgUrl!,
                                          loadingBuilder:
                                              (BuildContext? context,
                                                  Widget? child,
                                                  ImageChunkEvent?
                                                      loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child!;
                                            }
                                            return Center(
                                              child: CircularProgressIndicator(
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
                                          errorBuilder: (BuildContext? context,
                                              Object? exception,
                                              StackTrace? stackTrace) {
                                            return Container(
                                              height: 120,
                                              width: 120,
                                              decoration: BoxDecoration(
                                                border: Border.all(width: 3),
                                                borderRadius:
                                                    BorderRadius.circular(20),
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
                                  width: 15,
                                ),
                                // 가게 이미지 이후
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          /// 가게명
                                          Text(
                                            orderInfoList[index].groupName!,
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),

                                          /// 인원수
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
                                                '${orderInfoList[index].currPeople!}/${orderInfoList[index].maxPeople!}',
                                                style: TextStyle(
                                                    color: Colors.grey[500],
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Column(
                                        children: [
                                          /// 픽업장소
                                          Row(
                                            children: [
                                              Text(
                                                String.fromCharCode(
                                                    CupertinoIcons
                                                        .placemark.codePoint),
                                                style: TextStyle(
                                                  inherit: false,
                                                  color: Colors.grey[500],
                                                  fontSize: 15.0,
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
                                              Text(orderInfoList[index].pickup!,
                                                  style: TextStyle(
                                                      color: Colors.grey[500],
                                                      fontSize: 13)),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 3,
                                          ),

                                          /// 픽업 시간
                                          Row(
                                            children: [
                                              Text(
                                                String.fromCharCode(
                                                    CupertinoIcons
                                                        .alarm.codePoint),
                                                style: TextStyle(
                                                  inherit: false,
                                                  color: Colors.grey[500],
                                                  fontSize: 15.0,
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
                                                '${orderInfoList[index].date!} ${orderInfoList[index].orderTime!}',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey[500]),
                                              )
                                            ],
                                          ),
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
                    ),
                  );
                },
              );

              ///
            }
          } else {
            return Container();
          }
        },
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}
