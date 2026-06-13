import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin System Metrics'),
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Platform Activity Insights', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _metricTile('Total Users', '1,420', Colors.blue)),
                Expanded(child: _metricTile('Active Orders', '42', Colors.orange)),
                Expanded(child: _metricTile('Commission Split', '₹4,200', Colors.green)),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Recent Platform Activity Logs', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Text('Scroll wheel to inspect transactional events', style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 12),
            
            // BOUNDED LAYOUT BOX: Resolves the infinite layout crash
            SizedBox(
              height: 200, 
              child: ListWheelScrollView.useDelegate(
                itemExtent: 65,
                physics: const FixedExtentScrollPhysics(),
                perspective: 0.003,
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: 6,
                  builder: (context, index) {
                    return Card(
                      color: Colors.blueGrey[50],
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            const Icon(Icons.code, color: Colors.blueGrey),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Log ID #1024$index: Secure payment route callback processed successfully.',
                                style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metricTile(String label, String value, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey), textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }
}