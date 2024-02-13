import 'package:flutter/material.dart';

import '../color_schemes.dart';

class Button2 extends StatelessWidget {
  const Button2({Key? key, required this.function, required this.title})
      : super(key: key);

  final Function? function;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function != null
          ? () {
        function!();
      }
          : () {},
      child: Container(
        decoration: BoxDecoration(
            color: function != null
                ? lightColorScheme.primary
                : const Color(0xffC2C2C2),
            borderRadius: BorderRadius.circular(20)),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: "PretendardSemiBold"),
          ),
        ),
      ),
    );
  }
}