import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:han_bab/controller/map_provider.dart';
import 'package:intl/intl.dart';
import 'package:han_bab/database/databaseService.dart';

// Provider Mangagement
class HomeProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DateTime? _orderDateTime; // EX) 2024-01-18 23:04:00.000

  get orderDateTime => _orderDateTime;
  void setDateTime(DateTime? dateTime) {
    _orderDateTime = dateTime;
    print(DateFormat('yyyy-MM-dd').format(_orderDateTime!));
    print(DateFormat('HH:mm').format(_orderDateTime!));

    notifyListeners();
  }

  /* Store Selection */
  bool storeFieldIsEmpty = true;

  void setStoreFieldIsEmpty(bool value) {
    storeFieldIsEmpty = value;
    notifyListeners();
  }

  void checkStoreFieldIsEmpty(String value) {
    if (value.isEmpty) {
      storeFieldIsEmpty = true;
    } else {
      storeFieldIsEmpty = false;
    }
    notifyListeners();
  }

  TextEditingController _storeNameController = TextEditingController();
  TextEditingController get storeNameController => _storeNameController;
  void setStoreNameController(TextEditingController controller) {
    _storeNameController = controller;
    notifyListeners();
  }

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
  // pickUpPlaceController.text = ""

  /* 최대 인원 선택 */
  final List<String> items = [
    '2명',
    '3명',
    '4명',
    '5명',
    '6명',
    '최대 인원 제한 없음',
  ];
  int maxPeople = 0;

  String? _selectedValue;
  String? get selectedValue => _selectedValue;
  void setSelectedValue(String? value) {
    _selectedValue = value;
    if (_selectedValue == '최대 인원 제한 없음') {
      maxPeople = -1;
    } else {
      List<String> result = _selectedValue!.split('');
      maxPeople = int.parse(result[0]);
    }
    print("최대 인원: $maxPeople");
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
        ],
      );
    }
    return menuItems;
  }

  //*----------------------------------------------------------------------------

  String groupName = '';
  void setGroupName(String groupName) {
    this.groupName = groupName;

    notifyListeners();
  }

  String groupId = '';
  String userName = '';
  String uid = '';

  Future<void> setUserName() async {
    userName = await DatabaseService().getUserName();
    uid = _auth.currentUser!.uid;

    notifyListeners();
  }

  Future<void> addChatRoomToFireStore() async {
    final Map<String, dynamic> data = {
      'admin': '${uid}_$userName',
      'groupId': '',
      'groupName': groupName,
      'date': DateFormat('yyyy-MM-dd').format(_orderDateTime!),
      'orderTime': DateFormat('HH:mm').format(_orderDateTime!),
      'pickup': pickUpPlaceController.text,
      'maxPeople': maxPeople.toString(),
      'currPeople': '1',
      'members': [],
      'recentMessage': '',
      'recentMessageSender': '',
      'recentMessageTime': '',
      'togetherOrder': '',
    };

    DocumentReference groupsDoc =
        await _firestore.collection('groups').add(data);

    groupId = groupsDoc.id;

    await groupsDoc.update({
      'members': FieldValue.arrayUnion(["${uid}_$userName"]),
      'groupId': groupId,
    });

    DocumentReference userDoc = _firestore.collection('user').doc(uid);
    await userDoc.update({
      "groups":
          FieldValue.arrayUnion(["${groupId}_${MapProvider().selectedName}"])
    });

    notifyListeners();
  }

  Map<String, dynamic> chatMessageMap = {};

  Future<void> setChatMessageMap() async {
    chatMessageMap = {
      "message": "$userName 님이 입장하셨습니다",
      "sender": userName,
      "time": DateTime.now().toString(),
      "isEnter": 1
    };

    notifyListeners();
  }
}
