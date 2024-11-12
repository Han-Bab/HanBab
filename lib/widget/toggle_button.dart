import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../main.dart';

bool isToggled = true;

class MyToggleButton extends StatefulWidget {
  const MyToggleButton({super.key, required this.width, required this.height});

  final double width;
  final double height;

  @override
  _MyToggleButtonState createState() => _MyToggleButtonState();
}

class _MyToggleButtonState extends State<MyToggleButton> {
  @override
  void initState() {
    super.initState();
    _loadToggleState(); // 로컬에서 토글 상태 불러오기
  }

  // 토글 상태를 로컬에 저장
  Future<void> _saveToggleState(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isToggled', value);
    setNotificationEnabled(value); // 알림 상태 업데이트
  }

  // 로컬에서 토글 상태 불러오기
  Future<void> _loadToggleState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isToggled = prefs.getBool('isToggled') ?? true; // 기본값 true
    });
    setNotificationEnabled(isToggled); // 저장된 상태에 따라 알림 설정
  }

  // 알림 상태 설정 함수
  void setNotificationEnabled(bool enabled) async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: enabled,
      badge: enabled,
      sound: enabled,
    );
    setState(() {
      isInChatPage = !enabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isToggled = !isToggled;
          _saveToggleState(isToggled); // 상태 변경 시 로컬에 저장 및 알림 상태 업데이트
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
