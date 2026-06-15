import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> addPayment({
    required String bookingId,
    required String method,
  }) async {
    await _db.collection("payments").add({
      "bookingId": bookingId,
      "method": method,
      "status": "pending",
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  static Future<void> verifyPayment(String paymentId) async {
    await _db.collection("payments").doc(paymentId).update({
      "status": "verified",
    });
  }
}