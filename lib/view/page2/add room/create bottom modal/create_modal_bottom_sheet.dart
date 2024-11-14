import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../controller/home_provider.dart';
import '../../../../controller/map_provider.dart';
import '../../../../database/databaseService.dart';
import '../../../app.dart';
import '../../chat/chat_page.dart';

// 로딩 다이얼로그 위젯
void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    },
  );
}

// 로딩 다이얼로그 닫기
void hideLoadingDialog(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop();
}

Widget createModalBottomSheet(BuildContext context, MapProvider mapProvider,
    HomeProvider homeProvider, bool isModify) {
  Size size = MediaQuery.of(context).size;

  return Stack(
    children: [
      Container(
        color: Colors.white,
        height: 378,
        width: size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 30.0, bottom: 10.0),
                child: Text('채팅방을 생성하기 전에 정보를 확인해주세요!'),
              ),
              const Divider(
                color: Color(0xffC2C2C2),
                thickness: 0.5,
              ),
              mapProvider.restaurantName.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                      child: SizedBox(
                        height: 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              mapProvider.restaurantName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: "PretendardSemiBold",
                                fontSize: 24,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 30.0),
                      child: Text(
                        "가게 정보 없음",
                        style: TextStyle(
                          fontFamily: "PretendardSemiBold",
                          fontSize: 24,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
      Positioned(
        top: 180,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    CupertinoIcons.person_crop_circle,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "최대 인원",
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: "PretendardMedium",
                        color: Color(0xff313131)),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    homeProvider.selectedValue!,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16,
                        fontFamily: "PretendardMedium"),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(
                    Icons.place_outlined,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "주문 장소",
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: "PretendardMedium",
                        color: Color(0xff313131)),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    homeProvider.pickUpPlaceController.text,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16,
                        fontFamily: "PretendardMedium"),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(
                    Icons.alarm_rounded,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "주문 시간",
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: "PretendardMedium",
                        color: Color(0xff313131)),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    "${homeProvider.todayOrTomorrow} ${homeProvider.willOrderDateTime.toString().substring(11, 16)}",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16,
                        fontFamily: "PretendardMedium"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      Positioned(
        top: 290,
        left: 30,
        width: size.width - 60,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor:
                              const Color.fromRGBO(230, 230, 230, 1),
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "취소",
                          style: TextStyle(
                              fontFamily: "PretendardMedium", fontSize: 16),
                        )),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          final homeProvider =
                              Provider.of<HomeProvider>(context, listen: false);
                          final mapProvider =
                              Provider.of<MapProvider>(context, listen: false);

                          homeProvider.setLoading(true);
                          showLoadingDialog(context);

                          // 5초 후에 자동으로 로딩 다이얼로그를 닫는 타이머
                          Timer(const Duration(seconds: 5), () {
                            if (homeProvider.isLoading) {
                              hideLoadingDialog(context);
                              homeProvider.setLoading(false);
                            }
                          });

                          try {
                            if (isModify) {
                              // 수정 로직
                              String groupDate = DateFormat('yyyy-MM-dd')
                                  .format(homeProvider.willOrderDateTime);
                              String groupTime = DateFormat('HH:mm')
                                  .format(homeProvider.willOrderDateTime);

                              await DatabaseService().modifyGroupInfo(
                                homeProvider.groupId,
                                mapProvider.restaurantName,
                                groupDate,
                                groupTime,
                                homeProvider.pickUpPlaceController.text,
                                homeProvider.maxPeople.toString(),
                              );
                            } else {
                              // 새 채팅방 생성 로직
                              await homeProvider.setUserName();
                              homeProvider
                                  .setGroupName(mapProvider.restaurantName);

                              if (mapProvider.haveKakaoInfo) {
                                String id = mapProvider
                                    .restaurantInfo['place_url']
                                    .split("/")
                                    .last;
                                await mapProvider.getImageUrl(id);
                                homeProvider
                                    .setImgUrl(mapProvider.placeImageUrl);
                                homeProvider.setRestUrl(
                                    mapProvider.restaurantInfo['place_url']);
                              } else {
                                String imgUrl =
                                    "https://firebasestorage.googleapis.com/v0/b/han-bab.appspot.com/o/hanbab_icon.png?alt=media&token=a5cf00de-d53f-4e57-8440-ef7a5f6c6e1c";
                                homeProvider.setImgUrl(imgUrl);
                              }

                              await homeProvider.addChatRoomToFireStore();
                              await homeProvider.setChatMessageMap();
                              await DatabaseService().sendMessage(
                                  homeProvider.groupId,
                                  homeProvider.groupName,
                                  homeProvider.chatMessageMap);
                              await DatabaseService().setReset(
                                  DateFormat('yyyy-MM-dd')
                                      .format(homeProvider.willOrderDateTime),
                                  homeProvider.groupId,
                                  mapProvider.restaurantName);
                            }
                          } catch (e) {
                            print('Error: $e');
                          } finally {
                            hideLoadingDialog(context);
                            homeProvider.setLoading(false);
                            // Navigator.pushAndRemoveUntil(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => const App()),
                            //   (Route<dynamic> route) => false,
                            // );

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatPage(
                                  groupId: homeProvider.groupId,
                                  groupName: mapProvider.restaurantName,
                                  userName: homeProvider.userName,
                                  groupTime: DateFormat('HH:mm')
                                      .format(homeProvider.willOrderDateTime),
                                  groupPlace:
                                      homeProvider.pickUpPlaceController.text,
                                  groupCurrent: 1,
                                  groupAll: homeProvider.maxPeople,
                                  members: [
                                    "${homeProvider.uid}_${homeProvider.userName}"
                                  ],
                                  addRoom: true,
                                  link: homeProvider.extractLinkFromText(
                                      homeProvider.baeminLinkController.text),
                                ),
                              ),
                            );
                          }
                        },
                        child: const Text("확인",
                            style: TextStyle(
                                fontFamily: "PretendardSemiBold",
                                fontSize: 16))),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}
