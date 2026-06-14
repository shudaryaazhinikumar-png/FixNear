import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/auth_services.dart';
import 'screens/role_selection_screen.dart';
import 'screens/customer_dashboard.dart';
import 'screens/provider_dashboard.dart';
import 'screens/admin_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print("Firebase apps before: ${Firebase.apps.length}");

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  print("Firebase apps after: ${Firebase.apps.length}");

  runApp(
    const FixNearApp(
      loggedIn: false,
      role: '',
    ),
  );
}
class FixNearApp extends StatelessWidget {
  final bool loggedIn;
  final String? role;

  const FixNearApp({
    super.key,
    required this.loggedIn,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _getHome(),
    );
  }

  Widget _getHome() {
    if (!loggedIn) return const RoleSelectionScreen();

    switch (role) {
      case 'customer':
        return const CustomerDashboard();
      case 'provider':
        return const ProviderDashboard();
      case 'admin':
        return const AdminDashboard();
      default:
        return const RoleSelectionScreen();
    }
  }
}