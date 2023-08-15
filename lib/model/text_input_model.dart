import 'package:flutter/material.dart';

class TextInputModel with ChangeNotifier {
  final TextEditingController _textEditingController = TextEditingController();
  String encrypt = '';
  String decrypt = '';

  TextEditingController get textEditingController => _textEditingController;

  void disposeInputField() {
    _textEditingController.dispose();
  }
}
