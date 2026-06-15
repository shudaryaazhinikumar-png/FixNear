import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProviderService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // -------------------------------
  // GET CURRENT UID SAFELY
  // -------------------------------
  static String? get uid => FirebaseAuth.instance.currentUser?.uid;

  static bool get isLoggedIn => FirebaseAuth.instance.currentUser != null;

  // -------------------------------
  // SAVE / UPDATE PROVIDER PROFILE
  // -------------------------------
  static Future<void> saveProviderProfile({
    required String name,
    required String phone,
    required String profession,
    required String experience,
  }) async {
    if (!isLoggedIn) return;

    await _db.collection("providers").doc(uid).set({
      "uid": uid,
      "name": name,
      "phone": phone,
      "profession": profession,
      "experience": experience,
      "isAvailable": true,
      "createdAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // -------------------------------
  // GET SINGLE PROVIDER PROFILE
  // -------------------------------
  static Stream<DocumentSnapshot> getProviderProfile() {
    if (!isLoggedIn) {
      return const Stream.empty();
    }

    return _db.collection("providers").doc(uid).snapshots();
  }

  // -------------------------------
  // ALL BOOKINGS (LIVE)
  // -------------------------------
  static Stream<QuerySnapshot> getProviderBookings() {
    if (!isLoggedIn) return const Stream.empty();

    return _db
        .collection("bookings")
        .where("providerId", isEqualTo: uid)
        .snapshots();
  }

  // -------------------------------
  // SERVICES TO ATTEND (PENDING)
  // -------------------------------
  static Stream<QuerySnapshot> getServicesToAttend() {
    if (!isLoggedIn) return const Stream.empty();

    return _db
        .collection("bookings")
        .where("providerId", isEqualTo: uid)
        .where("status", isEqualTo: "pending")
        .snapshots();
  }

  // -------------------------------
  // COMPLETED SERVICES
  // -------------------------------
  static Stream<QuerySnapshot> getCompletedServices() {
    if (!isLoggedIn) return const Stream.empty();

    return _db
        .collection("bookings")
        .where("providerId", isEqualTo: uid)
        .where("status", isEqualTo: "completed")
        .snapshots();
  }

  // -------------------------------
  // ALL PROVIDERS (ADMIN VIEW)
  // -------------------------------
  static Stream<QuerySnapshot> getAllProviders() {
    return _db.collection("providers").snapshots();
  }

  // -------------------------------
  // ACCEPT BOOKING
  // -------------------------------
  static Future<void> acceptBooking(String bookingId) async {
    await _db.collection("bookings").doc(bookingId).update({
      "status": "accepted",
      "acceptedAt": FieldValue.serverTimestamp(),
    });
  }

  // -------------------------------
  // COMPLETE BOOKING
  // -------------------------------
  static Future<void> completeBooking(String bookingId) async {
    await _db.collection("bookings").doc(bookingId).update({
      "status": "completed",
      "completedAt": FieldValue.serverTimestamp(),
    });
  }

  // -------------------------------
  // UPDATE AVAILABILITY
  // -------------------------------
  static Future<void> updateAvailability(bool status) async {
    if (!isLoggedIn) return;

    await _db.collection("providers").doc(uid).update({
      "isAvailable": status,
    });
  }

  // -------------------------------
  // LIVE LOCATION UPDATE
  // -------------------------------
  static Future<void> updateLocation({
    required String bookingId,
    required double lat,
    required double lng,
  }) async {
    await _db.collection("live_tracking").doc(bookingId).set({
      "providerId": uid,
      "providerLat": lat,
      "providerLng": lng,
      "updatedAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}