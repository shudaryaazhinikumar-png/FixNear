import 'package:flutter/material.dart';

class CustomerDashboard extends StatefulWidget {
  const CustomerDashboard({Key? key}) : super(key: key);

  @override
  State<CustomerDashboard> createState() => _CustomerDashboardState();
}

class _CustomerDashboardState extends State<CustomerDashboard> {
  // Navigation Step Tracker: 0 = Login/Registration, 1 = Category Selection Portal
  int _currentStep = 0;

  // Text Editing Controllers to preserve user profile data state parameters
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _doorNoController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // Custom Color Constants matching Olive Green and Cream UI Specifications
  static const Color oliveGreen = Color(0xFF556B2F);
  static const Color creamBackground = Color(0xFFFDFBF7);
  static const Color creamCardColor = Color(0xFFFFFDD0);

  // Available service categories compiled from your project matrix
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Electrical', 'icon': Icons.flash_on},
    {'name': 'Plumbing', 'icon': Icons.water_drop},
    {'name': 'Borewell Services', 'icon': Icons.oil_barrel},
    {'name': 'Water Tank Repair', 'icon': Icons.propane_tank},
    {'name': 'Utility Complaints', 'icon': Icons.gavel},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _doorNoController.dispose();
    _streetController.dispose();
    _areaController.dispose();
    _districtController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: creamBackground,
      appBar: AppBar(
        title: Text(
          _currentStep == 0 ? 'Customer Registration' : 'Select Utility Service',
          style: const TextStyle(fontWeight: FontWeight.bold, color: creamBackground),
        ),
        backgroundColor: oliveGreen,
        iconTheme: const IconThemeData(color: creamBackground),
        actions: [
          if (_currentStep == 1)
            IconButton(
              icon: const Icon(Icons.account_circle, size: 30),
              tooltip: 'View Former Login Profile',
              onPressed: () {
                setState(() {
                  _currentStep = 0; // Seamlessly shift back to edit/view profile info page
                });
              },
            ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _currentStep == 0 ? _buildLoginPage() : _buildCategorySelectionPage(),
      ),
    );
  }

  // STEP 0: Detailed Customer Login / Address Parameter Screen
  Widget _buildLoginPage() {
    return SingleChildScrollView(
      key: const ValueKey('LoginPage'),
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.assignment_ind, size: 70, color: oliveGreen),
                const SizedBox(height: 12),
                const Text(
                  'Customer Onboarding',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: oliveGreen),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Please enter your operational address details to display proximate utility options.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                
                // Primary Profile Metrics Fields
                _buildTextField(_nameController, 'Full Name', Icons.person),
                _buildTextField(_phoneController, 'Phone Number', Icons.phone, keyboardType: TextInputType.phone),
                
                const SizedBox(height: 12),
                const Text(
                  'House Address Specifications',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: oliveGreen),
                ),
                const Divider(color: oliveGreen, thickness: 1),
                const SizedBox(height: 8),

                // Structured Granular Address Inputs
                Row(
                  children: [
                    Expanded(child: _buildTextField(_doorNoController, 'Door No.', Icons.home)),
                    const SizedBox(width: 12),
                    Expanded(flex: 2, child: _buildTextField(_streetController, 'Street Name', Icons.add_road)),
                  ],
                ),
                _buildAreaTextField(),
                Row(
                  children: [
                    Expanded(child: _buildTextField(_districtController, 'District', Icons.map)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildTextField(_stateController, 'State', Icons.flag)),
                  ],
                ),
                const SizedBox(height: 24),

                // Forward Step Trigger Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: oliveGreen,
                    foregroundColor: creamBackground,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _currentStep = 1; // Transitions view smoothly onto utility matrix view
                      });
                    }
                  },
                  child: const Text('Continue to Dashboard', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // STEP 1: Main Customer Utility Selection Dashboard Layout
  Widget _buildCategorySelectionPage() {
    return Padding(
      key: const ValueKey('CategoryPage'),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting Message Displaying Context Data Hooked From Former Login View State
          Row(
            children: [
              CircleAvatar(
                backgroundColor: oliveGreen,
                child: Text(
                  _nameController.text.isNotEmpty ? _nameController.text[0].toUpperCase() : 'C',
                  style: const TextStyle(color: creamBackground, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, ${_nameController.text.isNotEmpty ? _nameController.text : "Customer"}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: oliveGreen),
                    ),
                    Text(
                      'Service Target: ${_doorNoController.text}, ${_streetController.text}, ${_areaController.text}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Select a Service Category:',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: oliveGreen),
          ),
          const SizedBox(height: 16),

          // Render operational options in a modular responsive Grid Layout
          Expanded(
            child: GridView.builder(
              itemCount: _categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              itemBuilder: (context, index) {
                final category = _categories[index];
                return InkWell(
                  onTap: () {
                    // Show confirmation notification detailing your active workflow
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: oliveGreen,
                        content: Text(
                          'Searching dynamic technicians available for ${category['name']}...',
                          style: const TextStyle(color: creamBackground),
                        ),
                      ),
                    );
                  },
                  child: Card(
                    color: creamCardColor,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: oliveGreen, width: 1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(category['icon'], size: 40, color: oliveGreen),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            category['name'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: oliveGreen),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Reusable Component to generate standardized text inputs cleanly
  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '$label is mandatory';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: oliveGreen),
          prefixIcon: Icon(icon, color: oliveGreen),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: oliveGreen, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: oliveGreen.withOpacity(0.5), width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildAreaTextField() {
    return _buildTextField(_areaController, 'Village / Urban Name', Icons.location_city);
  }
}