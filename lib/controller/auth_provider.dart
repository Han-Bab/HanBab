import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:han_bab/controller/navigation_controller.dart';
import 'package:han_bab/view/app.dart';

import '../widget/config.dart';

class AuthProvider extends ChangeNotifier {
  final _user = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String _loginEmail = '';
  String _loginPassword = '';

  String get loginEmail => _loginEmail;
  String get loginPassword => _loginPassword;

  void setLoginEmail(String value) {
    _loginEmail = value;
    notifyListeners();
  }

  void setLoginPassword(String value) {
    _loginPassword = value;
    notifyListeners();
  }

  Future<User?> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final UserCredential userCredential =
        await _user.signInWithCredential(credential);
    final User? user = userCredential.user;

    if (user != null) {
      print('Google Login Success: $user');
      await addUserInfo();
      return user;
    } else {
      print('Google Login Fail: No User Found');
      return null;
    }
  }

  Future<bool> login(BuildContext context) async {
    try {
      await _user.signInWithEmailAndPassword(
        email: _loginEmail,
        password: _loginPassword,
      );
      notifyListeners();
      if (_user.currentUser != null) {
        print('로그인 성공');
        return true;
      } else {
        print('로그인 실패');
        return false;
      }
    } catch (e) {
      FToast().init(context);
      if (e.toString().contains('user-not-found')) {
        print('유저 정보를 찾을 수 없습니다.\n아이디를 다시 한번 확인해주세요!');
        FToast().showToast(
          child: toastTemplate('유저 정보를 찾을 수 없습니다!', Icons.cancel,
              Theme.of(context).primaryColor),
          gravity: ToastGravity.CENTER,
        );
      } else if (e.toString().contains('wrong-password')) {
        print('비밀번호를 잘못 입력하셨습니다.\n비밀번호를 다시 한번 확인해주세요!');
        FToast().showToast(
          child: toastTemplate('비밀번호를 잘못 입력하셨습니다!', Icons.cancel,
              Theme.of(context).primaryColor),
          gravity: ToastGravity.CENTER,
        );
      } else if (e.toString().contains('invalid-email')) {
        print('잘못된 이메일 형식입니다.');
        FToast().showToast(
          child: toastTemplate('올바르지 않은 이메일 형식입니다!', Icons.cancel,
              Theme.of(context).primaryColor),
          gravity: ToastGravity.CENTER,
        );
      } else {
        FToast().showToast(
          child: toastTemplate(
              '로그인에 실패하셨습니다!', Icons.cancel, Theme.of(context).primaryColor),
          gravity: ToastGravity.CENTER,
        );
      }

      return false;
    }
  }

  dynamic verifyCheck(BuildContext context) {
    if (_user.currentUser != null) {
      if (!_user.currentUser!.emailVerified) {
        Navigator.pushNamedAndRemoveUntil(context, '/verify', (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => const App()), // MyApp 를 메인 페이지로 교체해 주세요.
          (route) => false, // 모든 이전 루트를 제거하여 새로운 페이지로 이동합니다
        );
      }
    } else {
      print('no user data..');
    }
  }

  Future<bool> doesDocumentExist(String uid) async {
    final docSnapshot = await _firestore.collection('user').doc(uid).get();

    return docSnapshot.exists;
  }

  Future<void> addUserInfo() async {
    bool isDocExist = await doesDocumentExist(_user.currentUser!.uid);
    if (!isDocExist) {
      _firestore.collection('user').doc(_user.currentUser!.uid).set({
        'email': _user.currentUser!.email,
        'name': _user.currentUser!.displayName,
        'uid': _user.currentUser!.uid,
        'phone': '010-0000-0000',
        'groups': [],
        'kakaoLink': false,
        'tossLink': false,
      });
    }
  }

  Future<void> logout() async {
    print(NavigationController().selectedIndex);
    await _user.signOut();
  }
}
