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
      {'title': 'Utility Complaints', 'icon': Icons.report_problem},
      {'title': 'Emergency Contacts', 'icon': Icons.local_hospital},
    ];

    // Dummy profile data (later from login/Firebase)
    String name = "Customer Name";
    String phone = "9999999999";
    String address = "Street, City, District, State";

    return Scaffold(
      backgroundColor: const Color(0xFF8A9A5B),

      appBar: AppBar(
        title: const Text('Customer Dashboard'),
        centerTitle: true,
        backgroundColor: const Color(0xFF6B7A3D),
        foregroundColor: Colors.white,

        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Profile"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Name: $name"),
                      const SizedBox(height: 5),
                      Text("Phone: $phone"),
                      const SizedBox(height: 5),
                      Text("Address: $address"),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Close"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context); // logout (back to login)
                      },
                      child: const Text("Logout"),
                    ),
                  ],
                ),
              );
            },
          )
        ],
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
                    color: const Color(0xFFF5F5DC),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),

                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),

                      onTap: () {
                        String title = services[index]['title'];

                        if (title == 'Emergency Contacts') {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Emergency Contacts"),
                              content: const Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("🚒 Fire Service: 101"),
                                  SizedBox(height: 5),
                                  Text("🚓 Police: 100"),
                                  SizedBox(height: 5),
                                  Text("🚑 Ambulance: 108"),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Close"),
                                ),
                              ],
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ElectricalBookingScreen(
                                serviceName: title,
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