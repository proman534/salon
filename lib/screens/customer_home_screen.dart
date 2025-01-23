import 'package:flutter/material.dart';
import 'package:startup/base.dart';

class CustomerHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Customer Home',
      appBar: AppBar(title: Text("Customer Home")),
      body: Center(child: Text("Welcome, Customer!")),
    );
  }
}
