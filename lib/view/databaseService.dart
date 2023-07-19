import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> getImage(String name) async {
    try {
      DocumentSnapshot documentSnapshot = await firestore
          .collection('restaurants')
          .doc(name)
          .get();

      Map<String, dynamic> data =
      documentSnapshot.data() as Map<String, dynamic>;
      int index = data['index'];

      print("인덱스 값: $index");
    } catch (e) {
      print("오류 발생: $e");
    }
  }
}
