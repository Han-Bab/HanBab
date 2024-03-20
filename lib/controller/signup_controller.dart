import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:han_bab/color_schemes.dart';
import 'package:han_bab/widget/encryption.dart';

import '../widget/config.dart';
import '../widget/flutterToast.dart';

class SignupController with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String smsCode = '';

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

  void addInfo() async {
    try {
      final user = _auth.currentUser;
      setEncryptAccount(_account);
      print(user);
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
        'tossId': ""
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    notifyListeners();
  }

  Future<void> register() async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      addInfo();
    } catch (e) {
      if (kDebugMode) {
        print(e);
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

  Future<void> verifyPhoneNumber(BuildContext context) async {
    verificationCompleted(PhoneAuthCredential phoneAuthCredential) async {
      await _auth.signInWithCredential(phoneAuthCredential);

      print("Phone number automatically verified and user signed in");
    }

    verificationFailed(FirebaseAuthException authException) {
      print(
          'Phone number verification failed. Code ${authException.code}. Message ${authException.message}');

      FToast().init(context);
      FToast().showToast(
        child: toastTemplate(
          '일일 요청 한도가 넘었습니다. 내일 시도해주세요',
          Icons.error,
          Theme.of(context).primaryColor,
        ),
        gravity: ToastGravity.CENTER,
      );
    }

    codeSent(String verificationId, [int? forceResendingToken]) async {
      verifyId = verificationId;
      notifyListeners();
    }

    codeAutoRetrievalTimeout(String verficationId) {
      FToast().init(context);
      FToast().showToast(
        child: toastTemplate('인증 번호 유효시간이 만료되었습니다.', Icons.timer_off,
            Theme.of(context).primaryColor),
        gravity: ToastGravity.CENTER,
      );
      print('Verification code timed out');
    }

    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: "+82 ${phone.trim().substring(1)}",
          // 첫 번째 문자(0) 제거
          timeout: const Duration(seconds: 60),
          verificationCompleted: verificationCompleted,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
          verificationFailed: verificationFailed);
      clickVerify();
    } catch (e) {
      print("Failed to Verify Phone Number:$e");
    }
  }

  /// All STEPS
  void clearAll() {
    setEmail("");
    setPassword("");
    setPasswordConfirm("");
    _emailErrorText = null;
    _passwordErrorText = null;
    _passwordConfirmErrorText = null;
  }

  Widget verifyCode(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                onChanged: (value) {
                  smsCode = value.trim();
                  reset();
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          width: 0.5,
                          color: verified
                              ? const Color(0xff00A600)
                              : failCode
                                  ? const Color(0xffFF0000)
                                  : const Color(0xffC2C2C2))),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: verified
                              ? const Color(0xff00A600)
                              : failCode
                                  ? const Color(0xffFF0000)
                                  : lightColorScheme.primary)),
                  hintText: "인증코드 입력",
                  hintStyle: const TextStyle(
                      color: Color(0xffC2C2C2),
                      fontSize: 18,
                      fontFamily: "PretendardLight"),
                  contentPadding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                ),
              ),
            ),
            const SizedBox(
              width: 30,
            ),

            verified
                ? const Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Text(
                      "인증성공",
                      style: TextStyle(
                          fontFamily: "PretendardMedium",
                          fontSize: 16,
                          color: Color(0xff00A600)),
                    ),
                  )
                : failCode
                    ? const Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: Text(
                          "인증실패",
                          style: TextStyle(
                              fontFamily: "PretendardMedium",
                              fontSize: 16,
                              color: Color(0xffFF0000)),
                        ),
                      )
                    : pressEnter
                        ? Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: CircularProgressIndicator(
                              color: lightColorScheme.primary,
                            ),
                          )
                        : GestureDetector(
              onTap: () async {
                pEnter();
                try {
                  var credential = PhoneAuthProvider.credential(
                    verificationId: verifyId,
                    smsCode: smsCode,
                  );
                  await _auth.signInWithCredential(credential);

                  print(
                      "Phone number verified and user signed in successfully");
                  verify();
                } catch (e) {
                  if (kDebugMode &&
                      e is FirebaseAuthException &&
                      e.code == 'invalid-verification-code') {
                    fail();
                    print(e.toString());
                  }
                  if (kDebugMode &&
                      e is FirebaseAuthException &&
                      e.code == 'session-expired') {
                    FToast().init(context);
                    FToast().showToast(
                      child: toastTemplate(
                        '시간이 초과되었습니다. 다시 인증요청을 눌러주세요.',
                        Icons.error,
                        Theme.of(context).primaryColor,
                      ),
                      gravity: ToastGravity.CENTER,
                    );
                  }
                  print("Failed to Verify Phone Number:$e");
                }
                FocusScope.of(context).unfocus();
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xffFDB168)),
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(26, 7, 26, 7),
                  child: Text(
                    "확인",
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: "PretendardMedium",
                        color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        const Text(
          "휴대폰으로 전송된 인증코드를 확인해주세요.",
          style: TextStyle(
              fontSize: 12,
              fontFamily: "PretendardMedium",
              color: Color(0xff7D7D7D)),
        )
      ],
    );
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
