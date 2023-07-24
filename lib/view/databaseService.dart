import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

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


}
