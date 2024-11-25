import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:han_bab/widget/alert.dart';
import 'package:han_bab/widget/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../view/page2/home/home.dart';
import '../widget/encryption.dart';

class DatabaseService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  Reference get firebaseStorage => FirebaseStorage.instance.ref();

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("user");
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");

  final uid = FirebaseAuth.instance.currentUser?.uid;


  Future<String> getUserName() async {
    DocumentReference d = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['name'];
  }

  Future<String> getToken(String userId) async {
    DocumentReference d = userCollection.doc(userId);
    DocumentSnapshot documentSnapshot = await d.get();
    // print(userId);
    return documentSnapshot['token'];
  }

  // getting the chats
  getChats(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time", descending: true)
        .snapshots();
  }

  Future getGroupAdmin(String groupId) async {
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }

  // get group members
  getGroupMembers(groupId) async {
    return groupCollection.doc(groupId).snapshots();
  }

  // 토큰 저장
  Future<void> saveToken(String groupId, String token) async {
    final prefs = await SharedPreferences.getInstance();

    // 기존 토큰 리스트 가져오기
    List<String> tokens = await getTokens(groupId);

    // 새 토큰 추가 (중복 방지)
    if (!tokens.contains(token)) {
      tokens.add(token);
    }

    // 리스트를 JSON 문자열로 저장
    await prefs.setString(groupId, jsonEncode(tokens));
  }

  // 토큰 삭제
  Future<void> deleteToken(String groupId, String token) async {
    final prefs = await SharedPreferences.getInstance();

    // 기존 토큰 리스트 가져오기
    List<String> tokens = await getTokens(groupId);

    // 토큰 제거
    tokens.remove(token);

    // 업데이트된 리스트를 JSON 문자열로 저장
    await prefs.setString(groupId, jsonEncode(tokens));
  }

  // groupId 키 삭제
  Future<void> deleteGroup(String groupId) async {
    final prefs = await SharedPreferences.getInstance();

    // groupId 키 삭제
    if (prefs.containsKey(groupId)) {
      await prefs.remove(groupId);
    }
  }


  // 토큰 가져오기
  Future<List<String>> getTokens(String groupId) async {
    final prefs = await SharedPreferences.getInstance();

    // 저장된 JSON 문자열을 리스트로 변환
    String? tokensJson = prefs.getString(groupId);
    if (tokensJson != null) {
      return List<String>.from(jsonDecode(tokensJson));
    }
    return [];
  }

  Future<void> enterChattingRoom(
      String groupId, String userName, String groupName) async {

    // 1. Token 생성 및 저장
    String token = await getToken(uid!);

    // 2. Firestore의 그룹 문서 참조
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);

    // 3. Firestore 업데이트
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "tokens": FieldValue.arrayUnion([token])
    });

    // 4. Firestore의 사용자 문서 참조
    DocumentReference userDocumentReference = userCollection.doc(uid);
    await userDocumentReference.update({
      "groups": FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
    });

    // 5. Firestore에서 tokens 필드 값 가져오기
    DocumentSnapshot groupSnapshot = await groupDocumentReference.get();

    // DocumentSnapshot의 data를 Map으로 캐스팅
    Map<String, dynamic>? groupData = groupSnapshot.data() as Map<String, dynamic>?;

    if (groupData != null) {
      List<dynamic>? tokens = groupData['tokens'];

      if (tokens != null) {
        // 6. 모든 tokens 값을 로컬 스토리지에 저장
        for (String tok in tokens) {
          await saveToken(groupId, tok);
        }
      }
    }
  }

  // send message
  sendMessage(String groupId,String groupName, Map<String, dynamic> chatMessageData) async {
    groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    groupCollection.doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
      "recentMessageSenderId": uid
    });

    await FlutterLocalNotification()
        .postMessage(groupId, groupName, chatMessageData['sender'], chatMessageData['message']);

  }

  // toggling the group join/exit
  Future exitGroup(
      String groupId, String userName, String groupName, String admin) async {
    // doc reference
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await groupDocumentReference.get();
    List<dynamic> members = await documentSnapshot['members'];

    await userDocumentReference.update({
      "groups": FieldValue.arrayRemove(["${groupId}_$groupName"]),
      "currentGroup": ""
    });
    await groupDocumentReference.update({
      "members": FieldValue.arrayRemove(["${uid}_$userName"])
    }).then((value) {
      if (members.length > 1 && admin.contains(userName)) {
        groupDocumentReference.update({"admin": members[1]});
      }
    });
  }

  Future<void> deleteRestaurantDocument(String groupId) async {
    if (groupId.isNotEmpty) {
      QuerySnapshot collectionsSnapshot =
          await groupCollection.doc(groupId).collection('messages').get();
      for (DocumentSnapshot collectionDoc in collectionsSnapshot.docs) {
        await collectionDoc.reference.delete();
      }
      return groupCollection.doc(groupId).delete();
    }
  }

  Future<void> modifyGroupInfo(String groupId, String name, String date, String time,
      String place, String people) async {
    DocumentReference dr = groupCollection.doc(groupId);
    dr.update({
      'groupName': name,
      'date': date,
      'orderTime': time,
      'pickup': place,
      'maxPeople': people
    });
  }

  Future<DocumentSnapshot<Object?>> getUserInfo(String uid) async {
    DocumentSnapshot dr = await userCollection.doc(uid).get();
    return dr;
  }

  Future<void> modifyUserInfo(
      String name, String email, String phone, String account) async {
    DocumentReference dr = userCollection.doc(uid);
    final encrypted = encrypt(aesKey, account);
    String encryptAccount = encrypted.base16;
    dr.update({
      'name': name,
      'email': email,
      'phone': phone,
      'bankAccount': encryptAccount
    });
  }

  void saveSocialAccount(String text, bool kakao) {
    DocumentReference dr = userCollection.doc(uid);
    if (kakao) {
      dr.update({'kakaoLink': true, 'kakaopay': text});
    } else {
      dr.update({'tossLink': true, 'tossId': text});
    }
  }

  Future<bool> enterOnlyOneRest(
      context, String groupName, String groupId) async {
    DocumentReference dr = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await dr.get();
    String currentGroup = documentSnapshot['currentGroup'];
    String gid = "";
    if (currentGroup != "") {
      gid = currentGroup.substring(currentGroup.indexOf("_") + 1,
          currentGroup.indexOf("_", currentGroup.indexOf("_", 1) + 1));
    }
    if (currentGroup.toString() != "" && gid != groupId) {
      showDialog(
        context: context,
        barrierDismissible: true, //바깥 영역 터치시 닫을지 여부 결정
        builder: ((context) {
          return AlertModal(
            text: '이미 다른 방에 들어가 있습니다!\n퇴장 후 들어가주세요.',
            yesOrNo: false,
            function: () {},
          );
        }),
      );
      return false;
    }
    return true;
  }

  getCurrentRest() async {
    DocumentReference d = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await d.get();
    String currentGroup = documentSnapshot['currentGroup'];
    String groupId = currentGroup.substring(currentGroup.indexOf("_") + 1,
        currentGroup.indexOf("_", currentGroup.indexOf("_", 1) + 1));
    DocumentSnapshot dr = await groupCollection.doc(groupId).get();
    return dr;
  }

  setReset(date, groupId, groupName) {
    DocumentReference dr = userCollection.doc(uid);
    String currentGroup = date + "_" + groupId + "_" + groupName;
    dr.update({
      "currentGroup": currentGroup,
    });
  }

  Future<String> getRest() async {
    DocumentReference d = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['currentGroup'];
  }

  void resetRest(String id) {
    DocumentReference dr = userCollection.doc(id);
    dr.update({
      "currentGroup": "",
    });
  }

  void setDeliveryTip(String groupId, int value) {
    DocumentReference dr = groupCollection.doc(groupId);
    dr.update({
      "deliveryTip": value,
    });
  }

  Future sendFeedback(
      String sender, String target, String title, String content) async {
    await FirebaseFirestore.instance.collection("feedback").add({
      "sender": sender,
      "target": target,
      "title": title,
      "content": content
    });
  }

  Future<void> closeRoom(groupId, double num) async {
    DocumentReference dr = groupCollection.doc(groupId);
    dr.update({
      "close": num,
    });
  }
}
