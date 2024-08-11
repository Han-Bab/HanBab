import 'package:flutter/material.dart';
import 'package:han_bab/database/databaseService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

bool isToggled = true;


class MyToggleButton extends StatefulWidget {
  const MyToggleButton({super.key, required this.width, required this.height});

  final double width;
  final double height;

  @override
  _MyToggleButtonState createState() => _MyToggleButtonState();
}

class _MyToggleButtonState extends State<MyToggleButton> {
  String gid = "";

  @override
  void initState() {
    super.initState();
    _loadGroupId(); // Database에서 groupId 불러오기
    _loadToggleState();  // 로컬에서 토글 상태 불러오기
  }

  Future<void> _loadGroupId() async {
    DatabaseService databaseService = DatabaseService();
    String currentGroup = await databaseService.getRest();

    if (currentGroup != "") {
      gid = currentGroup.substring(currentGroup.indexOf("_") + 1,
          currentGroup.indexOf("_", currentGroup.indexOf("_", 1) + 1));
    }
  }

  // 토글 상태를 로컬에 저장
  Future<void> _saveToggleState(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isToggled', value);
    _updateNotificationSubscription(value); // 상태 변경에 따른 알림 구독 처리
  }

  // 로컬에서 토글 상태 불러오기
  Future<void> _loadToggleState() async {
    final prefs = await SharedPreferences.getInstance();
    isToggled = prefs.getBool('isToggled') ?? true;
    _updateNotificationSubscription(isToggled); // 상태에 따른 알림 구독 처리
  }

  // 알림 구독 상태 업데이트
  void _updateNotificationSubscription(bool subscribe) {
    if (subscribe) {
      FirebaseMessaging.instance.subscribeToTopic(gid);
      print('Subscribed to topic: $gid');
    } else {
      FirebaseMessaging.instance.unsubscribeFromTopic(gid);
      print('Unsubscribed from topic: $gid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isToggled = !isToggled;
          _saveToggleState(isToggled);  // 상태 변경 시 로컬에 저장 및 알림 구독 상태 업데이트
        });
      },
      child: Stack(
        children: [
          Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              border: !isToggled && widget.width == 30
                  ? Border.all(color: Colors.orange)
                  : null,
              borderRadius: BorderRadius.circular(15),
              color: !isToggled && widget.width == 30
                  ? Colors.white
                  : !isToggled
                  ? Colors.grey
                  : widget.width != 30
                  ? const Color(0xffFB973D)
                  : const Color(0xffFB973D),

            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: isToggled ? widget.width / 2 : 0,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: CircleAvatar(
                backgroundColor: !isToggled && widget.width == 30
                    ? const Color(0xffFB973D)
                    : Colors.white,
                radius: (widget.height - 4) / 2,
              ),
            ),
          )
        ],
      ),
    );
  }
}
