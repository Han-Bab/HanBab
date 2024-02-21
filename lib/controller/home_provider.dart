// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:han_bab/controller/map_provider.dart';
import 'package:han_bab/database/databaseService.dart';

// Provider Mangagement
class HomeProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /* 배민 함께주문하기 링크 */
  bool baeminLinkFieldIsEmpty = true;
  void checkBaeminLinkFieldIsEmpty(String value) {
    if (value.isEmpty) {
      baeminLinkFieldIsEmpty = true;
    } else {
      baeminLinkFieldIsEmpty = false;
    }
    notifyListeners();
  }

  final TextEditingController _baeminLinkController = TextEditingController();
  TextEditingController get baeminLinkController => _baeminLinkController;

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

  /* Recommend Place */
  List<String> dorm = [
    '비전관',
    '창조관',
    '벧엘관',
    '국제관',
    '로뎀관',
    '은혜관',
    '하용조관',
    '갈대상자관'
  ];
  List<String> majorBuilding = [
    '오석관',
    '뉴턴홀',
    '느헤미야홀',
    '현동홀',
    '코너스톤홀',
    '올네이션스홀',
    '언어교육원',
    '김영길그레이스스쿨',
    '에벤에셀관'
  ];
  List<String> etc = [
    '야외공연장',
    '매점 앞',
    '평봉필드',
    '로맨틱잔디',
    '복지동 GS앞',
    '효암채플',
    '비전벤치',
    'HIS'
  ];

  void showRecommendPlace(BuildContext context, Size size) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: size.height * 0.4,
          child: DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                flexibleSpace: const Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: TabBar(tabs: [
                    Tab(
                        child: Text("기숙사",
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    Tab(
                        child: Text("학과건물",
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    Tab(
                        child: Text("기타",
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ]),
                ),
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              body: TabBarView(
                children: [
                  /* 기숙사 */
                  GridView.builder(
                    itemCount: 8,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 2.5 / 1, //item 의 가로 1, 세로 2 의 비율)
                    ),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          pickUpPlaceController.text = dorm[index];
                          notifyListeners();
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey[100]!,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              dorm[index],
                              style: dorm[index] == pickUpPlaceController.text
                                  ? TextStyle(
                                      fontSize: 13, color: Colors.grey[400])
                                  : const TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  /* 학과건물 */
                  GridView.builder(
                    itemCount: 9,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 2.5 / 1, //item 의 가로 1, 세로 2 의 비율)
                    ),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          pickUpPlaceController.text = majorBuilding[index];
                          notifyListeners();
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey[100]!,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              majorBuilding[index],
                              style: majorBuilding[index] ==
                                      pickUpPlaceController.text
                                  ? TextStyle(
                                      fontSize: 13, color: Colors.grey[400])
                                  : const TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  /* 기타 */
                  GridView.builder(
                    itemCount: 8,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 2.5 / 1, //item 의 가로 1, 세로 2 의 비율)
                    ),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          pickUpPlaceController.text = etc[index];
                          notifyListeners();
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey[100]!,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              etc[index],
                              style: etc[index] == pickUpPlaceController.text
                                  ? TextStyle(
                                      fontSize: 13, color: Colors.grey[400])
                                  : const TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

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

  List<DropdownMenuItem<String>> getDropdownMenuItems() {
    final List<DropdownMenuItem<String>> menuItems = [];
    for (String item in items) {
      menuItems.addAll(
        [
          DropdownMenuItem<String>(
            value: item,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
              child: _selectedValue != item
                  ? Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    )
                  : Text(item,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
                      )),
            ),
          ),
        ],
      );
    }

    return menuItems;
  }

  /* 주문 예정 시간 선택 */
  String _todayOrTomorrow = '';
  String get todayOrTomorrow => _todayOrTomorrow;

  ////////////////////////////////////////////////////////////////

  int _selectedDatesIndex = 0;
  int _selectedHoursIndex = DateTime.now().hour;
  int _selectedMinutesIndex = DateTime.now().minute;

  int get selectedDatesIndex => _selectedDatesIndex;
  void setSelectedDatesIndex(int index) {
    _selectedDatesIndex = index;
    notifyListeners();
  }

  int get selectedHoursIndex => _selectedHoursIndex;
  void setSelectedHoursIndex(int index) {
    _selectedHoursIndex = index;
    notifyListeners();
  }

  int get selectedMinutesIndex => _selectedMinutesIndex;
  void setSelectedMinutesIndex(int index) {
    _selectedMinutesIndex = index;
    notifyListeners();
  }

  DateTime _willOrderDateTime = DateTime.now();
  DateTime get willOrderDateTime => _willOrderDateTime;
  void setWillOrderDateTime() {
    if (selectedDatesIndex == 0) {
      _todayOrTomorrow = '오늘';
    } else {
      _todayOrTomorrow = '내일';
    }

    _willOrderDateTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      selectedDatesIndex == 0 ? DateTime.now().day : DateTime.now().day + 1,
      selectedHoursIndex,
      selectedMinutesIndex,
    );
    notifyListeners();
  }

  ////////////////////////////////////////////////////////////////

  void clearAll() {
    _willOrderDateTime = DateTime.now();
    storeFieldIsEmpty = true;
    pickUpPlaceFieldIsEmpty = true;
    _storeNameController.clear();
    _pickUpPlaceController.clear();
    maxPeople = 0;
    _selectedValue = null;
    baeminLinkFieldIsEmpty = true;
    _baeminLinkController.clear();

    print("initial orderDateTime: $_willOrderDateTime");

    notifyListeners();
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

  String _imgUrl = '';
  String get imgUrl => _imgUrl;
  void setImgUrl(String imgUrl) {
    _imgUrl = imgUrl;

    notifyListeners();
  }

  Future<void> setUserName() async {
    userName = await DatabaseService().getUserName();
    uid = _auth.currentUser!.uid;

    notifyListeners();
  }

  String _restUrl = '';
  String get restUrl => _restUrl;
  void setRestUrl(String restUrl) {
    _restUrl = restUrl;

    notifyListeners();
  }

  String? extractLinkFromText(String text) {
    // 정규표현식을 사용하여 "https://"로 시작하는 부분을 찾음
    RegExp regExp = RegExp(r'https?://(?:[a-zA-Z0-9\-]+\.)+[a-zA-Z]{2,}(?:/[^/]*)*');
    // 링크를 추출하여 매칭되는 첫 번째 값 반환
    RegExpMatch? match = regExp.firstMatch(text);
    return match?.group(0);
  }

  Future<void> addChatRoomToFireStore() async {
    final Map<String, dynamic> data = {
      'admin': '${uid}_$userName',
      'groupId': '',
      'groupName': groupName,
      'date': DateFormat('yyyy-MM-dd').format(willOrderDateTime),
      'orderTime': DateFormat('HH:mm').format(willOrderDateTime),
      'pickup': pickUpPlaceController.text,
      'maxPeople': maxPeople.toString(),
      'currPeople': '1',
      'members': [],
      'recentMessage': '',
      'recentMessageSender': '',
      'recentMessageTime': '',
      'togetherOrder': extractLinkFromText(baeminLinkController.text),
      'imgUrl': imgUrl,
      'restUrl': restUrl
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
          FieldValue.arrayUnion(["${groupId}_${MapProvider().restaurantName}"])
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
