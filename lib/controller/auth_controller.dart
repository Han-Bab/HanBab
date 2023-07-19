import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {
  final _user = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

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
    await _user.signOut();
  }
}
