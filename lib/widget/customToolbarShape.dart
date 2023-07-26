import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomToolbarShape extends CustomPainter {
  final Color lineColor;

  const CustomToolbarShape({required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();

//First oval
    Path path = Path();
    Rect pathGradientRect = Rect.fromCircle(
      center: Offset(size.width / 4, 0),
      radius: size.width/1.4,
    );

    Gradient gradient = LinearGradient(
      colors: <Color>[
        const Color.fromRGBO(225, 89, 89, 1).withOpacity(1),
        const Color.fromRGBO(255, 128, 16, 1).withOpacity(1),
      ],
      stops: const [
        0.3,
        1.0,
      ],
    );

    path.lineTo(-size.width / 1.4, 0);
    path.quadraticBezierTo(
        size.width / 2, size.height * 2, size.width + size.width / 1.4, 0);

    paint.color = Colors.deepOrange;
    paint.shader = gradient.createShader(pathGradientRect);
    paint.strokeWidth = 40;
    path.close();

    canvas.drawPath(path, paint);

//Second oval
    Rect secondOvalRect = Rect.fromPoints(
      Offset(-size.width / 2.5, -size.height),
      Offset(size.width * 1.4, size.height / 1.5),
    );

    gradient = LinearGradient(
      colors: <Color>[
        const Color.fromRGBO(225, 255, 255, 1).withOpacity(0.1),
        const Color.fromRGBO(255, 206, 31, 1).withOpacity(0.2),
      ],
      stops: const [
        0.0,
        1.0,
      ],
    );
    Paint secondOvalPaint = Paint()
      ..color = Colors.deepOrange
      ..shader = gradient.createShader(secondOvalRect);

    canvas.drawOval(secondOvalRect, secondOvalPaint);

//Third oval
    Rect thirdOvalRect = Rect.fromPoints(
      Offset(-size.width / 2.5, -size.height),
      Offset(size.width * 1.4, size.height / 2.7),
    );

    gradient = LinearGradient(
      colors: <Color>[
        const Color.fromRGBO(225, 255, 255, 1).withOpacity(0.05),
        const Color.fromRGBO(255, 196, 21, 1).withOpacity(0.2),
      ],
      stops: const [
        0.0,
        1.0,
      ],
    );
    Paint thirdOvalPaint = Paint()
      ..color = Colors.deepOrange
      ..shader = gradient.createShader(thirdOvalRect);

    canvas.drawOval(thirdOvalRect, thirdOvalPaint);

//Fourth oval
    Rect fourthOvalRect = Rect.fromPoints(
      Offset(-size.width / 2.4, -size.width/1.875),
      Offset(size.width / 1.34, size.height / 1.14),
    );

    gradient = LinearGradient(
      colors: <Color>[
        Colors.red.withOpacity(0.9),
        const Color.fromRGBO(255, 128, 16, 1).withOpacity(0.3),
      ],
      stops: const [
        0.3,
        1.0,
      ],
    );
    Paint fourthOvalPaint = Paint()
      ..color = Colors.deepOrange
      ..shader = gradient.createShader(fourthOvalRect);

    canvas.drawOval(fourthOvalRect, fourthOvalPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}