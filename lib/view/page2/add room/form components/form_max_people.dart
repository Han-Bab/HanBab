import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:han_bab/controller/home_provider.dart';

Widget formMaxPeople(BuildContext context, HomeProvider homeProvider) {
  Size size = MediaQuery.of(context).size;

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 15),
          child: Text(
            '최대 주문 인원 선택',
            style: TextStyle(
              fontSize: 16,
              fontFamily: "PretendardMedium",
            ),
          ),
        ),
        DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: const Text(
              '최대 주문 인원을 선택해주세요',
              style: TextStyle(
                fontSize: 14,
                fontFamily: "PretendardRegular",
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
                          fontFamily: "PretendardRegular",
                          fontSize: 14,
                        ),
                      )),
                );
              }).toList();
            },
            underline: const SizedBox(
              height: 4,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
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
                  color: const Color.fromRGBO(194, 194, 194, 1),
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 50,
              width: size.width,
            ),
            dropdownStyleData: DropdownStyleData(
                maxHeight: 350,
                offset: const Offset(0, 7), // 드롭다운을 버튼 위로 이동
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xffC9C9C9)),
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                  boxShadow: const [], // 그림자 없애기
                )),
            menuItemStyleData: const MenuItemStyleData(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
            ),
            iconStyleData: IconStyleData(
              icon: const Icon(CupertinoIcons.chevron_down),
              openMenuIcon: const Icon(CupertinoIcons.chevron_up),
              iconEnabledColor: Colors.grey[400],
            ),
          ),
        ),
      ],
    ),
  );
}
