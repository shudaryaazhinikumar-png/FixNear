import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  // Demo data (later will come from Firestore)
  final List<Map<String, dynamic>> services = const [
    {
      "customer": "Ravi",
      "provider": "Kumar Electrician",
      "service": "Electrical Repair",
      "payment": 500,
      "adminCut": 100,
    },
    {
      "customer": "Kiran",
      "provider": "Arun Plumber",
      "service": "Pipe Fix",
      "payment": 300,
      "adminCut": 60,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text('Administrator Dashboard'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // PROFILE SECTION
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Admin Panel",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text("Manage all users, services & payments"),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // STATS CARDS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                _buildStatCard("Customers", "12", Colors.blue),
                _buildStatCard("Providers", "8", Colors.green),
                _buildStatCard("Services", "20", Colors.orange),
              ],
            ),

            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Recent Services",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // SERVICE LIST
            Expanded(
              child: ListView.builder(
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final s = services[index];

                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.build, color: Colors.deepPurple),

                      title: Text("${s['service']}"),
                      subtitle: Text(
                        "Customer: ${s['customer']}\nProvider: ${s['provider']}",
                      ),

                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("₹${s['payment']}"),
                          Text(
                            "Admin ₹${s['adminCut']}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.red,
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

  // STAT CARD WIDGET
  static Widget _buildStatCard(String title, String count, Color color) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 5),
          Text(title),
        ],
      ),
    );
  }
}