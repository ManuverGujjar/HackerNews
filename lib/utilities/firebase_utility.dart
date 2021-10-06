import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseUtility {
  static Future<void> sendMessage(String message) async {
    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    FirebaseFirestore.instance.collection('chat').add({'text': message, 'createdAt': Timestamp.now(), 'userId': user.uid, 'username': userData['username']});
  }
}
