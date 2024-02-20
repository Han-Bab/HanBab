import 'package:flutter/material.dart';

class HourPicker extends StatelessWidget {
  final int hours;
  final Color color;

  const HourPicker({super.key, required this.hours, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Center(
        child: Text(
          hours < 10 ? '0$hours' : hours.toString(),
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
