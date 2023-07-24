import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  final CollectionReference userCollection =
  FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection =
  FirebaseFirestore.instance.collection("groups");

  final uid = FirebaseAuth.instance.currentUser?.uid;

  Future<String> getImage(String name) async {
    if(name == "") return "start";
    try {
      DocumentSnapshot documentSnapshot = await firestore
          .collection('restaurants')
          .doc(name)
          .get();

      Map<String, dynamic> data =
      documentSnapshot.data() as Map<String, dynamic>;
      int index = data['index'];

      // Firebase Storage에서 이미지 가져오기
      Reference reference = storage.ref('$index.jpg');
      String imageUrl = await reference.getDownloadURL();

      return imageUrl;
    } catch (e) {
      return "null";
    }
  }

  // creating a group
  Future createGroup(String userName, String id, String groupName) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName": groupName,
      "admin": "${id}_$userName",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });
    // update the members
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "groupId": groupDocumentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "groups":
      FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
    });
  }
}
