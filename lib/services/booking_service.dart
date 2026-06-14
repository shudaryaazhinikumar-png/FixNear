import 'package:cloud_firestore/cloud_firestore.dart';

class BookingService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ================= CREATE BOOKING =================
  static Future<void> createBooking({
    required String customerId,
    required String category,
    required String issue,
  }) async {
    await _db.collection("services").add({
      "customerId": customerId,
      "providerId": "",
      "category": category,
      "issue": issue,
      "status": "pending",
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  // ================= GET ALL BOOKINGS =================
  static Stream<QuerySnapshot> getBookings() {
    return _db.collection("services").snapshots();
  }

  // ================= UPDATE STATUS =================
  static Future<void> updateStatus(
      String bookingId, String status) async {
    await _db.collection("services").doc(bookingId).update({
      "status": status,
    });
  }
}