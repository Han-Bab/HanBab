import 'package:flutter/material.dart';

class MinutePicker extends StatelessWidget {
  final int mins;
  final Color color;

  const MinutePicker({super.key, required this.mins, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Center(
        child: Text(
          mins < 10 ? '0$mins' : mins.toString(),
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
