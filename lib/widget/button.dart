import 'package:flutter/material.dart';

import '../color_schemes.dart';

class Button extends StatelessWidget {
  const Button({Key? key, required this.function, required this.title}) : super(key: key);

  final Function? function;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: function != null ? (){function!();} : null,
      style: ElevatedButton.styleFrom(
          backgroundColor: lightColorScheme.primary,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10))),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
