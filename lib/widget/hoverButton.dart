import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HoverButton extends StatefulWidget {
  const HoverButton({Key? key, required this.title, required this.function}) : super(key: key);

  final Widget title;
  final Function function;

  @override
  _HoverButtonState createState() => _HoverButtonState();
}

class _HoverButtonState extends State<HoverButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 50),
        lowerBound: 0.0,
        upperBound: 0.05,
        vsync: this)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    double scale = 1 - _animationController.value;

    return GestureDetector(
      onTapDown: (details) {
        _animationController.forward();
      },
      onTapUp: (details) {
        _animationController.reverse();
        widget.function();
      },
      onTapCancel: () => _animationController.reverse(),
      child: Transform.scale(
        scale: scale,
        child: Center(
            child: widget.title),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
