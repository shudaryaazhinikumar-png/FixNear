import 'package:flutter/material.dart';
import 'tracking_screen.dart';

class PaymentScreen extends StatefulWidget {
  final String providerName;
  final String serviceName;

  const PaymentScreen({
    super.key,
    required this.providerName,
    required this.serviceName,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedMethod = "UPI";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),

      appBar: AppBar(
        title: const Text("Payment"),
        backgroundColor: const Color(0xFF6B7A3D),
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Choose Payment Method",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Text("Provider: ${widget.providerName}"),
            Text("Service: ${widget.serviceName}"),

            const SizedBox(height: 20),

            RadioListTile(
              title: const Text("UPI"),
              value: "UPI",
              groupValue: selectedMethod,
              onChanged: (value) {
                setState(() {
                  selectedMethod = value.toString();
                });
              },
            ),

            RadioListTile(
              title: const Text("Debit Card"),
              value: "Debit Card",
              groupValue: selectedMethod,
              onChanged: (value) {
                setState(() {
                  selectedMethod = value.toString();
                });
              },
            ),

            RadioListTile(
              title: const Text("Credit Card"),
              value: "Credit Card",
              groupValue: selectedMethod,
              onChanged: (value) {
                setState(() {
                  selectedMethod = value.toString();
                });
              },
            ),

            RadioListTile(
              title: const Text("Cash on Service"),
              value: "Cash",
              groupValue: selectedMethod,
              onChanged: (value) {
                setState(() {
                  selectedMethod = value.toString();
                });
              },
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B7A3D),
                  foregroundColor: Colors.white,
                ),

                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Payment Successful"),
                      content: Text(
                        "Paid via $selectedMethod\n\nBooking confirmed with ${widget.providerName}",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // close dialog

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TrackingScreen(
                                  providerName: widget.providerName,
                                ),
                              ),
                            );
                          },
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  );
                },

                child: const Text(
                  "Proceed Payment",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}