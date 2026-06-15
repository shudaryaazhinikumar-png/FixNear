import 'package:cloud_firestore/cloud_firestore.dart';

class LocationService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> updateLocation({
    required String bookingId,
    required double providerLat,
    required double providerLng,
    required double customerLat,
    required double customerLng,
  }) async {
    await _db.collection("live_tracking").doc(bookingId).set({
      "providerLat": providerLat,
      "providerLng": providerLng,
      "customerLat": customerLat,
      "customerLng": customerLng,
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  static Stream getTracking(String bookingId) {
    return _db.collection("live_tracking").doc(bookingId).snapshots();
  }
}