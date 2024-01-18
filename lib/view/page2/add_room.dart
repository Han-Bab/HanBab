import 'package:flutter/material.dart';
import 'package:han_bab/controller/home_provider.dart';
import 'package:han_bab/controller/map_provider.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../../widget/button.dart';

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
                                print('You just selected $selection');
                                mapProvider.setSelectedJson(selection);
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
                                      height: size.height * 0.3,
                                      color: Colors.amberAccent,
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
                          ElevatedButton(
                            onPressed: () async {
                              homeProvider
                                  .setDateTime(await showOmniDateTimePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(16)),
                                constraints: const BoxConstraints(
                                  maxWidth: 350,
                                  maxHeight: 600,
                                ),
                                transitionBuilder:
                                    (context, anim1, anim2, child) {
                                  return FadeTransition(
                                    opacity: anim1.drive(
                                      Tween(
                                        begin: 0,
                                        end: 1,
                                      ),
                                    ),
                                    child: child,
                                  );
                                },
                                transitionDuration:
                                    const Duration(milliseconds: 200),
                                selectableDayPredicate: (dateTime) {
                                  int year = DateTime.now().year;
                                  int month = DateTime.now().month;
                                  int day = DateTime.now().day;
                                  // Disable 25th Feb 2023
                                  if (dateTime
                                      .isBefore(DateTime(year, month, day))) {
                                    return false;
                                  } else {
                                    return true;
                                  }
                                },
                              ));
                            },
                            child: Text(
                                homeProvider.orderDateTime == null
                                    ? "주문 시간 정하기"
                                    : DateFormat('yyyy-MM-dd HH:mm a')
                                        .format(homeProvider.orderDateTime!),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
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
          function: () {},
          title: '만들기',
        ),
      ),
    );
  }
}
