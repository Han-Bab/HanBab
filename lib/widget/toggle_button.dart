import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../main.dart';

// isToggled를 외부에서도 접근할 수 있도록 유지
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
    // 앱이 시작될 때가 아닌, 위젯이 처음 생성될 때만 상태를 로드
    _syncToggleState();
  }

  // 저장된 토글 상태와 동기화
  Future<void> _syncToggleState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // main.dart에서 설정된 isToggled 값을 사용
      isToggled = prefs.getBool('isToggled') ?? true;
    });
  }

  // 토글 상태 저장 및 알림 설정 업데이트
  Future<void> _updateToggleState(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isToggled', value);

    // 알림 설정 업데이트
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: value,
      badge: value,
      sound: value,
    );

    // isInChatPage 상태 업데이트 (알림 표시 여부에 영향)
    isInChatPage = !value;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final newValue = !isToggled;
        // 먼저 상태를 업데이트하고
        setState(() {
          isToggled = newValue;
        });
        // 그 다음 저장 및 알림 설정 업데이트
        await _updateToggleState(newValue);
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
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // 필요한 경우 정리 작업 수행
    super.dispose();
  }
}