import 'package:flutter/material.dart';
import 'package:han_bab/controller/home_provider.dart';
import 'package:han_bab/controller/map_provider.dart';
import 'package:han_bab/view/page2/add%20room/create_form.dart';
import 'package:han_bab/widget/appBar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'bottom_navigation_bar.dart';

class AddRoomPage extends StatelessWidget {
  final bool isModify;
  final Map<String, String>? currentData; // 선택적 파라미터로 변경

  const AddRoomPage({super.key, required this.isModify, this.currentData});

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final mapProvider = Provider.of<MapProvider>(context);

    String initialGroupAll = currentData?['groupAll'] ?? "";
    String initialGroupPlace = currentData?['groupPlace'] ?? "";
    String initialGroupTime = currentData?['groupTime'] ?? "00:00";
    String initialGroupDate = currentData?['groupDate'] ?? DateFormat('yyyy-MM-dd').format(DateTime.now());
    int dateComparison = initialGroupDate == DateFormat('yyyy-MM-dd').format(DateTime.now()) ? 0 : 1;


    bool isDataChanged(HomeProvider homeProvider) {
      // 현재 값과 초기값 비교
      return homeProvider.selectedValue != initialGroupAll ||
          homeProvider.pickUpPlaceController.text != initialGroupPlace ||
          "${homeProvider.selectedHoursIndex.toString().padLeft(2, '0')}:${homeProvider.selectedMinutesIndex.toString().padLeft(2, '0')}" != initialGroupTime ||
          (homeProvider.selectedDatesIndex != dateComparison);
    }
    isDataChanged(homeProvider);
    return Consumer<HomeProvider>(
      builder: (context, value, child) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            body: Column(
              children: [
                appbar(context, isModify ? "함께주문 수정하기" : "함께주문 만들기"),
                createForm(context, isModify, mapProvider, homeProvider),
              ],
            ),
            bottomNavigationBar: bottomNavigationBar(
                context, mapProvider, homeProvider, isModify, isDataChanged(homeProvider)),
          ),
        );
      },
    );
  }
}
