import 'package:flutter/material.dart';

class ProviderDashboard extends StatefulWidget {
  const ProviderDashboard({super.key});

  @override
  State<ProviderDashboard> createState() => _ProviderDashboardState();
}

class _ProviderDashboardState extends State<ProviderDashboard> {
  int page = 0;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController experienceController =
      TextEditingController();

  String qualification = 'Electrician';

  static const Color seaGreen = Color(0xFF2E8B80);
  static const Color darkSeaGreen = Color(0xFF1F6F66);
  static const Color lightSeaGreen = Color(0xFFBEE7E1);
  static const Color mintBackground = Color(0xFFF2FBF9);

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    experienceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mintBackground,
      appBar: AppBar(
        title: const Text('Service Provider'),
        backgroundColor: seaGreen,
      ),
      body: page == 0
          ? registrationPage()
          : page == 1
              ? dashboardPage()
              : profilePage(),
    );
  }

  Widget registrationPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Icon(
            Icons.handyman,
            size: 90,
            color: seaGreen,
          ),

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
              DropdownMenuItem(
                value: 'Electrician',
                child: Text('Electrician'),
              ),
              DropdownMenuItem(
                value: 'Plumber',
                child: Text('Plumber'),
              ),
              DropdownMenuItem(
                value: 'Carpenter',
                child: Text('Carpenter'),
              ),
              DropdownMenuItem(
                value: 'AC Technician',
                child: Text('AC Technician'),
              ),
              DropdownMenuItem(
                value: 'Painter',
                child: Text('Painter'),
              ),
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
              onPressed: () {
                setState(() {
                  page = 1;
                });
              },
              child: const Text(
                'Continue',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget dashboardPage() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Card(
          color: lightSeaGreen,
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: seaGreen,
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
            title: Text(nameController.text),
            subtitle: Text(
              '$qualification • ${experienceController.text} years',
            ),
          ),
        ),

        dashboardTile(
          'My Profile',
          Icons.person,
          () {
            setState(() {
              page = 2;
            });
          },
        ),

        dashboardTile(
          'Services Completed',
          Icons.check_circle,
          showCompletedServices,
        ),

        dashboardTile(
          'Services To Attend',
          Icons.notifications,
          showPendingServices,
        ),

        dashboardTile(
          'Other Service Providers',
          Icons.groups,
          showOtherProviders,
        ),
      ],
    );
  }

  Widget dashboardTile(
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      child: ListTile(
        leading: Icon(
          icon,
          color: seaGreen,
        ),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  Widget profilePage() {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundColor: seaGreen,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 40,
                ),
              ),

              const SizedBox(height: 20),

              Text('Name: ${nameController.text}'),
              Text('Phone: ${phoneController.text}'),
              Text('Qualification: $qualification'),
              Text(
                'Experience: ${experienceController.text} years',
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: seaGreen,
                ),
                onPressed: () {
                  setState(() {
                    page = 1;
                  });
                },
                child: const Text(
                  'Back',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showCompletedServices() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Services Completed'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Problem: Fan Installation\n'
              'Customer: Ashwin\n'
              'Payment: ₹500\n'
              'Admin Cut: ₹50\n'
              'You Earned: ₹450',
            ),
            SizedBox(height: 15),
            Text(
              'Problem: Switch Repair\n'
              'Customer: Priya\n'
              'Payment: ₹300\n'
              'Admin Cut: ₹30\n'
              'You Earned: ₹270',
            ),
          ],
        ),
      ),
    );
  }

  void showPendingServices() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Services To Attend'),
        content: const Text(
          'Problem: Water Leakage\n'
          'Customer: Divya\n'
          'Phone: 9876543210\n'
          'Time: 4:00 PM',
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: seaGreen,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Accept',
              style: TextStyle(color: Colors.white),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Decline',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void showOtherProviders() {
    showDialog(
      context: context,
      builder: (_) => const AlertDialog(
        title: Text('Other Service Providers'),
        content: SingleChildScrollView(
          child: Text(
            'Electricians:\n'
            '• Ravi Kumar (5 yrs)\n'
            '• Manoj (3 yrs)\n\n'
            'Plumbers:\n'
            '• Suresh (4 yrs)\n'
            '• Arjun (6 yrs)\n\n'
            'Carpenters:\n'
            '• Karthik (8 yrs)\n'
            '• Naveen (2 yrs)',
          ),
        ),
      ),
    );
  }
}