import 'package:flutter/material.dart';
import 'package:startup/base.dart';

class CustomerHomeScreen extends StatelessWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Customer Home',
      appBar: AppBar(title: const Text("Customer Home")),
      body: const Center(child: Text("Welcome, Customer!")),
    );
  }
}
