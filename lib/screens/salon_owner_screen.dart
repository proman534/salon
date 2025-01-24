import 'package:flutter/material.dart';

class SalonOwnerScreen extends StatelessWidget {
  const SalonOwnerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Salon Owner Home")),
      body: const Center(child: Text("Welcome, Salon Owner!")),
    );
  }
}
