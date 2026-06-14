import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'provider_dashboard.dart';

class ProviderLoginScreen extends StatefulWidget {
  const ProviderLoginScreen({super.key});

  @override
  State<ProviderLoginScreen> createState() => _ProviderLoginScreenState();
}

class _ProviderLoginScreenState extends State<ProviderLoginScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();

  String qualification = 'Electrician';

  static const Color seaGreen = Color(0xFF2E8B80);
  static const Color mintBackground = Color(0xFFF2FBF9);

  Future<void> saveLogin() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("provider_name", nameController.text);
    await prefs.setString("provider_phone", phoneController.text);
    await prefs.setString("provider_exp", experienceController.text);
    await prefs.setString("provider_qual", qualification);
    await prefs.setBool("provider_logged_in", true);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const ProviderDashboard(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mintBackground,
      appBar: AppBar(
        title: const Text('Service Provider Login'),
        backgroundColor: seaGreen,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.handyman, size: 90, color: seaGreen),

            const SizedBox(height: 20),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              value: qualification,
              decoration: const InputDecoration(
                labelText: 'Qualification',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Electrician', child: Text('Electrician')),
                DropdownMenuItem(value: 'Plumber', child: Text('Plumber')),
                DropdownMenuItem(value: 'Carpenter', child: Text('Carpenter')),
                DropdownMenuItem(value: 'AC Technician', child: Text('AC Technician')),
                DropdownMenuItem(value: 'Painter', child: Text('Painter')),
              ],
              onChanged: (value) {
                setState(() {
                  qualification = value!;
                });
              },
            ),

            const SizedBox(height: 15),

            TextField(
              controller: experienceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Years of Experience',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: seaGreen,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: saveLogin,
                child: const Text(
                  'Login / Continue',
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