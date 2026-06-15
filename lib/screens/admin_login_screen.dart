import 'package:flutter/material.dart';
import 'admin_dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  bool isLoading = false; // Prevents double taps and gives visual feedback

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void _navigateToDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const AdminHomeScreen(),
      ),
    );
  }

  Future<void> handleLogin() async {
    // 1. Validate Form Fields
    if (nameController.text.trim().isEmpty || phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // 2. Fetch or Determine a Unique ID
      String uid = FirebaseAuth.instance.currentUser?.uid ?? "";
      
      // Fallback: If no Firebase Auth session exists yet, use the trimmed phone number as Document ID
      if (uid.isEmpty) {
        uid = phoneController.text.trim();
      }

      // 3. Save Admin Details safely to Cloud Firestore
      await FirebaseFirestore.instance
          .collection("admins")
          .doc(uid)
          .set({
        "uid": uid,
        "name": nameController.text.trim(),
        "phone": phoneController.text.trim(),
        "role": "admin",
        "createdAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // 4. Move smoothly to Dashboard
      if (mounted) {
        _navigateToDashboard();
      }
    } catch (e) {
      // Catch Firestore errors (e.g. permission-denied, offline, invalid paths)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login Database Error: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
        child: SingleChildScrollView( // Prevents overflow errors when keyboard pops up
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Icon(
                Icons.admin_panel_settings,
                size: 90,
                color: cherry,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                textInputAction: TextInputAction.next,
                onSubmitted: (_) {
                  FocusScope.of(context).nextFocus();
                },
                decoration: const InputDecoration(
                  labelText: "Admin Name",
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white70,
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => handleLogin(), // Call unified login method on keyboard action
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white70,
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
                  onPressed: isLoading ? null : handleLogin, 
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "Login",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}