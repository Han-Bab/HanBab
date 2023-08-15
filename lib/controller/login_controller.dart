import 'package:flutter/material.dart';
import 'package:han_bab/widget/encryption.dart';

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

  // STEP1 유효성 검사
  String? _emailErrorText;
  String? _passwordErrorText;
  String? _passwordConfirmErrorText;

  String? get emailErrorText => _emailErrorText;
  String? get passwordErrorText => _passwordErrorText;
  String? get passwordConfirmErrorText => _passwordConfirmErrorText;

  bool emailValidation() {
    bool isValid = true;
    // 8자리 이상의 영문(대/소문자) + 숫자 + 특수문자 조합
    String pattern = r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}$';
    RegExp regex = RegExp(pattern);

    if (_password.isEmpty) {
      _passwordErrorText = '비밀번호를 작성해주세요';
      isValid = false;
    } else if (!regex.hasMatch(_password)) {
      _passwordErrorText = '비밀번호를 규칙에 맞게 설정해주세요';
      isValid = false;
    } else {
      _passwordErrorText = null;
    }
    notifyListeners();
    return isValid;
  }

  bool passwordValidation() {
    bool isValid = true;
    if (_email.isEmpty) {
      _emailErrorText = '이메일을 작성해주세요';
      isValid = false;
    } else if (!_email.contains('@') || !_email.contains('.')) {
      _emailErrorText = '이메일 형식을 올바르게 작성해주세요';
      isValid = false;
    } else {
      _emailErrorText = null;
    }
    notifyListeners();
    return isValid;
  }

  bool passwordConfirmValidation() {
    bool isValid = true;
    if (_passwordConfirm != _password) {
      _passwordConfirmErrorText = '비밀번호가 동일하지 않습니다';
      isValid = false;
    } else {
      _passwordConfirmErrorText = null;
    }
    notifyListeners();
    return isValid;
  }

  bool step1Validation() {
    bool email = emailValidation();
    bool password = passwordValidation();
    bool passwordConfirm = passwordConfirmValidation();
    if (email && password && passwordConfirm) {
      notifyListeners();
      return true;
    } else {
      notifyListeners();
      return false;
    }
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
    // 계좌번호 암호화
    _encryptAccount = AccountEncryption.encryptWithAESKey(value);
    notifyListeners();
  }

  String? _nameErrorText;
  String? _phoneErrorText;

  String? get nameErrorText => _nameErrorText;
  String? get phoneErrorText => _phoneErrorText;

  bool nameValidation() {
    bool isValid = true;
    if (_name.isEmpty) {
      _nameErrorText = '이름을 입력해주세요';
      isValid = false;
    } else {
      _nameErrorText = null;
    }
    notifyListeners();
    return isValid;
  }

  bool phoneValidation() {
    bool isValid = true;
    if (_phone.isEmpty) {
      _phoneErrorText = '전화번호를 입력해주세요';
      isValid = false;
    } else if (_phone.length != 13 || !_phone.startsWith('010')) {
      _phoneErrorText = '전화번호 형식을 다시 확인해주세요';
      isValid = false;
    } else {
      _phoneErrorText = null;
    }
    notifyListeners();
    return isValid;
  }

  bool step2Validation() {
    bool name = nameValidation();
    bool phone = phoneValidation();

    if (name && phone) {
      notifyListeners();
      return true;
    } else {
      notifyListeners();
      return false;
    }
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
  bool optionsValidation() {
    // 약관 검증 로직
    if (option1Selected == false || option2Selected == false) {
      return false;
    }
    return true;
  }

  void printAll() {
    print('email: $email');
    print('password: $password');
    print('name: $name');
    print('phone: $phone');
    print('account: $encryptAccount');
  }
}
