import 'package:flutter/material.dart';

class TrackingScreen extends StatefulWidget {
  final String providerName;

  const TrackingScreen({
    super.key,
    required this.providerName,
  });

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen>
    with SingleTickerProviderStateMixin {
  double progress = 0.0;
  String status = "Booking Confirmed";

  @override
  void initState() {
    super.initState();

    // simulate live movement
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        progress = 0.3;
        status = "Provider Assigned";
      });
    });

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        progress = 0.6;
        status = "${widget.providerName} is on the way";
      });
    });

    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        progress = 0.9;
        status = "Arriving Soon";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Tracking"),
        backgroundColor: const Color(0xFF6B7A3D),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const SizedBox(height: 20),

            const Icon(
              Icons.delivery_dining,
              size: 90,
              color: Colors.green,
            ),

            const SizedBox(height: 20),

            Text(
              widget.providerName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              status,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),

            LinearProgressIndicator(
              value: progress,
              color: Colors.green,
              backgroundColor: Colors.grey.shade300,
            ),

            const SizedBox(height: 40),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Live Updates",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            buildStep("Booking Confirmed", true),
            buildStep("Provider Assigned", progress >= 0.3),
            buildStep("On the Way", progress >= 0.6),
            buildStep("Arriving", progress >= 0.9),
          ],
        ),
      ),
    );
  }

  Widget buildStep(String title, bool done) {
    return ListTile(
      leading: Icon(
        done ? Icons.check_circle : Icons.radio_button_unchecked,
        color: done ? Colors.green : Colors.grey,
      ),
      title: Text(title),
    );
  }
}