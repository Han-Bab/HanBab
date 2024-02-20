import 'package:flutter/material.dart';

class DatePicker extends StatelessWidget {
  final bool isToday;
  final Color color;

  const DatePicker({super.key, required this.isToday, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Center(
        child: Text(
          isToday == true ? '오늘' : '내일',
          style: TextStyle(
            fontSize: 20,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
