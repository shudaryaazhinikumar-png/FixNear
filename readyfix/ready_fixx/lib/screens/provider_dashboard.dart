import 'package:flutter/material.dart';

class ProviderDashboard extends StatelessWidget {
  const ProviderDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Dashboard'),
      ),
      body: const Center(
        child: Text(
          'Provider Features Coming Soon',
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}