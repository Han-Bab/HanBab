// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:han_bab/controller/orderlist_provider.dart';
// import 'package:han_bab/widget/bottom_navigation.dart';
// import 'package:provider/provider.dart';

// import '../page2/chat_page.dart';

// class OrderListPage extends StatelessWidget {
//   const OrderListPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     OrderlistProvider provider = Provider.of<OrderlistProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "주문내역",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Color(0xffF97E13),
//                 Color(0xffFFCD96),
//               ],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//       ),
//       body: FutureBuilder(
//         future: provider.orderList.isEmpty ? provider.getUserOrderList() : null,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.connectionState == ConnectionState.done) {
//             if (provider.orderList.isEmpty) {
//               return const Center(child: Text('주문 내역이 없습니다.'));
//             } else {
//               return ListView.builder(
//                 itemCount: provider.orderList.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ChatPage(
//                             groupId: provider.orderList[index].groupId!,
//                             groupName: provider.orderList[index].groupName!,
//                             userName: provider.userName,
//                             groupTime: provider.orderList[index].date!,
//                             groupPlace: provider.orderList[index].pickup!,
//                             groupCurrent: int.parse(
//                                 provider.orderList[index].currPeople!),
//                             groupAll:
//                                 int.parse(provider.orderList[index].maxPeople!),
//                             members: provider.orderList[index].members!, firstVisit: true,
//                           ),
//                         ),
//                       );
//                     },
//                     child: Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(10.0),
//                           child: Container(
//                             color: Colors.transparent,
//                             child: Row(
//                               children: [
//                                 /// 가게 이미지
//                                 SizedBox(
//                                   width: 100,
//                                   height: 100,
//                                   child: Container(
//                                     decoration: provider
//                                             .orderList[index].imgUrl!
//                                             .contains("hanbab_icon.png")
//                                         ? BoxDecoration(
//                                             border: Border.all(
//                                                 color: Colors.orange),
//                                             borderRadius:
//                                                 BorderRadius.circular(20))
//                                         : const BoxDecoration(),
//                                     child: ClipRRect(
//                                         borderRadius:
//                                             BorderRadius.circular(20.0),
//                                         child: Image.network(
//                                           provider.orderList[index].imgUrl!,
//                                           loadingBuilder:
//                                               (BuildContext? context,
//                                                   Widget? child,
//                                                   ImageChunkEvent?
//                                                       loadingProgress) {
//                                             if (loadingProgress == null) {
//                                               return child!;
//                                             }
//                                             return Center(
//                                               child: CircularProgressIndicator(
//                                                 value: loadingProgress
//                                                             .expectedTotalBytes !=
//                                                         null
//                                                     ? loadingProgress
//                                                             .cumulativeBytesLoaded /
//                                                         loadingProgress
//                                                             .expectedTotalBytes!
//                                                     : null,
//                                               ),
//                                             );
//                                           },
//                                           fit: BoxFit.cover,
//                                           errorBuilder: (BuildContext? context,
//                                               Object? exception,
//                                               StackTrace? stackTrace) {
//                                             return Container(
//                                               height: 120,
//                                               width: 120,
//                                               decoration: BoxDecoration(
//                                                 border: Border.all(width: 3),
//                                                 borderRadius:
//                                                     BorderRadius.circular(20),
//                                               ),
//                                               child: ClipRRect(
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           20.0),
//                                                   child: Image.asset(
//                                                     'assets/images/hanbab_icon.png',
//                                                     scale: 5,
//                                                   )),
//                                             );
//                                           },
//                                         )),
//                                   ),
//                                 ), //image
//                                 const SizedBox(
//                                   width: 15,
//                                 ),
//                                 // 가게 이미지 이후
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       const SizedBox(height: 10),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           /// 가게명
//                                           Text(
//                                             provider
//                                                 .orderList[index].groupName!,
//                                             style: const TextStyle(
//                                                 fontSize: 20,
//                                                 fontWeight: FontWeight.bold),
//                                           ),

//                                           /// 인원수
//                                           Row(
//                                             children: [
//                                               Text(
//                                                 String.fromCharCode(
//                                                     CupertinoIcons
//                                                         .person.codePoint),
//                                                 style: TextStyle(
//                                                   inherit: false,
//                                                   color: Colors.grey[500],
//                                                   fontSize: 16.0,
//                                                   fontWeight: FontWeight.w100,
//                                                   fontFamily: CupertinoIcons
//                                                       .person.fontFamily,
//                                                   package: CupertinoIcons
//                                                       .person.fontPackage,
//                                                 ),
//                                               ),
//                                               const SizedBox(
//                                                 width: 3,
//                                               ),
//                                               Text(
//                                                 '${provider.orderList[index].currPeople!}/${provider.orderList[index].maxPeople!}',
//                                                 style: TextStyle(
//                                                     color: Colors.grey[500],
//                                                     fontSize: 16),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                       const SizedBox(
//                                         height: 15,
//                                       ),
//                                       Column(
//                                         children: [
//                                           /// 픽업장소
//                                           Row(
//                                             children: [
//                                               Text(
//                                                 String.fromCharCode(
//                                                     CupertinoIcons
//                                                         .placemark.codePoint),
//                                                 style: TextStyle(
//                                                   inherit: false,
//                                                   color: Colors.grey[500],
//                                                   fontSize: 15.0,
//                                                   fontWeight: FontWeight.w100,
//                                                   fontFamily: CupertinoIcons
//                                                       .placemark.fontFamily,
//                                                   package: CupertinoIcons
//                                                       .placemark.fontPackage,
//                                                 ),
//                                               ),
//                                               const SizedBox(
//                                                 width: 5,
//                                               ),
//                                               Text(
//                                                   provider
//                                                       .orderList[index].pickup!,
//                                                   style: TextStyle(
//                                                       color: Colors.grey[500],
//                                                       fontSize: 13)),
//                                             ],
//                                           ),
//                                           const SizedBox(
//                                             height: 3,
//                                           ),

//                                           /// 픽업 시간
//                                           Row(
//                                             children: [
//                                               Text(
//                                                 String.fromCharCode(
//                                                     CupertinoIcons
//                                                         .alarm.codePoint),
//                                                 style: TextStyle(
//                                                   inherit: false,
//                                                   color: Colors.grey[500],
//                                                   fontSize: 15.0,
//                                                   fontWeight: FontWeight.w100,
//                                                   fontFamily: CupertinoIcons
//                                                       .person.fontFamily,
//                                                   package: CupertinoIcons
//                                                       .person.fontPackage,
//                                                 ),
//                                               ),
//                                               const SizedBox(
//                                                 width: 3,
//                                               ),
//                                               Text(
//                                                 '${provider.orderList[index].date!} ${provider.orderList[index].orderTime!}',
//                                                 style: TextStyle(
//                                                     fontSize: 13,
//                                                     color: Colors.grey[500]),
//                                               )
//                                             ],
//                                           ),
//                                         ],
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         const Divider(),
//                       ],
//                     ),
//                   );
//                 },
//               );

//               ///
//             }
//           } else {
//             return Container();
//           }
//         },
//       ),
//       bottomNavigationBar: const BottomNavigation(),
//     );
//   }
// }
