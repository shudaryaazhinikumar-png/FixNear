import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrator Dashboard'),
      ),
      body: const Center(
        child: Text(
          'Admin Features Coming Soon',
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}