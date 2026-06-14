import 'package:flutter/material.dart';

import 'services/auth_services.dart';

import 'screens/admin_dashboard.dart';
import 'screens/customer_dashboard.dart';
import 'screens/provider_dashboard.dart';
import 'screens/role_selection_screen.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  Widget? screen;

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  Future<void> checkUser() async {
    bool loggedIn = await AuthService.isLoggedIn();

    if (!loggedIn) {
      setState(() {
        screen = const RoleSelectionScreen();
      });
      return;
    }

    String? role = await AuthService.getRole();

    if (role == "admin") {
      screen = const AdminHomeScreen();
    } else if (role == "customer") {
      screen = CustomerDashboard();
    } else if (role == "provider") {
      screen = const ProviderDashboard();
    } else {
      screen = const RoleSelectionScreen();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (screen == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return screen!;
  }
}