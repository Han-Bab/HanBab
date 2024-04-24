import 'package:flutter/material.dart';
import 'package:han_bab/color_schemes.dart';
import 'package:han_bab/view/page2/chat/chat_page.dart';

class MyToggleButton extends StatefulWidget {
  const MyToggleButton({super.key, required this.width, required this.height});

  final double width;
  final double height;

  @override
  _MyToggleButtonState createState() => _MyToggleButtonState();
}

class _MyToggleButtonState extends State<MyToggleButton> {
  bool isToggled = !isChatScreenActive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isChatScreenActive = !isChatScreenActive;
        });
      },
      child: Stack(
        children: [
          Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              border: !isToggled && widget.width == 30
                  ? Border.all(color: lightColorScheme.primary)
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
