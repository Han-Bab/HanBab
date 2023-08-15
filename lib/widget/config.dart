import 'package:flutter/material.dart';

Widget toastTemplate(String msg, IconData icon, Color backgroundColor) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 24.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: backgroundColor,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: Colors.white,
        ),
        Text(
          msg,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        Opacity(
          opacity: 0,
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}
