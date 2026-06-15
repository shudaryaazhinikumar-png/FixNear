import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ================= REGISTER =================
  static Future<void> registerUser({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String role,
  }) async {
    try {
      UserCredential userCred =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _db.collection("users").doc(userCred.user!.uid).set({
        "name": name,
        "phone": phone,
        "role": role,
        "uid": userCred.user!.uid,
        "createdAt": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception("Registration failed: $e");
    }
  }
  static Future<Map<String, dynamic>?> getUserData() async {
  final user = _auth.currentUser;
  if (user == null) return null;

  DocumentSnapshot doc =
      await _db.collection("users").doc(user.uid).get();

  if (!doc.exists) return null;

  return doc.data() as Map<String, dynamic>;
}
  // ================= LOGIN =================
  static Future<String?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCred =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot doc =
          await _db.collection("users").doc(userCred.user!.uid).get();

      if (!doc.exists) return null;

      final data = doc.data() as Map<String, dynamic>;
      return data["role"];
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }

  // ================= GET ROLE =================
  static Future<String?> getRole() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    DocumentSnapshot doc =
        await _db.collection("users").doc(user.uid).get();

    if (!doc.exists) return null;

    final data = doc.data() as Map<String, dynamic>;
    return data["role"];
  }

  // ================= CHECK LOGIN =================
  static bool isLoggedIn() {
    return _auth.currentUser != null;
  }

  // ================= LOGOUT =================
  static Future<void> logout() async {
    await _auth.signOut();
  }
}