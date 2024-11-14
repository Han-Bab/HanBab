import 'package:flutter/material.dart';
import 'package:han_bab/controller/home_provider.dart';
import 'package:han_bab/controller/map_provider.dart';
import 'create bottom modal/create_modal_bottom_sheet.dart';

Widget bottomNavigationBar(BuildContext context, MapProvider mapProvider,
    HomeProvider homeProvider, bool isModify, bool isDataChanged) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
    child: mapProvider.restaurantName.isEmpty ||
            homeProvider.pickUpPlaceController.text.isEmpty ||
            homeProvider.selectedValue == null ||
            homeProvider.willOrderDateTime.isBefore(DateTime.now()) || !isDataChanged
        ? deactivateCreateButton(isModify)
        : activeCreateButton(context, mapProvider, homeProvider, isModify),
  );
}

Widget deactivateCreateButton(bool isModify) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: const Color.fromRGBO(230, 230, 230, 1),
        padding: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: null,
      child: Text(
        isModify ? "수정하기" : "만들기",
        style: const TextStyle(
          fontSize: 20,
          fontFamily: "PretendardSemiBold",
          color: Colors.white,
        ),
      ));
}

Widget activeCreateButton(BuildContext context, MapProvider mapProvider,
    HomeProvider homeProvider, bool isModify) {
  return ElevatedButton(
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
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          context: context,
          builder: (BuildContext context) {
            return createModalBottomSheet(
                context, mapProvider, homeProvider, isModify);
          },
        );
      },
      child: Text(
        isModify ? "수정하기" : "만들기",
        style: const TextStyle(
          fontSize: 20,
          fontFamily: "PretendardSemiBold",
          color: Colors.white,
        ),
      ));
}
