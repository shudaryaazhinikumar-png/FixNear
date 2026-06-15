import 'package:cloud_firestore/cloud_firestore.dart';

class BookingService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // -----------------------------------
  // CREATE BOOKING (CUSTOMER SIDE)
  // -----------------------------------
  static Future<String> createBooking({
    required String customerId,
    required String customerName,
    required String customerPhone,
    required String providerId,
    required String category,
    required String issue,
    String address = "",
  }) async {
    DocumentReference doc = await _db.collection("bookings").add({
      "customerId": customerId,
      "customerName": customerName,
      "customerPhone": customerPhone,

      // IMPORTANT: MUST BE UID (not name)
      "providerId": providerId,

      "category": category,
      "issue": issue,
      "address": address,

      // STATUS FLOW
      "status": "pending", // pending → accepted → completed

      // PAYMENT FLOW
      "paymentStatus": "pending",

      "createdAt": FieldValue.serverTimestamp(),
    });

    return doc.id;
  }

  // -----------------------------------
  // GET BOOKINGS FOR PROVIDER (LIVE)
  // -----------------------------------
  static Stream<QuerySnapshot> getProviderBookings(String providerId) {
    return _db
        .collection("bookings")
        .where("providerId", isEqualTo: providerId)
        .snapshots();
  }

  // -----------------------------------
  // SERVICES TO ATTEND (PENDING)
  // -----------------------------------
  static Stream<QuerySnapshot> getPendingBookings(String providerId) {
    return _db
        .collection("bookings")
        .where("providerId", isEqualTo: providerId)
        .where("status", isEqualTo: "pending")
        .snapshots();
  }

  // -----------------------------------
  // ACCEPT BOOKING
  // -----------------------------------
  static Future<void> acceptBooking(String bookingId, String providerId) async {
    await _db.collection("bookings").doc(bookingId).update({
      "status": "accepted",
      "providerId": providerId, // ensure correct mapping
    });
  }

  // -----------------------------------
  // COMPLETE BOOKING
  // -----------------------------------
  static Future<void> completeBooking(String bookingId) async {
    await _db.collection("bookings").doc(bookingId).update({
      "status": "completed",
      "completedAt": FieldValue.serverTimestamp(),
    });
  }

  // -----------------------------------
  // GET COMPLETED BOOKINGS
  // -----------------------------------
  static Stream<QuerySnapshot> getCompletedBookings(String providerId) {
    return _db
        .collection("bookings")
        .where("providerId", isEqualTo: providerId)
        .where("status", isEqualTo: "completed")
        .snapshots();
  }

  // -----------------------------------
  // ADMIN - ALL BOOKINGS
  // -----------------------------------
  static Stream<QuerySnapshot> getAllBookings() {
    return _db.collection("bookings").snapshots();
  }
}