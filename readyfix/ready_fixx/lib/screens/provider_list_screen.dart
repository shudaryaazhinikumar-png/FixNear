import 'package:flutter/material.dart';
import 'payment_screen.dart';

class ProviderListScreen extends StatelessWidget {
  const ProviderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final providers = [
      {
        'name': 'Kumar',
        'rating': '4.8',
        'distance': '2 km',
        'status': 'Available',
      },
      {
        'name': 'Ravi',
        'rating': '4.5',
        'distance': '3 km',
        'status': 'Available',
      },
      {
        'name': 'Mani',
        'rating': '4.9',
        'distance': '1.5 km',
        'status': 'Busy',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF8A9A5B),

      appBar: AppBar(
        title: const Text('Choose Provider'),
        centerTitle: true,
        backgroundColor: const Color(0xFF6B7A3D),
        foregroundColor: Colors.white,
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: providers.length,
        itemBuilder: (context, index) {
          final provider = providers[index];

          return Card(
            color: const Color(0xFFF5F5DC),
            margin: const EdgeInsets.only(bottom: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: provider['status'] == 'Available'
                    ? Colors.green
                    : Colors.orange,
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),

              title: Text(
                provider['name']!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              subtitle: Text(
                '⭐ ${provider['rating']}   •   ${provider['distance']}',
              ),

              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      provider['status'] == 'Available'
                          ? Colors.green
                          : Colors.orange,
                  foregroundColor: Colors.white,
                ),
                onPressed: provider['status'] == 'Available'
    ? () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentScreen(
              providerName: provider['name']!,
              serviceName: "Electrical Repair",
            ),
          ),
        );
      }
    : null,
                child: Text(provider['status']!),
              ),
            ),
          );
        },
      ),
    );
  }
}