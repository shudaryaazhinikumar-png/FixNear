import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminLoginScreen();
  }
}

// ================= ADMIN LOGIN =================

class AdminLoginScreen extends StatelessWidget {
  const AdminLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();

    const Color cherry = Color(0xFFBC6266);
    const Color background = Color(0xFFE7B9AB);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text("Administrator Login"),
        backgroundColor: cherry,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.admin_panel_settings,
              size: 90,
              color: cherry,
            ),

            const SizedBox(height: 20),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Admin Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: cherry,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AdminHomeScreen(),
                    ),
                  );
                },
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= DASHBOARD =================

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color cherry = Color(0xFFBC6266);
    const Color light = Color(0xFFE7B9AB);

    return Scaffold(
      backgroundColor: light,
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        backgroundColor: cherry,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            dashboardCard(
              context,
              "Verify Providers",
              Icons.verified_user,
              const ProviderVerificationScreen(),
            ),

            dashboardCard(
              context,
              "Verify Payments",
              Icons.payment,
              const PaymentVerificationScreen(),
            ),

            dashboardCard(
              context,
              "Service Reports",
              Icons.bar_chart,
              const ServiceReportsScreen(),
            ),

            dashboardCard(
              context,
              "Logout",
              Icons.logout,
              null,
            ),
          ],
        ),
      ),
    );
  }

  Widget dashboardCard(
    BuildContext context,
    String title,
    IconData icon,
    Widget? screen,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color(0xFFBC6266),
          size: 35,
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          if (screen != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => screen),
            );
          } else {
            Navigator.popUntil(context, (route) => route.isFirst);
          }
        },
      ),
    );
  }
}

// ================= VERIFY PROVIDERS =================

class ProviderVerificationScreen extends StatelessWidget {
  const ProviderVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final providers = [
      "Ravi Electrician",
      "Suresh Plumber",
      "Kumar Carpenter",
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Providers"),
        backgroundColor: const Color(0xFFBC6266),
      ),
      body: ListView.builder(
        itemCount: providers.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(providers[index]),
              subtitle: const Text("Awaiting Approval"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ================= VERIFY PAYMENTS =================

class PaymentVerificationScreen extends StatelessWidget {
  const PaymentVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Verification"),
        backgroundColor: const Color(0xFFBC6266),
      ),
      body: ListView(
        children: const [
          Card(
            child: ListTile(
              title: Text("Booking #1001"),
              subtitle: Text("Screenshot Uploaded"),
              trailing: Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
            ),
          ),
          Card(
            child: ListTile(
              title: Text("Booking #1002"),
              subtitle: Text("Pending Verification"),
              trailing: Icon(
                Icons.pending,
                color: Colors.orange,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ================= REPORTS =================

class ServiceReportsScreen extends StatelessWidget {
  const ServiceReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Service Reports"),
        backgroundColor: const Color(0xFFBC6266),
      ),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: Text("Total Bookings"),
                trailing: Text("25"),
              ),
            ),
            Card(
              child: ListTile(
                title: Text("Completed Services"),
                trailing: Text("18"),
              ),
            ),
            Card(
              child: ListTile(
                title: Text("Pending Payments"),
                trailing: Text("4"),
              ),
            ),
            Card(
              child: ListTile(
                title: Text("Verified Providers"),
                trailing: Text("12"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}