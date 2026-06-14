import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProviderDashboard extends StatefulWidget {
  const ProviderDashboard({super.key});

  @override
  State<ProviderDashboard> createState() => _ProviderDashboardState();
}

class _ProviderDashboardState extends State<ProviderDashboard> {
  int page = 1;

  String name = "";
  String phone = "";
  String qualification = "";
  String experience = "";
  String bookingId = "booking_123";

  static const Color seaGreen = Color(0xFF2E8B80);
  static const Color lightSeaGreen = Color(0xFFBEE7E1);
  static const Color mintBackground = Color(0xFFF2FBF9);

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      name = prefs.getString("provider_name") ?? "Provider";
      phone = prefs.getString("provider_phone") ?? "";
      qualification = prefs.getString("provider_qual") ?? "";
      experience = prefs.getString("provider_exp") ?? "";
    });
  }
  void startSendingLocation() async {
  LocationPermission permission = await Geolocator.requestPermission();

  if (permission == LocationPermission.denied) return;

  Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5,
    ),
  ).listen((Position position) {
    FirebaseFirestore.instance
        .collection("live_tracking")
        .doc(bookingId)
        .set({
      "providerLat": position.latitude,
      "providerLng": position.longitude,
      "customerLat": 11.0160, // optional static or fetch from booking
      "customerLng": 76.9550,
    });
  });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mintBackground,
      appBar: AppBar(
        title: const Text('Service Provider'),
        backgroundColor: seaGreen,
      ),
      body: page == 1 ? dashboardPage() : profilePage(),
    );
  }

  Widget dashboardPage() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Card(
          color: lightSeaGreen,
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: seaGreen,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(name),
            subtitle: Text('$qualification • $experience years'),
          ),
        ),

        dashboardTile('My Profile', Icons.person, () {
          setState(() => page = 2);
        }),

        dashboardTile('Services Completed', Icons.check_circle, () {}),
        dashboardTile('Services To Attend', Icons.notifications, () {}),
        dashboardTile('Other Service Providers', Icons.groups, () {}),
      ],
    );
  }

  Widget dashboardTile(String title, IconData icon, VoidCallback onTap) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: seaGreen),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  Widget profilePage() {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundColor: seaGreen,
                child: Icon(Icons.person, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 20),
              Text("Name: $name"),
              Text("Phone: $phone"),
              Text("Qualification: $qualification"),
              Text("Experience: $experience years"),
              const SizedBox(height: 20),
              ElevatedButton(
  style: ElevatedButton.styleFrom(backgroundColor: seaGreen),
  onPressed: () {
    // 🔥 GO BACK TO PREVIOUS PAGE
    setState(() => page = 1);
  },
  child: const Text(
    "Back",
    style: TextStyle(color: Colors.white),
  ),
),
            ],
          ),
        ),
      ),
    );
  }
}