import 'package:flutter/material.dart';
import 'admin_login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminLoginScreen();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Providers"),
        backgroundColor: const Color(0xFFBC6266),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("providers").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("No Providers Found"));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              return Card(
                child: ListTile(
                  title: Text(data["name"] ?? ""),
                  subtitle: Text(
                    data["status"] ?? "Awaiting Approval",
                  ),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection("providers")
                              .doc(docs[index].id)
                              .update({
                            "status": "approved",
                          });
                        },
                      ),

                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection("providers")
                              .doc(docs[index].id)
                              .update({
                            "status": "rejected",
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
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
      body: StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance
      .collection("bookings")
      .where("paymentStatus", isEqualTo: "pending")
      .snapshots(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) {
      return const Center(child: CircularProgressIndicator());
    }

    final docs = snapshot.data!.docs;

    return ListView(
      children: docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        return Card(
          child: ListTile(
            title: Text("Booking ${doc.id}"),
            subtitle: Text(data["paymentStatus"] ?? "pending"),
            trailing: IconButton(
              icon: const Icon(Icons.check_circle, color: Colors.green),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection("bookings")
                    .doc(doc.id)
                    .update({
                  "paymentStatus": "verified",
                });
              },
            ),
          ),
        );
      }).toList(),
    );
  },
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
      body: StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance.collection("bookings").snapshots(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) {
      return const Center(child: CircularProgressIndicator());
    }

    final docs = snapshot.data!.docs;

    int total = docs.length;
    int completed = docs.where((d) {
      return (d.data() as Map<String, dynamic>)["status"] == "completed";
    }).length;

    int pendingPayment = docs.where((d) {
      return (d.data() as Map<String, dynamic>)["paymentStatus"] == "pending";
    }).length;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Card(
            child: ListTile(
              title: const Text("Total Bookings"),
              trailing: Text("$total"),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text("Completed Services"),
              trailing: Text("$completed"),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text("Pending Payments"),
              trailing: Text("$pendingPayment"),
            ),
          ),
          const Card(
            child: ListTile(
              title: Text("Verified Providers"),
              trailing: Text("Live DB"),
            ),
          ),
        ],
      ),
    );
  },
),
    );
  }
}