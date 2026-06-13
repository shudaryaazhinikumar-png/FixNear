import 'package:flutter/material.dart';

class ProviderDashboard extends StatelessWidget {
  const ProviderDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Technician Operational Hub')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Card(
              color: Colors.indigo,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Technician Node: Kumar R', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('Cluster Region: Gandhipuram, CBE', style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                    Icon(Icons.verified, color: Colors.greenAccent, size: 36),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Pending Incoming Network Dispatches', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: [
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.electrical_services, color: Colors.amber),
                      title: const Text('Urgent Main Fuse Box Fault'),
                      subtitle: const Text('Location: RS Puram | Distance: 2.5 km away'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(icon: const Icon(Icons.check, color: Colors.green), onPressed: () {}),
                          IconButton(icon: const Icon(Icons.close, color: Colors.red), onPressed: () {}),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}