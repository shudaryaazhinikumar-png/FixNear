import 'package:flutter/material.dart';
import 'screens/role_selection_screen.dart'; // Handles the onboarding split

void main() {
  runApp(const FixNearApp());
}

class FixNearApp extends StatelessWidget {
  const FixNearApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FixNear - Coimbatore',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const RoleSelectionScreen(), // Sets landing gate
    );
  }
}