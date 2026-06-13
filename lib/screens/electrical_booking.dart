import 'package:flutter/material.dart';
import 'payment_screen.dart';

class ElectricalBookingScreen extends StatefulWidget {
  final String serviceName;

  const ElectricalBookingScreen({
    super.key,
    required this.serviceName,
  });

  @override
  State<ElectricalBookingScreen> createState() =>
      _ElectricalBookingScreenState();
}

class _ElectricalBookingScreenState extends State<ElectricalBookingScreen> {
  final TextEditingController problemController = TextEditingController();

  String selectedProvider = "";
  late List<Map<String, dynamic>> providers;

  @override
  void initState() {
    super.initState();
    providers = getProviders(widget.serviceName);
  }

  // ✅ Dynamic provider system
  List<Map<String, dynamic>> getProviders(String service) {
    if (service.contains("Electrical")) {
      return [
        {"name": "Kumar Electric", "status": "Available"},
        {"name": "Ravi Electric", "status": "Busy"},
      ];
    }

    if (service.contains("Plumbing")) {
      return [
        {"name": "Arun Plumber", "status": "Available"},
        {"name": "Selvam Plumber", "status": "Available"},
      ];
    }

    if (service.contains("Borewell")) {
      return [
        {"name": "Bore Expert Raja", "status": "Available"},
      ];
    }

    if (service.contains("Water Tank")) {
      return [
        {"name": "Tank Cleaner Mani", "status": "Busy"},
        {"name": "Deep Clean Services", "status": "Available"},
      ];
    }

    if (service.contains("Emergency")) {
      return [
        {"name": "Emergency Rescue Team", "status": "Available"},
      ];
    }

    return [
      {"name": "General Service Provider", "status": "Available"},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book ${widget.serviceName}"),
        backgroundColor: Colors.green,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Service title
            Text(
              "Service: ${widget.serviceName}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            const Text("Describe your problem"),

            const SizedBox(height: 10),

            TextField(
              controller: problemController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Example: Issue description...",
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Select Service Provider",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: providers.length,
                itemBuilder: (context, index) {
                  final p = providers[index];
                  bool isAvailable = p["status"] == "Available";
                  bool isSelected = selectedProvider == p["name"];

                  return Card(
                    color: isSelected
                        ? Colors.green.shade100
                        : Colors.white,
                    child: ListTile(
                      onTap: isAvailable
                          ? () {
                              setState(() {
                                selectedProvider = p["name"];
                              });
                            }
                          : null,

                      title: Text(
                        p["name"],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      subtitle: Text(
                        p["status"],
                        style: TextStyle(
                          color: isAvailable ? Colors.green : Colors.red,
                        ),
                      ),

                      trailing: Icon(
                        isAvailable
                            ? Icons.check_circle
                            : Icons.cancel,
                        color: isAvailable ? Colors.green : Colors.red,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedProvider.isEmpty
                      ? Colors.grey
                      : Colors.green,
                  padding: const EdgeInsets.all(15),
                ),

                onPressed: selectedProvider.isEmpty
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentScreen(
                              providerName: selectedProvider,
                              serviceName: widget.serviceName,
                            ),
                          ),
                        );
                      },

                child: Text(
                  selectedProvider.isEmpty
                      ? "Select Provider"
                      : "Proceed with $selectedProvider",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}