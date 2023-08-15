import 'package:flutter/material.dart';

class LoginController with ChangeNotifier {
  /// FocusNode
  FocusNode emailFocus = FocusNode();
  FocusNode pwFocus = FocusNode();
  FocusNode pwConfirmFocus = FocusNode();

  /// STEP 1
  String _email = "";
  String _password = "";
  String _passwordConfirm = "";

  String get email => _email;
  String get password => _password;
  String get passwordConfirm => _passwordConfirm;

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  void setPasswordConfirm(String value) {
    _passwordConfirm = value;
    notifyListeners();
  }

  /// STEP 2
  String _name = '';
  String _phone = '';

  String get name => _name;
  String get phone => _phone;

  void setName(String value) {
    _name = value;
    notifyListeners();
  }

  void setPhone(String value) {
    _phone = value;
    notifyListeners();
  }

  String _encryptAccount = '';

  String get encryptAccount => _encryptAccount;

  void setEncryptAccount(String value) {
    _encryptAccount = value;
    notifyListeners();
  }

  /// STEP 3
  bool _allSelected = false;
  bool _option1Selected = false;
  bool _option2Selected = false;

  bool get allSelected => _allSelected;
  bool get option1Selected => _option1Selected;
  bool get option2Selected => _option2Selected;

  void setAllSelected(bool value) {
    _allSelected = value;
    _option1Selected = value;
    _option2Selected = value;
    notifyListeners();
  }

  void setOption1Selected(bool value) {
    _option1Selected = value;
    notifyListeners();
  }

  void setOption2Selected(bool value) {
    _option2Selected = value;
    notifyListeners();
  }

  // STEP3 유효성 검사
  bool step3Validation() {
    // 약관 검증 로직
    if (option1Selected == false || option2Selected == false) {
      return false;
    }
    return true;
  }
}
