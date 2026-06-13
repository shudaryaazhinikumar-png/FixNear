import 'package:flutter/material.dart';

class CustomerDashboard extends StatefulWidget {
  const CustomerDashboard({Key? key}) : super(key: key);

  @override
  State<CustomerDashboard> createState() => _CustomerDashboardState();
}

class _CustomerDashboardState extends State<CustomerDashboard> {
  // Navigation Steps:
  // 0: Login/Registration Profile Form
  // 1: Category Selection
  // 2: Deep Issue Selection & Live Provider Board
  // 3: Live Mock Tracking Map Simulation
  // 4: Secure Billing Checkout
  // 5: Final Checklist ("Payment Successful")
  int _currentStep = 0;

  // Persistent TextEditingControllers to hold entered form data automatically
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _doorNoController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // Custom Olive Green and Cream Palette Design Constants
  static const Color oliveGreen = Color(0xFF556B2F);
  static const Color creamBackground = Color(0xFFFDFBF7);
  static const Color creamCardColor = Color(0xFFFFFDD0);

  // Service Categories
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Electrical', 'icon': Icons.flash_on},
    {'name': 'Plumbing', 'icon': Icons.water_drop},
    {'name': 'Borewell Services', 'icon': Icons.waves},
    {'name': 'Underground Water Tank', 'icon': Icons.layers},
    {'name': 'Public Complaints', 'icon': Icons.gavel},
  ];

  // Selected Service Configs
  String? _selectedCategory;
  String? _selectedIssue;
  Map<String, dynamic>? _selectedProvider;

  // Mock Issues Ledger based on selection
  final Map<String, List<String>> _issuesMap = {
    'Electrical': ['Fuse replacement', 'Wiring fault', 'High voltage issue', 'Switchboard repair'],
    'Plumbing': ['Broken pipeline', 'Leakage', 'Drain blockage'],
    'Borewell Services': ['Borewell motor repair', 'Pump maintenance'],
    'Underground Water Tank': ['Motor repair', 'Starter issue'],
    'Public Complaints': ['Government water pipeline leakage'],
  };

  // Mock Provider Proximity List
  final List<Map<String, dynamic>> _providers = [
    {'name': 'Kumar', 'status': 'Available', 'rating': '4.8', 'distance': '2 km', 'isAvailable': true},
    {'name': 'Ravi', 'status': 'Available', 'rating': '4.5', 'distance': '3 km', 'isAvailable': true},
    {'name': 'Mani', 'status': 'Busy', 'rating': '4.9', 'distance': '1.5 km', 'isAvailable': false},
  ];

  String _selectedPaymentMethod = 'UPI';

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
        title: const Text(
          'FixNear - Customer Dashboard',
          style: TextStyle(color: creamBackground, fontWeight: FontWeight.bold),
        ),
        backgroundColor: oliveGreen,
        actions: [
          if (_currentStep > 0)
            IconButton(
              icon: const Icon(Icons.account_circle, color: creamBackground, size: 28),
              tooltip: 'View Profile Registry',
              onPressed: () {
                setState(() {
                  _currentStep = 0; // Navigates back to display the saved user details
                });
              },
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: _buildCurrentWorkflowView(),
        ),
      ),
    );
  }

  Widget _buildCurrentWorkflowView() {
    switch (_currentStep) {
      case 0:
        return _buildProfileLoginForm();
      case 1:
        return _buildCategorySelection();
      case 2:
        return _buildDeepIssueAndProviderSelection();
      case 3:
        return _buildMockTrackingMap();
      case 4:
        return _buildBillingCheckout();
      case 5:
        return _buildPaymentSuccessView();
      default:
        return _buildProfileLoginForm();
    }
  }

  // STEP 0: Persistent Profile / Login UI
  Widget _buildProfileLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Customer Profile Registration',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: oliveGreen),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Your data is retained seamlessly across workflow screens.',
            style: TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          _buildTextField(_nameController, 'Full Name', Icons.person),
          _buildTextField(_phoneController, 'Phone Number', Icons.phone, keyboardType: TextInputType.phone),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Divider(color: oliveGreen, thickness: 1),
          ),
          const Text(
            'Service Dispatch Address',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: oliveGreen),
          ),
          const SizedBox(height: 12),
          _buildTextField(_doorNoController, 'Door No / House Flat No', Icons.home),
          _buildTextField(_streetController, 'Street Name', Icons.add_road),
          _buildTextField(_areaController, 'Village / Urban Area Name', Icons.location_city),
          _buildTextField(_districtController, 'District', Icons.map),
          _buildTextField(_stateController, 'State', Icons.flag),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: oliveGreen,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  _currentStep = 1; // Shifts smoothly to category index mapping
                });
              }
            },
            child: const Text('Proceed to Services', style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  // STEP 1: Category Selection UI
  Widget _buildCategorySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Welcome back, ${_nameController.text}!',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: oliveGreen),
        ),
        const SizedBox(height: 4),
        const Text('Select a utility category to isolate your house breakdown:', style: TextStyle(color: Colors.black87)),
        const SizedBox(height: 20),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final cat = _categories[index];
            return Card(
              color: creamCardColor,
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: Icon(cat['icon'], color: oliveGreen, size: 28),
                title: Text(cat['name'], style: const TextStyle(fontWeight: FontWeight.bold, color: oliveGreen)),
                trailing: const Icon(Icons.arrow_forward_ios, color: oliveGreen, size: 16),
                onTap: () {
                  setState(() {
                    _selectedCategory = cat['name'];
                    _selectedIssue = _issuesMap[_selectedCategory]![0]; // Set default issue
                    _currentStep = 2;
                  });
                },
              ),
            );
          },
        ),
      ],
    );
  }

  // STEP 2: Deep Issue & Provider Selection Board
  Widget _buildDeepIssueAndProviderSelection() {
    final issues = _issuesMap[_selectedCategory] ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Category: $_selectedCategory',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: oliveGreen),
        ),
        const SizedBox(height: 16),
        const Text('Specify the exact household breakdown issue:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: oliveGreen.withOpacity(0.5)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedIssue,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: oliveGreen),
              items: issues.map((String issue) {
                return DropdownMenuItem<String>(
                  value: issue,
                  child: Text(issue),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedIssue = value;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text('Trusted Live Provider Status Dashboard:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _providers.length,
          itemBuilder: (context, index) {
            final provider = _providers[index];
            bool isAvail = provider['isAvailable'];
            return Card(
              color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: oliveGreen.withOpacity(0.2)),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: oliveGreen.withOpacity(0.1),
                  child: Text(provider['name'][0], style: const TextStyle(color: oliveGreen, fontWeight: FontWeight.bold)),
                ),
                title: Row(
                  children: [
                    Text(provider['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Text(
                      isAvail ? '🟢 Available' : '🟠 Busy',
                      style: TextStyle(fontSize: 12, color: isAvail ? Colors.green : Colors.orange),
                    ),
                  ],
                ),
                subtitle: Text('Rating: ⭐ ${provider['rating']} | Proximity: ${provider['distance']}'),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isAvail ? oliveGreen : Colors.grey,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: isAvail
                      ? () {
                          setState(() {
                            _selectedProvider = provider;
                            _currentStep = 3; // Shift to maps setup tracking
                          });
                        }
                      : null,
                  child: const Text('Book', style: TextStyle(color: Colors.white)),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // STEP 3: Live Mock Tracking Map Simulation
  Widget _buildMockTrackingMap() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Live Dispatch Map Simulation', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: oliveGreen)),
        const SizedBox(height: 4),
        Text('Tracking assigned technician: ${_selectedProvider?['name']}', style: const TextStyle(color: Colors.black54)),
        const SizedBox(height: 16),
        Container(
          height: 250,
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.blue.withOpacity(0.5), width: 2),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.map_rounded, size: 60, color: Colors.blue),
                  const SizedBox(height: 12),
                  const Text('[ Google Maps GPS Connector Placeholder ]', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                  const SizedBox(height: 4),
                  Text('Technician is currently ${_selectedProvider?['distance']} away from house address.', style: const TextStyle(fontSize: 12, color: Colors.black45)),
                ],
              ),
              Positioned(
                top: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]),
                  child: const Text('⚡ Simulating GPS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green)),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: oliveGreen,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          icon: const Icon(Icons.payment, color: Colors.white),
          label: const Text('Proceed to Secure Billing', style: TextStyle(color: Colors.white, fontSize: 16)),
          onPressed: () {
            setState(() {
              _currentStep = 4;
            });
          },
        ),
      ],
    );
  }

  // STEP 4: Secure Billing Checkout UI (with address data verified again)
  Widget _buildBillingCheckout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Secure Invoice Summary', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: oliveGreen)),
        const SizedBox(height: 16),
        Card(
          color: creamCardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('SERVICE DETAILS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54)),
                const SizedBox(height: 6),
                Text('Category: $_selectedCategory', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text('Task Component: $_selectedIssue'),
                Text('Assigned Expert: ${_selectedProvider?['name']} (Rating: ⭐ ${_selectedProvider?['rating']})'),
                const Divider(height: 24),
                const Text('DISPATCH GATEWAY PERMANENT ADDRESS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54)),
                const SizedBox(height: 6),
                // Data appears accurately pulled back from initial text field state
                Text('Customer Name: ${_nameController.text}', style: const TextStyle(fontWeight: FontWeight.w600)),
                Text('Phone Connection: ${_phoneController.text}'),
                Text('Address Line: No. ${_doorNoController.text}, ${_streetController.text}, ${_areaController.text}'),
                Text('Region: ${_districtController.text}, ${_stateController.text}'),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Standard Platform Fare:', style: TextStyle(fontWeight: FontWeight.w500)),
                    Text('₹499.00', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text('Select Payment Mechanism:', style: TextStyle(fontWeight: FontWeight.bold, color: oliveGreen)),
        const SizedBox(height: 8),
        _buildPaymentRadioOption('UPI (GPay / PhonePe)'),
        _buildPaymentRadioOption('Cash on Service Delivery'),
        _buildPaymentRadioOption('Debit Card'),
        _buildPaymentRadioOption('Credit Card'),
        const SizedBox(height: 24),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: oliveGreen,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () {
            setState(() {
              _currentStep = 5;
            });
          },
          child: Text('Authorize Fare Payment VIA $_selectedPaymentMethod', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  // STEP 5: Final Checklist Checkmark Screen
  Widget _buildPaymentSuccessView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 40),
        const CircleAvatar(
          radius: 50,
          backgroundColor: Colors.green,
          child: Icon(Icons.check, size: 60, color: Colors.white),
        ),
        const SizedBox(height: 24),
        const Text(
          'Payment Successful',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
        ),
        const SizedBox(height: 12),
        Text(
          'Thank you, ${_nameController.text}! Your local utility service request has been transmitted successfully to ${_selectedProvider?['name']}.',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15),
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: oliveGreen,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () {
            setState(() {
              // Wipes out transactional selections, but holds onto the primary layout profile form data parameters!
              _selectedCategory = null;
              _selectedIssue = null;
              _selectedProvider = null;
              _currentStep = 0;
            });
          },
          child: const Text('Return to Profile Home', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  // Custom Form Field Generator Component
  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: oliveGreen),
          labelStyle: const TextStyle(color: Colors.black54),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: oliveGreen.withOpacity(0.3), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: oliveGreen, width: 2),
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
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please fill in your $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPaymentRadioOption(String value) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: RadioListTile<String>(
        title: Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        value: value,
        groupValue: _selectedPaymentMethod,
        activeColor: oliveGreen,
        onChanged: (val) {
          setState(() {
            _selectedPaymentMethod = val!;
          });
        },
      ),
    );
  }
}