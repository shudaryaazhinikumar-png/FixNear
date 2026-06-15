import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomerDashboard extends StatefulWidget {
  final String? userName;
  final String? phone;
  final String? doorNo;
  final String? street;
  final String? area;
  final String? district;
  final String? state;

  const CustomerDashboard({
    super.key,
    this.userName,
    this.phone,
    this.doorNo,
    this.street,
    this.area,
    this.district,
    this.state,
  });

  @override
  State<CustomerDashboard> createState() => _CustomerDashboardState();
}

class _CustomerDashboardState extends State<CustomerDashboard> {
  final MapController _mapController = MapController();
  int _currentStep = 0;
  String bookingId = "booking_123";
  String? _selectedCategory;
  String? _selectedIssue;
  Map<String, dynamic>? _selectedProvider;

  String _selectedPaymentMethod = 'UPI';


LatLng _providerLatLng = const LatLng(11.0168, 76.9558);
LatLng _customerLatLng = const LatLng(11.0168, 76.9558);
StreamSubscription<Position>? _locationStream;

  static const Color oliveGreen = Color(0xFF556B2F);
  static const Color creamBackground = Color(0xFFFDFBF7);
  static const Color creamCardColor = Color(0xFFFFFDD0);

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Electrical', 'icon': Icons.flash_on},
    {'name': 'Plumbing', 'icon': Icons.water_drop},
    {'name': 'Borewell Services', 'icon': Icons.waves},
    {'name': 'Water Tank', 'icon': Icons.water},
    {'name': 'Public Complaints', 'icon': Icons.report},
  ];

  final Map<String, List<String>> _issuesMap = {
    'Electrical': ['Wiring issue', 'Switch repair', 'Power failure'],
    'Plumbing': ['Leakage', 'Pipe blockage'],
    'Borewell Services': ['Motor repair', 'Pump issue'],
    'Water Tank': ['Motor failure', 'Cleaning'],
    'Public Complaints': ['Water issue', 'Drainage problem'],
  };

  final List<Map<String, dynamic>> _providers = [
    {'name': 'Kumar', 'rating': '4.8', 'distance': '2 km', 'isAvailable': true},
    {'name': 'Ravi', 'rating': '4.5', 'distance': '3 km', 'isAvailable': true},
    {'name': 'Mani', 'rating': '4.9', 'distance': '1.5 km', 'isAvailable': false},
  ];

  // ✅ LIVE TRACKING VARIABLES (ONLY ADDITION)
  double _trackerX = 0;
  double _trackerY = 0;
  Timer? _trackingTimer;

  void _startLiveTracking() {
    _trackerX = 0;
    _trackerY = 0;

    _trackingTimer?.cancel();

    _trackingTimer = Timer.periodic(const Duration(milliseconds: 700), (timer) {
      setState(() {
        _trackerX += 12;
        _trackerY += 7;

        if (_trackerX > 120) _trackerX = 0;
        if (_trackerY > 60) _trackerY = 0;
      });
    });
  }
  void _startUberTracking() {
  FirebaseFirestore.instance
      .collection("live_tracking")
      .doc(bookingId)
      .snapshots()
      .listen((doc) {
    if (!doc.exists) return;

    final data = doc.data()!;

    setState(() {
      _providerLatLng = LatLng(
        data["providerLat"],
        data["providerLng"],
      );

      _customerLatLng = LatLng(
        data["customerLat"],
        data["customerLng"],
      );
    });
    _mapController.move(
  LatLng(
    _providerLatLng.latitude,
    _providerLatLng.longitude,
  ),
  15,
);
    
  });
}
  @override
  void dispose() {
    _trackingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: creamBackground,
      appBar: AppBar(
        title: const Text("FixNear Customer"),
        backgroundColor: oliveGreen,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: _buildStep(),
      ),
    );
  }

  Widget _buildStep() {
    switch (_currentStep) {
      case 0:
        return _profileView();
      case 1:
        return _categoryView();
      case 2:
        return _issueProviderView();
      case 3:
        return _trackingView();
      case 4:
        return _paymentView();
      case 5:
        return _successView();
      default:
        return _profileView();
    }
  }

  // STEP 0
  Widget _profileView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Customer Profile",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),

        Text("Name: ${widget.userName}"),
        Text("Phone: ${widget.phone}"),
        Text("Address: ${widget.doorNo}, ${widget.street}"),
        Text("${widget.area}, ${widget.district}, ${widget.state}"),

        const SizedBox(height: 20),

        ElevatedButton(
          onPressed: () {
            setState(() {
              _currentStep = 1;
            });
          },
          child: const Text("Start Service Booking"),
        ),
      ],
    );
  }

  // STEP 1
  Widget _categoryView() {
    return Column(
      children: [
        const Text("Select Category",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),

        ..._categories.map((cat) {
          return Card(
            child: ListTile(
              leading: Icon(cat['icon']),
              title: Text(cat['name']),
              onTap: () {
                setState(() {
                  _selectedCategory = cat['name'];
                  _selectedIssue = _issuesMap[_selectedCategory!]!.first;
                  _currentStep = 2;
                });
              },
            ),
          );
        }),
      ],
    );
  }

  // STEP 2
  Widget _issueProviderView() {
  final issues = _issuesMap[_selectedCategory!] ?? [];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Category: $_selectedCategory",
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),

      const SizedBox(height: 10),

      DropdownButton<String>(
        value: _selectedIssue,
        isExpanded: true,
        items: issues
            .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ))
            .toList(),
        onChanged: (val) {
          setState(() {
            _selectedIssue = val;
          });
        },
      ),

      const SizedBox(height: 20),

      const Text(
        "Select Provider",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),

      const SizedBox(height: 10),

      ..._providers.map((p) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text(p['name']),
            subtitle: Text("⭐ ${p['rating']} | ${p['distance']}"),

            trailing: p['isAvailable']
                ? ElevatedButton(
                    child: const Text("Book"),

                    onPressed: () async {
                      setState(() {
                        _selectedProvider = p;
                      });

                      final customerId =
                          FirebaseAuth.instance.currentUser?.uid ?? "";

                      // ✅ FIXED: SAFE providerId (NO NULL ERROR)
                      final providerId =
                          p['id'] ?? p['name']; // fallback added

                      // 🔥 CREATE BOOKING
                      DocumentReference doc = await FirebaseFirestore.instance
                          .collection("bookings")
                          .add({
                        "customerId": customerId,
                        "customerName": widget.userName ?? "",
                        "customerPhone": widget.phone ?? "",

                        "providerId": providerId,
                        "providerName": p['name'],

                        "category": _selectedCategory,
                        "issue": _selectedIssue,

                        "status": "pending",
                        "createdAt": FieldValue.serverTimestamp(),
                      });

                      bookingId = doc.id;

                      setState(() {
                        _currentStep = 3;
                      });

                      _startUberTracking();
                    },
                  )
                : const Text(
                    "Busy",
                    style: TextStyle(color: Colors.red),
                  ),
          ),
        );
      }).toList(),
    ],
  );
}

  // STEP 3 (LIVE TRACKING ONLY ADDED HERE)
    Widget _trackingView() {
  return Column(
    children: [
      Text("Tracking ${_selectedProvider?['name']}"),
      const SizedBox(height: 10),

      SizedBox(
        height: 350,
        child: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _customerLatLng,
            initialZoom: 15,
          ),
          children: [
            TileLayer(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              userAgentPackageName: 'com.example.fixnear',
            ),

            MarkerLayer(
              markers: [
                Marker(
                  point: _providerLatLng,
                  width: 40,
                  height: 40,
                  child: const Icon(
                    Icons.location_pin,
                    color: Colors.blue,
                    size: 40,
                  ),
                ),

                Marker(
                  point: _customerLatLng,
                  width: 40,
                  height: 40,
                  child: const Icon(
                    Icons.person_pin_circle,
                    color: Colors.green,
                    size: 40,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      const SizedBox(height: 20),

      ElevatedButton(
        onPressed: () {
          setState(() {
            _currentStep = 4;
          });
          _startUberTracking();
        },
        child: const Text("Go to Payment"),
      ),
    ],
  );
}  
  // STEP 4
  Widget _paymentView() {
    return Column(
      children: [
        const Text("Payment"),

        RadioListTile(
          title: const Text("UPI"),
          value: "UPI",
          groupValue: _selectedPaymentMethod,
          onChanged: (val) {
            setState(() => _selectedPaymentMethod = val!);
          },
        ),

        RadioListTile(
          title: const Text("Cash"),
          value: "Cash",
          groupValue: _selectedPaymentMethod,
          onChanged: (val) {
            setState(() => _selectedPaymentMethod = val!);
          },
        ),
        RadioListTile(
          title: const Text("Credit Card"),
          value: "Credit card",
          groupValue: _selectedPaymentMethod,
          onChanged: (val) {
            setState(() => _selectedPaymentMethod = val!);
          },
        ),
        RadioListTile(
          title: const Text("Debit Card"),
          value: "Debit card",
          groupValue: _selectedPaymentMethod,
          onChanged: (val) {
            setState(() => _selectedPaymentMethod = val!);
          },
        ),

        ElevatedButton(
          onPressed: () => setState(() => _currentStep = 5),
          child: const Text("Pay"),
        )
      ],
    );
  }

  // STEP 5
  Widget _successView() {
    return Column(
      children: [
        const Icon(Icons.check_circle, size: 100, color: Colors.green),
        const Text("Payment Successful!"),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _currentStep = 0;
            });
          },
          child: const Text("Back to Home"),
        )
      ],
    );
  }
  void _startRealTracking() async {
  LocationPermission permission = await Geolocator.requestPermission();

  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    return;
  }

  _locationStream = Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5,
    ),
  ).listen((Position position) {
    setState(() {
      _customerLatLng = LatLng(
        position.latitude,
        position.longitude,
      );
    });

    _mapController.move(_customerLatLng, 15);
  });
}
}