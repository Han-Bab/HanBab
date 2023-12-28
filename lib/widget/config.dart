import 'package:flutter/material.dart';

Widget toastTemplate(String msg, IconData icon, Color backgroundColor) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 20.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: backgroundColor,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
            fontSize: 12,
          ),
        ),
        // Opacity(
        //   opacity: 0,
        //   child: Icon(
        //     icon,
        //     color: Colors.white,
        //   ),
        // ),
      ],
    ),
  );
}
