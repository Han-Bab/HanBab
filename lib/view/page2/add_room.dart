// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:han_bab/controller/home_provider.dart';
import 'package:han_bab/controller/map_provider.dart';
import 'package:han_bab/view/app.dart';
import 'package:han_bab/widget/appBar.dart';
import 'package:han_bab/widget/time_picker/dates.dart';
import 'package:han_bab/widget/time_picker/hours.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../../database/databaseService.dart';
import '../../widget/time_picker/minutes.dart';
import 'chat/chat_page.dart';

class AddRoomPage extends StatelessWidget {
  const AddRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final mapProvider = Provider.of<MapProvider>(context);
    Size size = MediaQuery.of(context).size;

    FixedExtentScrollController datesController = FixedExtentScrollController(
        initialItem: homeProvider.selectedDatesIndex);
    FixedExtentScrollController hoursController = FixedExtentScrollController(
        initialItem: homeProvider.selectedHoursIndex);
    FixedExtentScrollController minutesController = FixedExtentScrollController(
        initialItem: homeProvider.selectedMinutesIndex);

    void launchURL(String url) async {
      Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch $url';
      }
    }

    return Consumer<HomeProvider>(
      builder: (context, value, child) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    appbar(context, "밥채팅 만들기"),
                    /* 배민 함께 주문하기 링크 복붙 */
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
                      child: Consumer<MapProvider>(
                        builder: (context, value, child) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      '함께주문 초대 메시지 첨부',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          launchURL(
                                              'https://baeminkr.onelink.me/XgL8/baemincom');
                                        },
                                        child: const Text(
                                          '배민 바로가기 ❯',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Color.fromRGBO(61, 186, 190, 1),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                              TextFormField(
                                controller: homeProvider.baeminLinkController,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                                keyboardType: TextInputType.text,
                                onChanged: (value) {
                                  homeProvider
                                      .checkBaeminLinkFieldIsEmpty(value);
                                },
                                onEditingComplete: () {
                                  print("EDITING COMPLETE");
                                  homeProvider.setIsError(false);
                                  String restaurant = '';
                                  try {
                                    List<String> splittedStr = homeProvider
                                        .baeminLinkController.text
                                        .split("님이 ");
                                    restaurant =
                                        splittedStr[1].split("의 함께주문에")[0];
                                    mapProvider.restaurantName = restaurant;
                                    mapProvider
                                        .kakaoLocalSearchKeyword(restaurant);
                                  } catch (e) {
                                    if (restaurant.isEmpty) {
                                      print("정보가 없습니다");
                                      homeProvider.setIsError(true);
                                    }
                                  }
                                },
                                decoration: InputDecoration(
                                  errorText: homeProvider.isError
                                      ? "배민 함께주문 초대메시지를 올바르게 붙여 넣어주세요"
                                      : null,
                                  suffixIcon: homeProvider
                                          .baeminLinkFieldIsEmpty
                                      ? const IconButton(
                                          onPressed: null,
                                          icon: Icon(
                                            Icons.link_outlined,
                                            color: Color.fromRGBO(
                                                194, 194, 194, 1),
                                            size: 24,
                                          ),
                                        )
                                      : IconButton(
                                          onPressed: () {
                                            homeProvider.baeminLinkController
                                                .clear();
                                            homeProvider
                                                .checkBaeminLinkFieldIsEmpty(
                                                    '');
                                            mapProvider.clearAll();
                                          },
                                          icon: const Icon(
                                            Icons.clear,
                                            color: Color.fromRGBO(
                                                194, 194, 194, 1),
                                            size: 24,
                                          ),
                                        ),
                                  hintText: 'OOO님이 OO점의 함께주문에 초대했어요. 원하는 메뉴를',
                                  hintStyle: const TextStyle(fontSize: 14),
                                  isDense: true,
                                  contentPadding: const EdgeInsets.all(10),
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(194, 194, 194, 1),
                                    ),
                                  ),
                                ),
                              ),
                              mapProvider.json.isNotEmpty
                                  ? mapProvider.restaurantInfo.isNotEmpty
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: const Color.fromRGBO(
                                                    194, 194, 194, 1),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: size.height * 0.3,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color:
                                                          const Color.fromRGBO(
                                                              194, 194, 194, 1),
                                                    ),
                                                  ),
                                                  child: NaverMap(
                                                    key: mapProvider.mapKey,
                                                    options:
                                                        NaverMapViewOptions(
                                                      initialCameraPosition:
                                                          NCameraPosition(
                                                              target: NLatLng(
                                                                  mapProvider
                                                                      .latitude,
                                                                  mapProvider
                                                                      .longitude),
                                                              zoom: 17,
                                                              bearing: 0,
                                                              tilt: 0),
                                                    ),
                                                    onMapReady: (controller) {
                                                      final marker = NMarker(
                                                        id: mapProvider
                                                            .restaurantName,
                                                        position: NLatLng(
                                                            mapProvider
                                                                .latitude,
                                                            mapProvider
                                                                .longitude),
                                                        size:
                                                            const NSize(20, 27),
                                                        caption: NOverlayCaption(
                                                            text: mapProvider
                                                                .restaurantName,
                                                            color: Colors.blue,
                                                            haloColor:
                                                                Colors.white),
                                                        captionAligns: [
                                                          NAlign.top
                                                        ],
                                                        captionOffset: 5,
                                                      );
                                                      controller
                                                          .addOverlay(marker);
                                                      print(
                                                          "Naver map Opened!!");
                                                    },
                                                  ),
                                                ),
                                                Container(
                                                  height: size.height * 0.08,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color:
                                                          const Color.fromRGBO(
                                                              194, 194, 194, 1),
                                                    ),
                                                    // borderRadius:
                                                    //     BorderRadius.circular(5),
                                                  ),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 15.0),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          launchURL(mapProvider
                                                                  .restaurantInfo[
                                                              'place_url']);
                                                        },
                                                        child: Text(
                                                          mapProvider
                                                              .restaurantName,
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10.0),
                                          child: Column(
                                            children: [
                                              Container(
                                                height: size.height * 0.08,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: const Color.fromRGBO(
                                                        194, 194, 194, 1),
                                                  ),
                                                  // borderRadius:
                                                  //     BorderRadius.circular(5),
                                                ),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 15.0),
                                                    child: Text(
                                                      mapProvider
                                                          .restaurantName,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                  : const SizedBox(),
                            ],
                          );
                        },
                      ),
                    ),
                    const Divider(
                        thickness: 5, color: Color.fromRGBO(240, 240, 240, 1)),

                    /* 최대 인원 선택 */
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 15),
                            child: Text(
                              '최대 주문 인원 선택',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              hint: const Text(
                                '최대 주문 인원을 선택해주세요',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              items: homeProvider.getDropdownMenuItems(),
                              selectedItemBuilder: (context) {
                                return homeProvider.items.map((String item) {
                                  return Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 0),
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        )),
                                  );
                                }).toList();
                              },
                              underline: const SizedBox(
                                height: 4,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Divider(),
                                ),
                              ),
                              value: homeProvider.selectedValue,
                              onChanged: (String? value) {
                                homeProvider.setSelectedValue(value);
                              },
                              buttonStyleData: ButtonStyleData(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        const Color.fromRGBO(194, 194, 194, 1),
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                height: 50,
                                width: size.width,
                              ),
                              dropdownStyleData: const DropdownStyleData(
                                maxHeight: 350,
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                              ),
                              iconStyleData: IconStyleData(
                                icon: const Icon(CupertinoIcons.chevron_down),
                                openMenuIcon:
                                    const Icon(CupertinoIcons.chevron_up),
                                iconEnabledColor: Colors.grey[400],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                        thickness: 5, color: Color.fromRGBO(240, 240, 240, 1)),

                    /* 수령 장소 선택 */
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  '수령 장소 선택',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                TextButton(
                                  onPressed: () => homeProvider
                                      .showRecommendPlace(context, size),
                                  child: const Text(
                                    '추천 장소 ❯',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // 중복됨
                          TextFormField(
                            controller: homeProvider.pickUpPlaceController,
                            onChanged: (value) {
                              homeProvider.checkPickUpPlaceFieldIsEmpty(value);
                            },
                            decoration: InputDecoration(
                              hintText: '직접 입력하기',
                              hintStyle: const TextStyle(fontSize: 14),
                              suffixIcon: homeProvider.pickUpPlaceFieldIsEmpty
                                  ? const IconButton(
                                      onPressed: null,
                                      icon: Icon(
                                        Icons.place_outlined,
                                        color: Color.fromRGBO(194, 194, 194, 1),
                                        size: 24,
                                      ),
                                    )
                                  : IconButton(
                                      onPressed: () {
                                        homeProvider.pickUpPlaceController
                                            .clear();
                                        homeProvider
                                            .checkPickUpPlaceFieldIsEmpty('');
                                      },
                                      icon: const Icon(
                                        Icons.clear,
                                        color: Color.fromRGBO(194, 194, 194, 1),
                                        size: 24,
                                      ),
                                    ),
                              isDense: true,
                              contentPadding: const EdgeInsets.all(10),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(194, 194, 194, 1),
                                ),
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                        thickness: 5, color: Color.fromRGBO(240, 240, 240, 1)),

                    /* 주문 예정 시간 */
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 15),
                            child: Text(
                              '주문 예정 시간',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  height: 50,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: SizedBox(
                                      height: size.height * 0.25,
                                      child: ListWheelScrollView.useDelegate(
                                        controller: datesController,
                                        itemExtent: 50,
                                        perspective: 0.005,
                                        diameterRatio: 1.2,
                                        physics:
                                            const FixedExtentScrollPhysics(),
                                        onSelectedItemChanged: (index) {
                                          homeProvider
                                              .setSelectedDatesIndex(index);

                                          homeProvider.setWillOrderDateTime();
                                        },
                                        childDelegate:
                                            ListWheelChildBuilderDelegate(
                                          childCount: 2,
                                          builder: (context, index) {
                                            if (index ==
                                                homeProvider
                                                    .selectedDatesIndex) {
                                              if (index == 0) {
                                                return const DatePicker(
                                                  isToday: true,
                                                  color: Colors.white,
                                                );
                                              } else {
                                                return const DatePicker(
                                                  isToday: false,
                                                  color: Colors.white,
                                                );
                                              }
                                            } else {
                                              if (index == 0) {
                                                return DatePicker(
                                                  isToday: true,
                                                  color: Colors.grey[400]!,
                                                );
                                              } else {
                                                return DatePicker(
                                                  isToday: false,
                                                  color: Colors.grey[400]!,
                                                );
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      height: size.height * 0.25,
                                      child: ListWheelScrollView.useDelegate(
                                        controller: hoursController,
                                        itemExtent: 50,
                                        perspective: 0.005,
                                        diameterRatio: 1.2,
                                        physics:
                                            const FixedExtentScrollPhysics(),
                                        onSelectedItemChanged: (index) {
                                          print("hours: $index");
                                          homeProvider
                                              .setSelectedHoursIndex(index);

                                          homeProvider.setWillOrderDateTime();
                                        },
                                        childDelegate:
                                            ListWheelChildBuilderDelegate(
                                          childCount: 24,
                                          builder: (context, index) {
                                            if (index ==
                                                homeProvider
                                                    .selectedHoursIndex) {
                                              return HourPicker(
                                                hours: index,
                                                color: Colors.white,
                                              );
                                            } else {
                                              return HourPicker(
                                                hours: index,
                                                color: Colors.grey[400]!,
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      height: size.height * 0.25,
                                      child: ListWheelScrollView.useDelegate(
                                        controller: minutesController,
                                        itemExtent: 50,
                                        perspective: 0.005,
                                        diameterRatio: 1.2,
                                        physics:
                                            const FixedExtentScrollPhysics(),
                                        onSelectedItemChanged: (index) {
                                          print("minutes: $index");
                                          homeProvider
                                              .setSelectedMinutesIndex(index);

                                          homeProvider.setWillOrderDateTime();
                                        },
                                        childDelegate:
                                            ListWheelChildBuilderDelegate(
                                          childCount: 60,
                                          builder: (context, index) {
                                            if (index ==
                                                homeProvider
                                                    .selectedMinutesIndex) {
                                              return MinutePicker(
                                                mins: index,
                                                color: Colors.white,
                                              );
                                            } else {
                                              return MinutePicker(
                                                mins: index,
                                                color: Colors.grey[400]!,
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                              color: Color.fromRGBO(
                                                  194, 194, 194, 1)),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                      onPressed: () {
                                        int mins =
                                            homeProvider.selectedMinutesIndex +
                                                10;
                                        if (mins > 59) {
                                          mins = mins - 60;
                                          homeProvider.setSelectedHoursIndex(
                                              homeProvider.selectedHoursIndex +
                                                  1);
                                          hoursController.animateToItem(
                                            homeProvider.selectedHoursIndex,
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.ease,
                                          );
                                          if (homeProvider.selectedHoursIndex ==
                                              24) {
                                            homeProvider
                                                .setSelectedHoursIndex(0);
                                            homeProvider
                                                .setSelectedDatesIndex(1);
                                            hoursController.animateToItem(
                                              homeProvider.selectedHoursIndex,
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.ease,
                                            );
                                            datesController.animateToItem(
                                              homeProvider.selectedDatesIndex,
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.ease,
                                            );
                                          }
                                        }
                                        homeProvider
                                            .setSelectedMinutesIndex(mins);
                                        minutesController.animateToItem(
                                          homeProvider.selectedMinutesIndex,
                                          duration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.ease,
                                        );

                                        homeProvider.setWillOrderDateTime();
                                      },
                                      child: const Text(
                                        '10분 후',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                              color: Color.fromRGBO(
                                                  194, 194, 194, 1)),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                      onPressed: () {
                                        int mins =
                                            homeProvider.selectedMinutesIndex +
                                                20;
                                        if (mins > 59) {
                                          mins = mins - 60;
                                          homeProvider.setSelectedHoursIndex(
                                              homeProvider.selectedHoursIndex +
                                                  1);
                                          hoursController.animateToItem(
                                            homeProvider.selectedHoursIndex,
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.ease,
                                          );
                                          if (homeProvider.selectedHoursIndex ==
                                              24) {
                                            homeProvider
                                                .setSelectedHoursIndex(0);
                                            homeProvider
                                                .setSelectedDatesIndex(1);
                                            hoursController.animateToItem(
                                              homeProvider.selectedHoursIndex,
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.ease,
                                            );
                                            datesController.animateToItem(
                                              homeProvider.selectedDatesIndex,
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.ease,
                                            );
                                          }
                                        }
                                        homeProvider
                                            .setSelectedMinutesIndex(mins);
                                        minutesController.animateToItem(
                                          homeProvider.selectedMinutesIndex,
                                          duration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.ease,
                                        );

                                        homeProvider.setWillOrderDateTime();
                                      },
                                      child: const Text(
                                        '20분 후',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                              color: Color.fromRGBO(
                                                  194, 194, 194, 1)),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                      onPressed: () {
                                        int mins =
                                            homeProvider.selectedMinutesIndex +
                                                30;
                                        if (mins > 59) {
                                          mins = mins - 60;
                                          homeProvider.setSelectedHoursIndex(
                                              homeProvider.selectedHoursIndex +
                                                  1);
                                          hoursController.animateToItem(
                                            homeProvider.selectedHoursIndex,
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.ease,
                                          );
                                          if (homeProvider.selectedHoursIndex ==
                                              24) {
                                            homeProvider
                                                .setSelectedHoursIndex(0);
                                            homeProvider
                                                .setSelectedDatesIndex(1);
                                            hoursController.animateToItem(
                                              homeProvider.selectedHoursIndex,
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.ease,
                                            );
                                            datesController.animateToItem(
                                              homeProvider.selectedDatesIndex,
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.ease,
                                            );
                                          }
                                        }
                                        homeProvider
                                            .setSelectedMinutesIndex(mins);
                                        minutesController.animateToItem(
                                          homeProvider.selectedMinutesIndex,
                                          duration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.ease,
                                        );

                                        homeProvider.setWillOrderDateTime();
                                      },
                                      child: const Text(
                                        '30분 후',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                              color: Color.fromRGBO(
                                                  194, 194, 194, 1)),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                      onPressed: () {
                                        int hours =
                                            homeProvider.selectedHoursIndex + 1;
                                        if (hours > 23) {
                                          hours = 0;
                                          homeProvider.setSelectedDatesIndex(1);
                                          datesController.animateToItem(
                                            homeProvider.selectedDatesIndex,
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.ease,
                                          );
                                        }
                                        homeProvider
                                            .setSelectedHoursIndex(hours);
                                        hoursController.animateToItem(
                                          homeProvider.selectedHoursIndex,
                                          duration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.ease,
                                        );

                                        homeProvider.setWillOrderDateTime();
                                      },
                                      child: const Text(
                                        '1시간 후',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: Text(
                              "주문 예정 시간이 지나면 채팅방 입장이 마감됩니다",
                              style: TextStyle(
                                color: Color.fromRGBO(125, 125, 125, 1),
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
              child: mapProvider.restaurantName.isEmpty ||
                      homeProvider.pickUpPlaceController.text.isEmpty ||
                      homeProvider.selectedValue == null ||
                      homeProvider.willOrderDateTime.isBefore(DateTime.now())
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: const Color.fromRGBO(230, 230, 230, 1),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: null,
                      child: const Text(
                        "만들기",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          constraints: BoxConstraints(
                            maxHeight: size.height * 0.5,
                          ),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20.0)),
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              color: Colors.white,
                              width: size.width,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          top: 30.0, bottom: 10.0),
                                      child: Text('채팅방을 생성하기 전에 정보를 확인해주세요!'),
                                    ),
                                    const Divider(
                                      color: Color(0xffC2C2C2),
                                      thickness: 0.5,
                                    ),
                                    mapProvider.restaurantName.isNotEmpty
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20.0, bottom: 30.0),
                                            child: Text(
                                              mapProvider.restaurantName,
                                              style: TextStyle(
                                                fontFamily:
                                                    "PretendardSemiBold",
                                                fontSize: 24,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20.0, bottom: 30.0),
                                            child: Text(
                                              "가게 정보 없음",
                                              style: TextStyle(
                                                fontFamily:
                                                    "PretendardSemiBold",
                                                fontSize: 24,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                          ),
                                    Row(
                                      children: [
                                        const Icon(
                                          CupertinoIcons.person_crop_circle,
                                          size: 24,
                                        ),
                                        const SizedBox(width: 10),
                                        const Text(
                                          "최대 인원",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: "PretendardSemiBold",
                                              color: Color(0xff313131)),
                                        ),
                                        const SizedBox(width: 20),
                                        Text(
                                          homeProvider.selectedValue!,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
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
                                          homeProvider
                                              .pickUpPlaceController.text,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
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
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 16,
                                              fontFamily: "PretendardMedium"),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    // const SizedBox(height: 30),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextButton(
                                              style: TextButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                backgroundColor:
                                                    const Color.fromRGBO(
                                                        230, 230, 230, 1),
                                                foregroundColor: Colors.black,
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                "취소",
                                                style: TextStyle(
                                                    fontFamily:
                                                        "PretendardMedium",
                                                    fontSize: 16),
                                              )),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: TextButton(
                                              style: TextButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .primaryColor,
                                                foregroundColor: Colors.white,
                                              ),
                                              onPressed: () async {
                                                await homeProvider
                                                    .setUserName();
                                                homeProvider.setGroupName(
                                                    mapProvider.restaurantName);
                                                if (mapProvider.haveKakaoInfo) {
                                                  String id = mapProvider
                                                      .restaurantInfo[
                                                          'place_url']
                                                      .split("/")
                                                      .last;
                                                  await mapProvider
                                                      .getImageUrl(id);
                                                  homeProvider.setImgUrl(
                                                      mapProvider
                                                          .placeImageUrl);
                                                  homeProvider.setRestUrl(
                                                      mapProvider
                                                              .restaurantInfo[
                                                          'place_url']);
                                                } else {
                                                  String imgUrl =
                                                      "https://firebasestorage.googleapis.com/v0/b/han-bab.appspot.com/o/hanbab_icon.png?alt=media&token=a5cf00de-d53f-4e57-8440-ef7a5f6c6e1c";
                                                  homeProvider
                                                      .setImgUrl(imgUrl);
                                                }
                                                await homeProvider
                                                    .addChatRoomToFireStore()
                                                    .then((value) async {
                                                  await homeProvider
                                                      .setChatMessageMap();
                                                }).whenComplete(() async {
                                                  DatabaseService().sendMessage(
                                                      homeProvider.groupId,
                                                      homeProvider
                                                          .chatMessageMap);
                                                  await DatabaseService().setReset(
                                                      DateFormat('yyyy-MM-dd')
                                                          .format(homeProvider
                                                              .willOrderDateTime),
                                                      homeProvider.groupId,
                                                      mapProvider
                                                          .restaurantName);
                                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const App()), (Route<dynamic> route) => false);
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ChatPage(
                                                                groupId:
                                                                    homeProvider
                                                                        .groupId,
                                                                groupName:
                                                                    mapProvider
                                                                        .restaurantName,
                                                                userName:
                                                                    homeProvider
                                                                        .userName,
                                                                groupTime: DateFormat(
                                                                        'HH:mm')
                                                                    .format(homeProvider
                                                                        .willOrderDateTime),
                                                                groupPlace:
                                                                    homeProvider
                                                                        .pickUpPlaceController
                                                                        .text,
                                                                groupCurrent: 1,
                                                                groupAll:
                                                                    homeProvider
                                                                        .maxPeople,
                                                                members: [
                                                                  "${homeProvider.uid}_${homeProvider.userName}"
                                                                ],
                                                                addRoom: true,
                                                                link: homeProvider
                                                                    .extractLinkFromText(
                                                                        homeProvider
                                                                            .baeminLinkController
                                                                            .text),
                                                                // firstVisit: true,
                                                              )));
                                                });
                                              },
                                              child: const Text("확인",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          "PretendardSemiBold",
                                                      fontSize: 16))),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 18),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: const Text(
                        "만들기",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
