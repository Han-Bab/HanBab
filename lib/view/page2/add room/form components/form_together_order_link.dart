import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:han_bab/controller/home_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../controller/map_provider.dart';

void launchURL(String url) async {
  Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch $url';
  }
}

Widget formTogetherOrderLink(BuildContext context, bool isModify,
    MapProvider mapProvider, HomeProvider homeProvider) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
    child: Consumer<MapProvider>(
      builder: (context, value, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            formTogetherOrderLinkTitle(isModify),
            formTogetherOrderLinkTextField(isModify, mapProvider, homeProvider),
            formTogetherOrderLinkMap(context, mapProvider)
          ],
        );
      },
    ),
  );
}

Widget formTogetherOrderLinkTitle(bool isModify) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 15),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          isModify ? '가게 이름' : '함께주문 링크 첨부',
          style: const TextStyle(fontFamily: "PretendardMedium", fontSize: 16),
        ),
        TextButton(
            onPressed: () {
              launchURL('https://baeminkr.onelink.me/XgL8/baemincom');
            },
            child: const Text(
              '배민 바로가기 ❯',
              style: TextStyle(
                fontSize: 14,
                fontFamily: "PretendardMedium",
                color: Color(0xff3DBABE),
              ),
            )),
      ],
    ),
  );
}

String splitHttps(String input) {
  int index = input.indexOf("https");
  if (index != -1) {
    return input.substring(0, index);
  }
  return input;
}

bool isFirstPaste = true; // 처음 붙여넣기를 확인하기 위한 플래그

Widget formTogetherOrderLinkTextField(
    bool isModify, MapProvider mapProvider, HomeProvider homeProvider) {
  return isModify
      ? TextFormField(
          initialValue: mapProvider.restaurantName,
          readOnly: true,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: "PretendardRegular",
          ),
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(10),
            filled: true,
            fillColor: Color.fromRGBO(240, 240, 240, 1),
            border: InputBorder.none,
          ),
        )
      : TextFormField(
          controller: homeProvider.baeminLinkController,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: "PretendardRegular",
          ),
          keyboardType: TextInputType.text,
          onChanged: (value) {
            homeProvider.checkBaeminLinkFieldIsEmpty(value);
            // 처음 붙여넣기 시만 커서 위치 변경
            if (isFirstPaste) {
              homeProvider.baeminLinkController.selection =
                  TextSelection.fromPosition(
                    const TextPosition(offset: 0),
                  );
              isFirstPaste = false; // 붙여넣기 이후 커서 이동 방지
            }
          },
          onEditingComplete: () {
            print("EDITING COMPLETE");
            homeProvider.setIsError(false);
            String restaurant = '';
            try {
              List<String> splittedStr =
                  homeProvider.baeminLinkController.text.split("님이 ");

              restaurant = splittedStr[1].split("의 함께주문에")[0];
              restaurant = splitHttps(restaurant);
              mapProvider.restaurantName = restaurant;
              mapProvider.kakaoLocalSearchKeyword(restaurant);
            } catch (e) {
              if (restaurant.isEmpty) {
                print("정보가 없습니다");
                homeProvider.setIsError(true);
              }
            }

          },
          onTapOutside: (value) {
            print("EDITING COMPLETE");
            homeProvider.setIsError(false);
            String restaurant = '';
            try {
              List<String> splittedStr =
                  homeProvider.baeminLinkController.text.split("님이 ");

              restaurant = splittedStr[1].split("의 함께주문에")[0];
              restaurant = splitHttps(restaurant);
              mapProvider.restaurantName = restaurant;
              mapProvider.kakaoLocalSearchKeyword(restaurant);
            } catch (e) {
              if (restaurant.isEmpty) {
                print("정보가 없습니다");
                homeProvider.setIsError(true);
              }
            }
          },
          decoration: InputDecoration(
            errorText:
                homeProvider.isError ? "배민 함께주문 초대메시지를 올바르게 붙여 넣어주세요" : null,
            suffixIcon: homeProvider.baeminLinkFieldIsEmpty
                ? const IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.link_outlined,
                      color: Color.fromRGBO(194, 194, 194, 1),
                      size: 24,
                    ),
                  )
                : IconButton(
                    onPressed: () {
                      homeProvider.baeminLinkController.clear();
                      homeProvider.checkBaeminLinkFieldIsEmpty('');
                      mapProvider.clearAll();
                    },
                    icon: const Icon(
                      Icons.clear,
                      color: Color.fromRGBO(194, 194, 194, 1),
                      size: 24,
                    ),
                  ),
            hintText: 'OOO님이 OO점의 함께주문에 초대했어요. 원하는 메뉴를',
            hintStyle: const TextStyle(fontSize: 14),
            isDense: true,
            contentPadding: const EdgeInsets.all(10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xffC2C2C2),
              ),
            ),
          ),
        );
}

Widget formTogetherOrderLinkMap(BuildContext context, MapProvider mapProvider) {
  Size size = MediaQuery.of(context).size;

  return mapProvider.json.isNotEmpty
      ? mapProvider.restaurantInfo.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xffC9C9C9),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(11),
                        topRight: Radius.circular(11),
                      ),
                      child: SizedBox(
                        height: size.height * 0.3,
                        child: NaverMap(
                          key: mapProvider.mapKey,
                          options: NaverMapViewOptions(
                            initialCameraPosition: NCameraPosition(
                              target: NLatLng(
                                mapProvider.latitude,
                                mapProvider.longitude,
                              ),
                              zoom: 17,
                              bearing: 0,
                              tilt: 0,
                            ),
                          ),
                          onMapReady: (controller) {
                            final marker = NMarker(
                              id: mapProvider.restaurantName,
                              position: NLatLng(
                                  mapProvider.latitude, mapProvider.longitude),
                              size: const NSize(20, 27),
                              caption: NOverlayCaption(
                                  text: mapProvider.restaurantName,
                                  color: Colors.blue,
                                  haloColor: Colors.white),
                              captionAligns: [NAlign.top],
                              captionOffset: 5,
                            );
                            controller.addOverlay(marker);
                            print("Naver map Opened!!");
                          },
                        ),
                      ),
                    ),
                    Container(
                      height: size.height * 0.08,
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Color(0xffC9C9C9), // 선 색상
                            width: 1.0, // 선 두께
                          ),
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: GestureDetector(
                            onTap: () {
                              launchURL(
                                  mapProvider.restaurantInfo['place_url']);
                            },
                            child: Text(
                              mapProvider.restaurantName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: "PretendardMedium",
                                color: Color(0xffFB973D),
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
              padding: const EdgeInsets.only(top: 10.0),
              child: Column(
                children: [
                  Container(
                    height: size.height * 0.08,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color.fromRGBO(194, 194, 194, 1),
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          mapProvider.restaurantName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: "PretendardMedium",
                            color: Color(0xffFB973D),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
      : const SizedBox();
}
