import 'package:flutter/material.dart';

class ProviderDashboard extends StatefulWidget {
  const ProviderDashboard({super.key});

  @override
  State<ProviderDashboard> createState() => _ProviderDashboardState();
}

class _ProviderDashboardState extends State<ProviderDashboard> {
  bool isAvailable = true;

  // Provider profile (later from login/Firebase)
  String providerName = "Kumar Electrician";
  String category = "Electrician";
  String experience = "5 Years";

  List<Map<String, String>> incomingRequests = [
    {
      "service": "Electrical Repair",
      "customer": "Arun",
      "address": "Coimbatore",
      "status": "New Request"
    },
    {
      "service": "Fan Repair",
      "customer": "Kiran",
      "address": "Chennai",
      "status": "New Request"
    },
  ];

  List<Map<String, String>> activeJobs = [];

  List<Map<String, String>> completedJobs = [
    {
      "service": "Water Tank Cleaning",
      "customer": "Rahul",
      "address": "Madurai",
      "issue": "Tank cleaning done",
      "rating": "4.5",
      "payment": "500",
      "adminCut": "100",
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8A9A5B),

      appBar: AppBar(
        title: const Text("Provider Dashboard"),
        backgroundColor: const Color(0xFF6B7A3D),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🔹 PROFILE SECTION
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5DC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    providerName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text("Category: $category"),
                  Text("Experience: $experience"),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // 🔹 STATUS
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5DC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Availability Status"),
                  Switch(
                    value: isAvailable,
                    onChanged: (value) {
                      setState(() {
                        isAvailable = value;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // 🔹 INCOMING REQUESTS
            const Text(
              "Incoming Requests",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            Expanded(
              child: ListView(
                children: [

                  ...incomingRequests.map((req) {
                    return Card(
                      child: ListTile(
                        title: Text(req["service"]!),
                        subtitle: Text(
                          "Customer: ${req["customer"]}\nAddress: ${req["address"]}",
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              activeJobs.add(req);
                              incomingRequests.remove(req);
                            });
                          },
                          child: const Text("Accept"),
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 10),

                  // 🔹 ACTIVE JOBS
                  const Text(
                    "Active Jobs",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  ...activeJobs.map((job) {
                    return Card(
                      color: Colors.green.shade50,
                      child: ListTile(
                        title: Text(job["service"] ?? ""),
                        subtitle: Text("Customer: ${job["customer"]}"),
                        trailing: const Icon(Icons.work),
                      ),
                    );
                  }),

                  const SizedBox(height: 10),

                  // 🔹 COMPLETED JOBS (IMPORTANT)
                  const Text(
                    "Completed Services",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  ...completedJobs.map((job) {
                    return Card(
                      child: ListTile(
                        title: Text(job["service"]!),
                        subtitle: Text(
                          "Customer: ${job["customer"]}\n"
                          "Issue: ${job["issue"]}\n"
                          "Rating: ⭐ ${job["rating"]}",
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("₹${job["payment"]}"),
                            Text(
                              "Cut ₹${job["adminCut"]}",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),

            // 🔹 EARNINGS
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5DC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Today's Earnings: ₹1200 (Demo)",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}