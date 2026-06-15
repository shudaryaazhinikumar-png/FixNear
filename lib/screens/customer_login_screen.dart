import 'package:flutter/material.dart';
import 'customer_dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerLoginScreen extends StatefulWidget {
  const CustomerLoginScreen({super.key});

  @override
  State<CustomerLoginScreen> createState() => _CustomerLoginScreenState();
}

class _CustomerLoginScreenState extends State<CustomerLoginScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final TextEditingController doorNoController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController stateController = TextEditingController();

  void continueToDashboard() async {
  if (nameController.text.isEmpty ||
      phoneController.text.isEmpty ||
      doorNoController.text.isEmpty ||
      streetController.text.isEmpty ||
      areaController.text.isEmpty ||
      districtController.text.isEmpty ||
      stateController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please fill all fields")),
    );
    return;
  }

  // 🔥 SAVE USER TO FIREBASE FIRST
  await FirebaseFirestore.instance
      .collection("users")
      .doc(phoneController.text)
      .set({
    "name": nameController.text,
    "phone": phoneController.text,
    "role": "customer",
    "createdAt": FieldValue.serverTimestamp(),
  });

  // 🔥 SAVE ADDRESS
  await FirebaseFirestore.instance.collection("addresses").add({
    "phone": phoneController.text,
    "doorNo": doorNoController.text,
    "street": streetController.text,
    "area": areaController.text,
    "district": districtController.text,
    "state": stateController.text,
  });

  // 🔥 MOVE TO DASHBOARD
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => CustomerDashboard(
        userName: nameController.text,
        phone: phoneController.text,
        doorNo: doorNoController.text,
        street: streetController.text,
        area: areaController.text,
        district: districtController.text,
        state: stateController.text,
      ),
    ),
  );
}

  Widget buildField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Customer Login")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildField(nameController, "Full Name"),
            buildField(phoneController, "Phone Number"),

            const SizedBox(height: 10),
            const Text("Service Address",
                style: TextStyle(fontWeight: FontWeight.bold)),

            buildField(doorNoController, "Door No"),
            buildField(streetController, "Street Name"),
            buildField(areaController, "Village / Urban Area"),
            buildField(districtController, "District"),
            buildField(stateController, "State"),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: continueToDashboard,
              child: const Text("Continue"),
            ),
          ],
        ),
      ),
    );
  }
}