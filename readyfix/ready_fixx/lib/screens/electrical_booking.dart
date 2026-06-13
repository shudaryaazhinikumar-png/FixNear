import 'package:flutter/material.dart';
import 'provider_list_screen.dart';

class ElectricalBooking extends StatefulWidget {
  const ElectricalBooking({super.key});

  @override
  State<ElectricalBooking> createState() => _ElectricalBookingState();
}

class _ElectricalBookingState extends State<ElectricalBooking> {
  String selectedIssue = 'Fuse Replacement';

  final List<String> issues = [
    'Fuse Replacement',
    'High Voltage Issue',
    'Wiring Fault',
    'Switchboard Repair',
  ];

  final TextEditingController addressController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Electrical Booking'),
        backgroundColor: const Color(0xFF6B7A3D),
        foregroundColor: Colors.white,
      ),

      backgroundColor: const Color(0xFF8A9A5B),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select the Problem',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              value: selectedIssue,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF5F5DC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: issues.map((issue) {
                return DropdownMenuItem(
                  value: issue,
                  child: Text(issue),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedIssue = value!;
                });
              },
            ),

            const SizedBox(height: 25),

            const Text(
              'Address',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: addressController,
              decoration: InputDecoration(
                hintText: 'Enter your address',
                filled: true,
                fillColor: const Color(0xFFF5F5DC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 3,
            ),

            const SizedBox(height: 40),

            Center(
              child: SizedBox(
                width: 220,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const ProviderListScreen(),
    ),
  );
},
                  child: const Text(
                    'Find Providers',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}