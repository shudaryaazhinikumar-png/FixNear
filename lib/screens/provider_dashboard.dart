import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProviderDashboard extends StatefulWidget {
  final String providerPhone; // Accepts the phone ID from login screen

  const ProviderDashboard({super.key, required this.providerPhone});

  @override
  State<ProviderDashboard> createState() => _ProviderDashboardState();
}

class _ProviderDashboardState extends State<ProviderDashboard> {
  static const Color seaGreen = Color(0xFF2E8B80);
  static const Color lightSeaGreen = Color(0xFFBEE7E1);
  static const Color mintBackground = Color(0xFFF2FBF9);

  String name = "";
  String phone = "";
  String qualification = "";
  String experience = "";

  bool isLoadingProfile = true;

  @override
  void initState() {
    super.initState();
    loadProviderProfile();
  }

  // ---------------- MATCHED & FIXED PROFILE FETCH ----------------
  Future<void> loadProviderProfile() async {
    try {
      // Pulling directly from your verified collection ("users") using the phone doc ID
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.providerPhone)
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          name = data["name"] ?? "Unknown Provider";
          phone = data["phone"] ?? widget.providerPhone;
          qualification = data["qualification"] ?? "Not Set";
          experience = data["experience"]?.toString() ?? "0";
          isLoadingProfile = false;
        });
      } else {
        setState(() => isLoadingProfile = false);
      }
    } catch (e) {
      debugPrint("Error fetching profile details: $e");
      setState(() => isLoadingProfile = false);
    }
  }

  void acceptBooking(String id) {
    FirebaseFirestore.instance.collection("bookings").doc(id).update({
      "status": "accepted",
      "providerPhone": widget.providerPhone,
    });
  }

  void completeBooking(String id) {
    FirebaseFirestore.instance.collection("bookings").doc(id).update({
      "status": "completed",
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mintBackground,
      appBar: AppBar(
        title: const Text("Provider Dashboard"),
        backgroundColor: seaGreen,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ================= PROPER DETAILS PROFILE BOX =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              color: lightSeaGreen,
              child: isLoadingProfile
                  ? const Center(child: CircularProgressIndicator(color: seaGreen))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("👤 Name: $name",
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text("📞 Phone Number: $phone", style: const TextStyle(fontSize: 15)),
                        const SizedBox(height: 4),
                        Text("🔧 Specialty: $qualification", style: const TextStyle(fontSize: 15)),
                        const SizedBox(height: 4),
                        Text("⏳ Experience: $experience years", style: const TextStyle(fontSize: 15)),
                      ],
                    ),
            ),

            const SizedBox(height: 10),

            // ================= SERVICES TO ATTEND DROPDOWN =================
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ExpansionTile(
                initiallyExpanded: true,
                title: const Text(
                  "Services To Attend",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: seaGreen),
                ),
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("bookings")
                        .where("status", isEqualTo: "pending")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: CircularProgressIndicator(),
                        );
                      }

                      final docs = snapshot.data!.docs;
                      if (docs.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(15),
                          child: Text("No incoming bookings available"),
                        );
                      }

                      return Column(
                        children: docs.map((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            color: mintBackground,
                            child: ListTile(
                              title: Text(data["category"] ?? "Service", style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(data["issue"] ?? "No description"),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: seaGreen),
                                    onPressed: () => acceptBooking(doc.id),
                                    child: const Text("Accept", style: TextStyle(color: Colors.white)),
                                  ),
                                  const SizedBox(width: 5),
                                  ElevatedButton(
                                    onPressed: () => completeBooking(doc.id),
                                    child: const Text("Done"),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),

            // ================= SERVICES COMPLETED DROPDOWN =================
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ExpansionTile(
                title: const Text(
                  "Services Completed",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: seaGreen),
                ),
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("bookings")
                        .where("status", isEqualTo: "completed")
                        .where("providerPhone", isEqualTo: widget.providerPhone)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: CircularProgressIndicator(),
                        );
                      }

                      final docs = snapshot.data!.docs;
                      if (docs.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(15),
                          child: Text("No completed jobs on record"),
                        );
                      }

                      return Column(
                        children: docs.map((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            color: mintBackground,
                            child: ListTile(
                              leading: const Icon(Icons.check_circle, color: Colors.green),
                              title: Text(data["category"] ?? "Service", style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Issue: ${data["issue"] ?? ''}"),
                                    const SizedBox(height: 4),
                                    Text("👤 Client: ${data["customerName"] ?? 'N/A'}", style: const TextStyle(fontWeight: FontWeight.bold)),
                                    Text("📞 Contact: ${data["customerPhone"] ?? 'N/A'}"),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),

            // ================= OTHER PROVIDERS DROPDOWN =================
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ExpansionTile(
                title: const Text(
                  "Other Providers",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: seaGreen),
                ),
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .where("role", isEqualTo: "provider")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: CircularProgressIndicator(),
                        );
                      }

                      final docs = snapshot.data!.docs;
                      return Column(
                        children: docs.map((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          final String otherProviderPhone = doc.id;

                          // Skip displaying oneself under "Other Providers"
                          if (otherProviderPhone == widget.providerPhone) {
                            return const SizedBox.shrink();
                          }

                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            color: lightSeaGreen.withOpacity(0.4),
                            child: ExpansionTile(
                              leading: const CircleAvatar(
                                backgroundColor: seaGreen,
                                child: Icon(Icons.engineering, color: Colors.white),
                              ),
                              title: Text(data["name"] ?? "No Name", style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(data["qualification"] ?? "Provider"),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("📋 complete Database Details:", style: TextStyle(fontWeight: FontWeight.bold, color: seaGreen)),
                                      Text("• Phone number: ${data["phone"] ?? 'N/A'}"),
                                      Text("• Experience: ${data["experience"] ?? '0'} years"),
                                      const SizedBox(height: 10),
                                      const Text("📅 Active History:", style: TextStyle(fontWeight: FontWeight.bold, color: seaGreen)),
                                      StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection("bookings")
                                            .where("providerPhone", isEqualTo: otherProviderPhone)
                                            .snapshots(),
                                        builder: (context, bookingSnapshot) {
                                          if (!bookingSnapshot.hasData) {
                                            return const LinearProgressIndicator();
                                          }
                                          final providerBookings = bookingSnapshot.data!.docs;
                                          if (providerBookings.isEmpty) {
                                            return const Text("No assignments linked to this account.", style: TextStyle(fontStyle: FontStyle.italic, fontSize: 13));
                                          }
                                          return Column(
                                            children: providerBookings.map((bDoc) {
                                              final bData = bDoc.data() as Map<String, dynamic>;
                                              return Container(
                                                margin: const EdgeInsets.only(top: 4),
                                                padding: const EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text("${bData["category"] ?? 'Service'} [${bData["status"] ?? ''}]", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                                                    Text("User: ${bData["customerName"] ?? 'N/A'}", style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    },
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