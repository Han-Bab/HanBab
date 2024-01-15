import 'package:flutter/material.dart';

// Provider Mangagement
class HomeProvider extends ChangeNotifier {
  DateTime? _orderDateTime;

  get orderDateTime => _orderDateTime;
  void setDateTime(DateTime? dateTime) {
    _orderDateTime = dateTime;
    notifyListeners();
  }

  /* Store Selection */
  bool storeFieldIsEmpty = true;
  void checkStoreFieldIsEmpty(String value) {
    if (value.isEmpty) {
      storeFieldIsEmpty = true;
    } else {
      storeFieldIsEmpty = false;
    }
    notifyListeners();
  }

  final TextEditingController _storeNameController = TextEditingController();
  TextEditingController get storeNameController => _storeNameController;

  /* PickUp Place Selection */
  bool pickUpPlaceFieldIsEmpty = true;
  void checkPickUpPlaceFieldIsEmpty(String value) {
    if (value.isEmpty) {
      pickUpPlaceFieldIsEmpty = true;
    } else {
      pickUpPlaceFieldIsEmpty = false;
    }
    notifyListeners();
  }

  final TextEditingController _pickUpPlaceController = TextEditingController();
  TextEditingController get pickUpPlaceController => _pickUpPlaceController;

  /* 최대 인원 선택 */
  final List<String> items = [
    '2명',
    '3명',
    '4명',
    '5명',
    '6명',
    '최대 인원 제한 없음',
  ];
  String? _selectedValue;
  String? get selectedValue => _selectedValue;
  void setSelectedValue(String? value) {
    _selectedValue = value;
    notifyListeners();
  }

  List<DropdownMenuItem<String>> addDividersAfterItems(List<String> items) {
    final List<DropdownMenuItem<String>> menuItems = [];
    for (final String item in items) {
      menuItems.addAll(
        [
          DropdownMenuItem<String>(
            value: item,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),
          //If it's last item, we will not add Divider after it.
          // if (item != items.last)
          //   const DropdownMenuItem<String>(
          //     enabled: false,
          //     child: Padding(
          //       padding: EdgeInsets.all(0.0),
          //       child: Divider(
          //         height: 1,
          //         indent: 0,
          //         thickness: 1,
          //       ),
          //     ),
          //   ),
        ],
      );
    }
    return menuItems;
  }
}
