import 'package:flutter/material.dart';
import 'electrical_booking.dart';

class CustomerDashboard extends StatelessWidget {
  const CustomerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> services = [
      {'title': 'Electrical', 'icon': Icons.electrical_services},
      {'title': 'Plumbing', 'icon': Icons.plumbing},
      {'title': 'Borewell', 'icon': Icons.water_drop},
      {'title': 'Water Tank', 'icon': Icons.storage},
      {'title': 'Utility\nComplaints', 'icon': Icons.report_problem},
      {'title': 'Emergency\nContacts', 'icon': Icons.local_hospital},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF8A9A5B), // Olive Green

      appBar: AppBar(
        title: const Text('Customer Dashboard'),
        centerTitle: true,
        backgroundColor: const Color(0xFF6B7A3D),
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome to FixNear',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'Choose a service category',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white70,
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: GridView.builder(
                itemCount: services.length,

                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.4,
                ),

                itemBuilder: (context, index) {
                  return Card(
                    color: const Color(0xFFF5F5DC), // Cream
                    elevation: 4,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),

                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),

                      onTap: () {
  if (services[index]['title'] == 'Electrical') {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ElectricalBooking(),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${services[index]['title']} coming soon',
        ),
      ),
    );
  }
},

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            services[index]['icon'],
                            size: 40,
                            color: const Color(0xFF6B7A3D),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            services[index]['title'],
                            textAlign: TextAlign.center,

                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}