import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'provider_dashboard.dart';

class ProviderLoginScreen extends StatefulWidget {
  const ProviderLoginScreen({super.key});

  @override
  State<ProviderLoginScreen> createState() => _ProviderLoginScreenState();
}

class _ProviderLoginScreenState extends State<ProviderLoginScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final expController = TextEditingController();

  String qualification = "Electrician";

  static const seaGreen = Color(0xFF2E8B80);

  Future<void> saveProvider() async {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    final exp = expController.text.trim();

    if (name.isEmpty || phone.isEmpty || exp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fill all fields")),
      );
      return;
    }

    try {
      print("SAVING TO FIRESTORE...");

      // Saving inside "users" collection with phone as Document ID
      await FirebaseFirestore.instance
          .collection("users")
          .doc(phone)
          .set({
        "name": name,
        "phone": phone,
        "experience": exp,
        "qualification": qualification,
        "role": "provider",
        "isAvailable": true,
        "createdAt": FieldValue.serverTimestamp(),
      });

      print("SAVED SUCCESSFULLY");

      // Passing the phone number directly to the dashboard constructor
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ProviderDashboard(providerPhone: phone),
        ),
      );
    } catch (e) {
      print("ERROR: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Provider Login"), backgroundColor: seaGreen),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: "Phone"),
            ),
            TextField(
              controller: expController,
              decoration: const InputDecoration(labelText: "Experience"),
            ),
            DropdownButtonFormField(
              value: qualification,
              items: const [
                DropdownMenuItem(value: "Electrician", child: Text("Electrician")),
                DropdownMenuItem(value: "Plumber", child: Text("Plumber")),
                DropdownMenuItem(value: "Carpenter", child: Text("Carpenter")),
              ],
              onChanged: (v) {
                setState(() => qualification = v.toString());
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveProvider,
              child: const Text("Save & Continue"),
            )
          ],
        ),
      ),
    );
  }
}