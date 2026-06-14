import 'package:flutter/material.dart';

// IMPORT LOGIN SCREENS (NOT dashboards)
import 'customer_login_screen.dart';
import 'provider_login_screen.dart';
import 'admin_login_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 450),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.build_circle,
                  size: 80, color: Colors.indigo),

              const SizedBox(height: 16),

              const Text(
                'FixNear',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),

              const Text(
                'Coimbatore Utility Service Network',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),

              const SizedBox(height: 32),

              // 👤 CUSTOMER
              _buildRoleButton(
                context,
                title: '👤 Continue as Customer',
                subtitle: 'Book local verified home utility services',
                destination: const CustomerLoginScreen(),
              ),

              const SizedBox(height: 16),

              // 🛠 PROVIDER
              _buildRoleButton(
                context,
                title: '🛠 Continue as Service Provider',
                subtitle: 'Manage client job requests and service earnings',
                destination:const ProviderLoginScreen(),
              ),

              const SizedBox(height: 16),

              // 👨‍💼 ADMIN
              _buildRoleButton(
                context,
                title: '👨‍💼 Continue as Administrator',
                subtitle: 'Verify providers, payments and reports',
                destination:  AdminLoginScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleButton(
    BuildContext context, {
    required String title,
    required String subtitle,
    required Widget destination,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16),
        backgroundColor: Colors.white,
        foregroundColor: Colors.indigo,
        side: const BorderSide(color: Colors.indigo, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}