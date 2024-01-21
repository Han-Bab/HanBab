import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:han_bab/controller/home_provider.dart';
import 'package:han_bab/controller/map_provider.dart';
import 'package:han_bab/database/databaseService.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:scroll_datetime_picker/scroll_datetime_picker.dart';

import '../../widget/button.dart';
import 'chat_page.dart';

class AddRoomPage extends StatelessWidget {
  const AddRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final mapProvider = Provider.of<MapProvider>(context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "밥채팅 만들기",
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
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Center(
            child: Consumer<HomeProvider>(
              builder: (context, value, child) {
                return Column(
                  children: [
                    /* 매장 선택 */
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 30),
                      child: Consumer<MapProvider>(
                          builder: (context, value, child) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(bottom: 15),
                              child: Text(
                                '매장 선택',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Autocomplete<String>(
                              optionsBuilder:
                                  (TextEditingValue textEditingValue) {
                                if (textEditingValue.text == '') {
                                  return ['현재 검색결과가 없습니다'];
                                }
                                return mapProvider.searchList.where(
                                    (String option) => option
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase()));
                              },
                              onSelected: (String selection) {
                                mapProvider.setSelectedJson(selection);
                                homeProvider.setGroupName(selection);
                                mapProvider.triggerInit();
                              },
                              optionsViewBuilder:
                                  (context, onSelected, options) => Padding(
                                padding: const EdgeInsets.only(right: 40.0),
                                child: ListView.builder(
                                  itemCount: options.length,
                                  itemBuilder: (context, index) {
                                    return Material(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey.shade200,
                                          ),
                                        ),
                                        child: ListTile(
                                          title: Text(options.elementAt(index)),
                                          dense: true,
                                          onTap: () {
                                            onSelected(
                                                options.elementAt(index));
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              fieldViewBuilder: (context, textEditingController,
                                  focusNode, onFieldSubmitted) {
                                return TextFormField(
                                  controller: textEditingController,
                                  onEditingComplete: () {
                                    mapProvider.kakaoLocalSearchKeyword(
                                        textEditingController.text);
                                  },
                                  onChanged: (value) {
                                    if (value.isEmpty) {
                                      homeProvider.setStoreFieldIsEmpty(true);
                                    } else {
                                      homeProvider.setStoreFieldIsEmpty(false);
                                    }
                                  },
                                  focusNode: focusNode,
                                  onFieldSubmitted: (String value) {
                                    onFieldSubmitted();
                                  },
                                  decoration: InputDecoration(
                                    suffixIcon: homeProvider.storeFieldIsEmpty
                                        ? const IconButton(
                                            // API 불러오기
                                            onPressed: null,
                                            icon: Icon(
                                              Icons.search,
                                              color: Color.fromRGBO(
                                                  194, 194, 194, 1),
                                              size: 24,
                                            ),
                                          )
                                        : IconButton(
                                            onPressed: () {
                                              textEditingController.clear();
                                              homeProvider
                                                  .checkStoreFieldIsEmpty('');
                                            },
                                            icon: const Icon(
                                              Icons.clear,
                                              color: Color.fromRGBO(
                                                  194, 194, 194, 1),
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
                                );
                              },
                            ),
                            mapProvider.selectedJson.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color.fromRGBO(
                                              194, 194, 194, 1),
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: size.height * 0.3,
                                            child: NaverMap(
                                              key: mapProvider.mapKey,
                                              options: NaverMapViewOptions(
                                                initialCameraPosition:
                                                    NCameraPosition(
                                                        target: NLatLng(
                                                            mapProvider
                                                                .selectedLatitude,
                                                            mapProvider
                                                                .selectedLongitude),
                                                        zoom: 17,
                                                        bearing: 0,
                                                        tilt: 0),
                                              ),
                                              onMapReady: (controller) {
                                                final marker = NMarker(
                                                  id: mapProvider.selectedName,
                                                  position: NLatLng(
                                                      mapProvider
                                                          .selectedLatitude,
                                                      mapProvider
                                                          .selectedLongitude),
                                                  size: const NSize(20, 27),
                                                  caption: NOverlayCaption(
                                                      text: mapProvider
                                                          .selectedName,
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
                                          SizedBox(
                                            height: size.height * 0.08,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15.0),
                                                child: Text(
                                                  mapProvider.selectedName,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        );
                      }),
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
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.25,
                            child: ScrollDateTimePicker(
                              key: homeProvider.pickerKey,
                              itemExtent: 55,
                              infiniteScroll: true,
                              dateOption: DateTimePickerOption(
                                dateFormat: DateFormat.Hm(),
                                minDate: DateTime(2020, 01, 01),
                                maxDate: DateTime(2099, 12, 31),
                                initialDate: homeProvider.orderDateTime
                                    .add(const Duration(hours: 1)),
                              ),
                              style: DateTimePickerStyle(
                                activeStyle: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                inactiveStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[400],
                                ),
                                activeDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Theme.of(context).primaryColor,
                                ),
                                disabledStyle: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey[400],
                                ),
                                centerDecoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              wheelOption: const DateTimePickerWheelOption(
                                perspective: 0.00000001,
                              ),
                              onChange: (datetime) {
                                homeProvider.setDateTime(datetime);
                                print("Changed: ${homeProvider.orderDateTime}");
                              },
                            ),
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
                                        homeProvider.setDateTime(homeProvider
                                            .orderDateTime
                                            .add(const Duration(minutes: 10)));
                                        homeProvider.triggerInit();
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
                                        homeProvider.setDateTime(homeProvider
                                            .orderDateTime
                                            .add(const Duration(minutes: 20)));
                                        homeProvider.triggerInit();
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
                                        homeProvider.setDateTime(homeProvider
                                            .orderDateTime
                                            .add(const Duration(minutes: 30)));
                                        homeProvider.triggerInit();
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
                                        homeProvider.setDateTime(homeProvider
                                            .orderDateTime
                                            .add(const Duration(hours: 1)));
                                        homeProvider.triggerInit();
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
                    const Divider(
                        thickness: 5, color: Color.fromRGBO(240, 240, 240, 1)),

                    /* 수령 장소 선택 */
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 15),
                            child: Text(
                              '수령 장소 선택',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          // 중복됨
                          TextFormField(
                            controller: homeProvider.pickUpPlaceController,
                            onChanged: (value) {
                              homeProvider.checkPickUpPlaceFieldIsEmpty(value);
                            },
                            decoration: InputDecoration(
                              suffixIcon: homeProvider.pickUpPlaceFieldIsEmpty
                                  ? IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.search,
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
                          ),
                        ],
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
                              '최대 인원 선택',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              hint: Text(
                                '최대 인원을 선택하세요',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              isDense: false,
                              items: homeProvider
                                  .addDividersAfterItems(homeProvider.items),
                              value: homeProvider.selectedValue,
                              onChanged: (String? value) {
                                homeProvider.setSelectedValue(value!);
                              },
                              buttonStyleData: const ButtonStyleData(
                                decoration: BoxDecoration(
                                  border: Border.fromBorderSide(
                                    BorderSide(
                                      color: Color.fromRGBO(194, 194, 194, 1),
                                    ),
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 0),
                              ),
                              dropdownStyleData: const DropdownStyleData(
                                padding: EdgeInsets.all(0),
                                maxHeight: 150,
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 8.0),
                              ),
                              iconStyleData: const IconStyleData(
                                openMenuIcon: Icon(Icons.arrow_drop_up),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.2),
                  ],
                );
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
        child: Button(
          backgroundColor: Theme.of(context).primaryColor,
          function: () async {
            await homeProvider.setUserName();
            String imgUrl =
                await DatabaseService().getImage(mapProvider.selectedName);
            await homeProvider
                .addChatRoomToFireStore(imgUrl)
                .then((value) async {
              await homeProvider.setChatMessageMap();
            }).whenComplete(() {
              DatabaseService().sendMessage(
                  homeProvider.groupId, homeProvider.chatMessageMap);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatPage(
                            groupId: homeProvider.groupId,
                            groupName: mapProvider.selectedName,
                            userName: homeProvider.userName,
                            groupTime: DateFormat('HH:mm')
                                .format(homeProvider.orderDateTime),
                            groupPlace: homeProvider.pickUpPlaceController.text,
                            groupCurrent: 1,
                            groupAll: homeProvider.maxPeople,
                            members: [
                              "${homeProvider.uid}_${homeProvider.userName}"
                            ],
                            firstVisit: true,
                          )));
            });
          },
          title: '만들기',
        ),
      ),
    );
  }
}
