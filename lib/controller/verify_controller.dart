import 'package:flutter/material.dart';

class VerifyController with ChangeNotifier {
  bool _isEmailVerified = false;
  bool _canResendEmail = true;

  bool get isEmailVerified => _isEmailVerified;
  bool get canResendEmail => _canResendEmail;

  void setEmailVerified(bool value) {
    _isEmailVerified = value;
    notifyListeners();
  }

  void setCanResendEmail(bool value) {
    _canResendEmail = value;
    notifyListeners();
  }
}
