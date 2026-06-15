import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> createCustomerUser({
    required String uid,
    required String name,
    required String phone,
  }) async {
    await _firestore.collection("users").doc(uid).set({
      "name": name,
      "phone": phone,
      "role": "customer",
      "createdAt": FieldValue.serverTimestamp(),
    });
  }
}