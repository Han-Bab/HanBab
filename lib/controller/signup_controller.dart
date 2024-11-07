import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:han_bab/color_schemes.dart';
import 'package:han_bab/widget/encryption.dart';

import '../view/app.dart';
import '../widget/alert.dart';
import '../widget/config.dart';
import '../widget/emailVerificationAlertModal.dart';
import '../widget/flutterToast.dart';

class SignupController with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  bool passwordValidation() {
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

  bool emailValidation() {
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
  String _account = '';

  String get name => _name;

  String get phone => _phone;

  String get account => _account;

  void setName(String value) {
    _name = value;
    notifyListeners();
  }

  void setPhone(String value) {
    _phone = value;
    notifyListeners();
  }

  void setAccount(String value) {
    _account = value;
    notifyListeners();
  }

  String _encryptAccount = '';

  String get encryptAccount => _encryptAccount;

  void setEncryptAccount(String value) {
    // 계좌번호 암호화
    if (value == "") {
      _encryptAccount = "0000000000000000";
    } else {
      final encrypted = encrypt(aesKey, value);
      _encryptAccount = encrypted.base16;
    }
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
    notifyListeners();
    if (option1Selected == false || option2Selected == false) {
      return false;
    }
    return true;
  }

  void printAll() {
    if (kDebugMode) {
      print('email: $email');
      print('password: $password');
      print('name: $name');
      print('phone: $phone');
      print('account: $encryptAccount');
    }
  }

  Future<void> addInfo() async {
    try {
      final user = _auth.currentUser;
      setEncryptAccount(_account);
      String? token;
      if(user != null) {
        token = await FirebaseMessaging.instance.getToken();
      }

      await _firestore.collection('user').doc(user!.uid).set({
        'email': _email,
        'name': _name,
        'phone': _phone,
        'groups': [],
        'uid': user.uid,
        'kakaoLink': false,
        'tossLink': false,
        'bankAccount': _encryptAccount,
        'currentGroup': "",
        'kakaopay': "",
        'tossId': "",
        'token': token
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    notifyListeners();
  }

  Future<void> register(context) async {
    try {
      // Firebase Authentication을 사용하여 사용자 생성
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      User? user = userCredential.user;

      // 이메일 인증 보내기
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();


        // 알림 표시
        showDialog(
          barrierDismissible: false,
          context: context, // context를 전달해야 함
          builder: (context) => Emailverificationalertmodal(
            text: '인증 이메일이 전송되었습니다.\n이메일을 확인해 인증을 완료하세요.',
            yesOrNo: false,
            function: () {
              Navigator.of(context).pop(); // 모달 닫기
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const App()),
                    (route) => false, // 모든 이전 루트를 제거하여 새로운 페이지로 이동합니다
              );
            },
          ),
        );
      }

      // Firebase Realtime Database나 Firestore에 추가 정보 저장
      await addInfo();

      // 인증이 완료되지 않았을 때 경고
      if (!user!.emailVerified) {
        throw FirebaseAuthException(
          code: 'email-not-verified',
          message: '이메일 인증이 완료되지 않았습니다.',
        );
      }

    } catch (e) {
      if (e is FirebaseAuthException && e.code == 'email-not-verified') {
        print('이메일 인증이 필요합니다.');
      } else {
        print('에러 발생: $e');
      }
    }

    notifyListeners();
  }


  bool verified = false;
  bool verifying = false;
  bool failCode = false;
  bool pressEnter = false;
  String verifyId = "";

  void verify() {
    verified = true;
    notifyListeners();
  }

  void fail() {
    failCode = true;
    notifyListeners();
  }


  void reset() {
    verified = false;
    failCode = false;
    pressEnter = false;
    notifyListeners();
  }

  void pEnter() {
    pressEnter = true;
    notifyListeners();
  }

  void clickVerify() {
    verifying = true;
    notifyListeners();
  }

  /// All STEPS
  Future<void> clearAll() async {
    setEmail("");
    setPassword("");
    setPasswordConfirm("");
    _emailErrorText = null;
    _passwordErrorText = null;
    _passwordConfirmErrorText = null;
    pressEnter = false;
    _allSelected = false;
    _option1Selected = false;
    _option2Selected = false;
    notifyListeners();
  }

  Future<bool> checkEmailDuplicate(String email) async {
    print(email);
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('user')
          .where('email', isEqualTo: email)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking email duplicate: $e');
      return true; // 에러 발생 시 중복으로 처리
    }
  }
}
